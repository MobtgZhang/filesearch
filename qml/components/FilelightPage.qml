import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs
import "../theme" 1.0

// Filelight 风格磁盘可视化独立页面：环形树状图 + 目录选择
Rectangle {
    id: filelightPage
    color: Theme.panel
    border.color: Theme.border
    border.width: 1

    FolderDialog {
        id: folderDialog
        title: "选择扫描目录"
        acceptLabel: "选择"
        rejectLabel: "取消"
        onAccepted: {
            var path = selectedFolder.toString()
            if (path.startsWith("file://"))
                path = path.substring(7)
            AppController.searchDirectoryCustom = path
            AppController.searchDirectoryIndex = 4
            dirFilterMenu.customSelection = path
            dirFilterMenu.currentIndex = 4
        }
    }

    function startScan() {
        if (typeof scanEngine !== "undefined" && scanEngine) {
            var path = AppController.resolveSearchPath()
            if (path.length > 0) {
                AppController.isScanning = true
                // 使用 Qt.callLater 确保 UI 先更新，避免点击时卡顿
                Qt.callLater(function() {
                    if (AppController.isScanning)
                        scanEngine.scan(path)
                })
            }
        }
    }

    function stopScan() {
        AppController.isScanning = false
        if (typeof scanEngine !== "undefined" && scanEngine) {
            scanEngine.stop()
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // 顶部：标题 + 目录选择
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 72
            color: "transparent"
            border.color: Theme.border
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 14
                spacing: 8

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    Text {
                        font.pixelSize: 11
                        font.weight: Font.Bold
                        font.letterSpacing: 0.12
                        font.family: Theme.fontFamily
                        color: Theme.muted
                        text: "磁盘可视化 · Filelight 风格"
                    }

                    Item { Layout.fillWidth: true }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 6

                    Text {
                        font.pixelSize: 10
                        color: Theme.muted
                        text: "目录:"
                    }

                    FilterPopMenu {
                        id: dirFilterMenu
                        label: "目录"
                        chipColor: Theme.accent
                        model: ["主目录", "桌面", "文档", "下载", "选择目录..."]
                        currentIndex: AppController.searchDirectoryIndex
                        customSelection: AppController.searchDirectoryCustom
                        onItemClicked: function(idx, text) {
                            if (text === "选择目录...") {
                                folderDialog.open()
                                return true
                            }
                            return false
                        }
                        onSelected: function(idx) {
                            if (idx !== 4) {
                                AppController.searchDirectoryCustom = ""
                                dirFilterMenu.customSelection = ""
                            }
                            AppController.searchDirectoryIndex = idx
                        }
                    }

                    Binding {
                        target: dirFilterMenu
                        property: "currentIndex"
                        value: AppController.searchDirectoryIndex
                    }
                    Binding {
                        target: dirFilterMenu
                        property: "customSelection"
                        value: AppController.searchDirectoryCustom
                    }

                    Item { Layout.fillWidth: true }

                    Button {
                        visible: diskView && diskView.focusedPath.length > 0
                        text: "返回上级"
                        font.pixelSize: 11
                        font.family: Theme.fontFamily
                        implicitHeight: 28
                        implicitWidth: 72
                        background: Rectangle {
                            color: parent.pressed ? Qt.darker(Theme.surface, 1.1) : (parent.hovered ? Qt.lighter(Theme.surface, 1.05) : Theme.surface)
                            radius: 6
                            border.color: Theme.border
                        }
                        contentItem: Text {
                            text: parent.text
                            font: parent.font
                            color: Theme.text
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        onClicked: diskView.focusedPath = ""
                    }

                    Button {
                        text: AppController.isScanning ? "停止扫描" : "开始扫描"
                        font.pixelSize: 11
                        font.family: Theme.fontFamily
                        implicitHeight: 28
                        implicitWidth: 88
                        background: Rectangle {
                            color: AppController.isScanning
                                 ? (parent.pressed ? Qt.darker(Theme.accent3, 1.2) : (parent.hovered ? Qt.lighter(Theme.accent3, 1.1) : Theme.accent3))
                                 : (parent.pressed ? Qt.darker(Theme.accent, 1.2) : (parent.hovered ? Qt.lighter(Theme.accent, 1.1) : Theme.accent))
                            radius: 6
                            border.color: AppController.isScanning
                                 ? Qt.rgba(Theme.accent3.r, Theme.accent3.g, Theme.accent3.b, 0.5)
                                 : Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.5)
                        }
                        contentItem: Text {
                            text: parent.text
                            font: parent.font
                            color: Theme.bg
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        onClicked: AppController.isScanning ? stopScan() : startScan()
                    }
                }
            }
        }

        // 环形树状图（占满剩余空间）
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 20

            FilelightDiskView {
                id: diskView
                anchors.fill: parent
                directoryTree: FilelightContext.directoryTree
                usedSize: FilelightContext.usedSize
                totalSize: FilelightContext.totalSize
            }
        }

        // 底部状态
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 36
            color: Qt.rgba(Theme.surface.r, Theme.surface.g, Theme.surface.b, 0.5)
            border.color: Theme.border
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 16

                Text {
                    font.pixelSize: 10
                    font.family: Theme.fontFamily
                    color: Theme.muted
                    text: diskView.focusedPath ? "当前: " + diskView.focusedPath.replace(/^.*\//, "") + " · 点击中心圆返回上级" : "提示：点击扇区可聚焦 · 点击中心圆返回上级 · 悬停查看详情"
                }

                Item { Layout.fillWidth: true }

                Text {
                    font.pixelSize: 10
                    font.family: Theme.fontFamily
                    color: Theme.muted
                    text: "共 " + (FilelightContext.usedSize ? FilelightContext.formatSize(FilelightContext.usedSize) : "—") + " 已用"
                }
            }
        }
    }
}
