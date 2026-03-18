import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs
import "../theme" 1.0

Rectangle {
    id: searchBar
    Layout.fillWidth: true
    Layout.preferredHeight: Theme.searchBarHeight
    clip: false  // 允许 Pop 菜单溢出显示
    color: Theme.panel
    border.color: Theme.border
    border.width: 1

    FolderDialog {
        id: folderDialog
        title: "选择查找目录"
        acceptLabel: "选择"
        rejectLabel: "取消"
        onAccepted: {
            var path = selectedFolder.toString()
            if (path.startsWith("file://"))
                path = path.substring(7)
            dirFilterMenu.customSelection = path
            dirFilterMenu.currentIndex = 2
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        anchors.topMargin: 10
        anchors.bottomMargin: 10
        spacing: 12
        layoutDirection: Qt.LeftToRight

        Text {
            text: "⌕"
            font.pixelSize: 18
            color: Theme.accent
            Layout.alignment: Qt.AlignVCenter
        }

        // 搜索输入框 + 查找按钮
        Rectangle {
            Layout.fillWidth: true
            Layout.minimumWidth: 120
            Layout.preferredHeight: 34
            Layout.alignment: Qt.AlignVCenter
            radius: 8
            clip: true
            color: Theme.surface
            border.color: Theme.border
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 4
                anchors.topMargin: 4
                anchors.bottomMargin: 4
                spacing: 8

                TextField {
                    id: searchInput
                    Layout.fillWidth: true
                    Layout.minimumWidth: 60
                    Layout.alignment: Qt.AlignVCenter
                    placeholderText: "输入搜索条件..."
                    text: "*.mp4  size:>500MB"
                    font.family: Theme.fontFamily
                    font.pixelSize: 13
                    color: Theme.bright
                    background: Item {}
                    verticalAlignment: TextInput.AlignVCenter
                    topPadding: 4
                    bottomPadding: 4
                    leftPadding: 4
                    rightPadding: 4
                }

                Text {
                    font.family: Theme.fontFamily
                    font.pixelSize: 11
                    color: Theme.muted
                    text: "— 找到 23 个结果，共 48.6 GB"
                    Layout.alignment: Qt.AlignVCenter
                }

                // 查找按钮
                Rectangle {
                    Layout.preferredWidth: 72
                    Layout.preferredHeight: 26
                    Layout.alignment: Qt.AlignVCenter
                    radius: 6
                    color: searchBtnMa.containsMouse ? Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.25) : Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.15)
                    border.color: Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.4)
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        font.pixelSize: 12
                        font.weight: Font.DemiBold
                        color: Theme.accent
                        text: "查找"
                    }

                    MouseArea {
                        id: searchBtnMa
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: { /* 执行搜索 */ }
                    }
                }
            }
        }

        // 筛选 Pop 菜单：查找目录、类型、大小、最近 XX 天
        Row {
            spacing: 8
            Layout.alignment: Qt.AlignVCenter

            FilterPopMenu {
                id: dirFilterMenu
                label: "📁 查找目录"
                chipColor: Theme.accent
                model: ["全部磁盘", "当前目录", "选择目录...", "桌面", "文档", "下载"]
                currentIndex: 0
                onItemClicked: function(idx, text) {
                    if (text === "选择目录...") {
                        folderDialog.open()
                        return true
                    }
                    return false
                }
                onSelected: function(idx) {
                    if (idx !== 2)
                        dirFilterMenu.customSelection = ""
                    /* 更新搜索目录 */
                }
            }

            FilterPopMenu {
                label: "类型"
                chipColor: Theme.accent2
                model: ["全部", "视频", "文档", "图片", "音频", "压缩包", "可执行文件"]
                currentIndex: 1
                onSelected: function(idx) { /* 更新类型筛选 */ }
            }

            FilterPopMenu {
                label: "大小"
                chipColor: Theme.accent3
                model: ["全部", "> 100 MB", "> 500 MB", "> 1 GB", "> 10 GB", "< 1 MB"]
                currentIndex: 2
                onSelected: function(idx) { /* 更新大小筛选 */ }
            }

            FilterPopMenu {
                label: "最近"
                chipColor: Theme.accent4
                model: ["全部", "7 天", "30 天", "90 天", "1 年"]
                currentIndex: 3
                onSelected: function(idx) { /* 更新时间筛选 */ }
            }
        }
    }
}
