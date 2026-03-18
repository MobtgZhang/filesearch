import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs
import "../theme" 1.0

// 重复文件扫描页面：目录选择、扫描选项、结果分组展示、批量操作
Rectangle {
    id: duplicatePage
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

    property int hashAlgoIndex: 0
    property int fileTypeIndex: 0
    property int minSizeIndex: 0

    function getMinSizeBytes() {
        if (minSizeIndex === 1) return 1024
        if (minSizeIndex === 2) return 102400
        if (minSizeIndex === 3) return 1048576
        return 0
    }

    function startScan() {
        if (typeof duplicateEngine !== "undefined" && duplicateEngine) {
            var path = AppController.resolveSearchPath()
            if (path.length > 0) {
                DuplicateContext.isScanning = true
                DuplicateContext.duplicateGroupsList = []
                Qt.callLater(function() {
                    if (DuplicateContext.isScanning)
                        duplicateEngine.scan(path, hashAlgoIndex, fileTypeIndex, getMinSizeBytes())
                })
            }
        }
    }

    function stopScan() {
        DuplicateContext.isScanning = false
        if (typeof duplicateEngine !== "undefined" && duplicateEngine) {
            duplicateEngine.stop()
        }
    }

    function calcWastedSize() {
        var total = 0
        for (var i = 0; i < DuplicateContext.duplicateGroupsList.length; i++) {
            var g = DuplicateContext.duplicateGroupsList[i]
            var cnt = g.count || 0
            var sz = g.size || 0
            if (cnt > 1) total += sz * (cnt - 1)
        }
        return total
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // ── 顶部：标题 + 扫描选项 ──
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 120
            color: "transparent"
            border.color: Theme.border
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 14
                spacing: 10

                Text {
                    font.pixelSize: 11
                    font.weight: Font.Bold
                    font.letterSpacing: 0.12
                    font.family: Theme.fontFamily
                    color: Theme.muted
                    text: "重复文件扫描"
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    Text { font.pixelSize: 10; color: Theme.muted; text: "目录:" }
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
                    Binding { target: dirFilterMenu; property: "currentIndex"; value: AppController.searchDirectoryIndex }
                    Binding { target: dirFilterMenu; property: "customSelection"; value: AppController.searchDirectoryCustom }

                    Text { font.pixelSize: 10; color: Theme.muted; text: "类型:" }
                    FilterPopMenu {
                        id: typeFilterMenu
                        label: "类型"
                        chipColor: Theme.accent2
                        model: ["全部", "图片", "视频", "文档", "压缩包"]
                        currentIndex: fileTypeIndex
                        onSelected: function(idx) { fileTypeIndex = idx }
                    }

                    Text { font.pixelSize: 10; color: Theme.muted; text: "最小:" }
                    FilterPopMenu {
                        id: minSizeMenu
                        label: "最小"
                        chipColor: Theme.accent4
                        model: ["不限制", "跳过 < 1KB", "跳过 < 100KB", "跳过 < 1MB"]
                        currentIndex: minSizeIndex
                        onSelected: function(idx) { minSizeIndex = idx }
                    }

                    Text { font.pixelSize: 10; color: Theme.muted; text: "哈希:" }
                    FilterPopMenu {
                        id: hashMenu
                        label: "哈希"
                        chipColor: Theme.accent3
                        model: ["MD5 (快)", "SHA1", "SHA256"]
                        currentIndex: hashAlgoIndex
                        onSelected: function(idx) { hashAlgoIndex = idx }
                    }

                    Item { Layout.fillWidth: true }

                    Button {
                        text: DuplicateContext.isScanning ? "停止扫描" : "开始扫描"
                        font.pixelSize: 11
                        font.family: Theme.fontFamily
                        implicitHeight: 28
                        implicitWidth: 88
                        background: Rectangle {
                            color: DuplicateContext.isScanning
                                 ? (parent.pressed ? Qt.darker(Theme.accent3, 1.2) : (parent.hovered ? Qt.lighter(Theme.accent3, 1.1) : Theme.accent3))
                                 : (parent.pressed ? Qt.darker(Theme.accent, 1.2) : (parent.hovered ? Qt.lighter(Theme.accent, 1.1) : Theme.accent))
                            radius: 6
                            border.color: DuplicateContext.isScanning
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
                        onClicked: DuplicateContext.isScanning ? stopScan() : startScan()
                    }
                }

                // 进度条
                RowLayout {
                    Layout.fillWidth: true
                    visible: DuplicateContext.isScanning
                    spacing: 12

                    ProgressBar {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 6
                        from: 0
                        to: 100
                        value: 0
                        indeterminate: true
                        background: Rectangle {
                            implicitWidth: 200
                            implicitHeight: 6
                            color: Qt.rgba(Theme.border.r, Theme.border.g, Theme.border.b, 0.3)
                            radius: 3
                        }
                        contentItem: Item {
                            implicitWidth: 200
                            implicitHeight: 6
                            Rectangle {
                                width: parent.width * 0.4
                                height: parent.height
                                radius: 3
                                color: Theme.accent
                                SequentialAnimation on x {
                                    loops: Animation.Infinite
                                    NumberAnimation { from: 0; to: parent.width - width; duration: 1200 }
                                    NumberAnimation { from: parent.width - width; to: 0; duration: 1200 }
                                }
                            }
                        }
                    }
                    Text {
                        font.pixelSize: 10
                        font.family: Theme.fontFamily
                        color: Theme.muted
                        text: "已扫描 " + DuplicateContext.scannedFiles + " 个文件 · " +
                              DuplicateContext.duplicateGroups + " 组重复 · " +
                              (DuplicateContext.elapsedMs / 1000).toFixed(1) + "s"
                    }
                }
            }
        }

        // ── 结果区域 ──
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Theme.bg

            ColumnLayout {
                anchors.fill: parent
                spacing: 0

                // 结果摘要栏
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 36
                    color: Qt.rgba(Theme.surface.r, Theme.surface.g, Theme.surface.b, 0.6)
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
                            text: DuplicateContext.duplicateGroupsList.length > 0
                                 ? "共 " + DuplicateContext.duplicateGroupsList.length + " 组重复 · " +
                                   DuplicateContext.totalScanned + " 个文件已扫描 · " +
                                   DuplicateContext.formatSize(duplicatePage.calcWastedSize()) + " 可释放"
                                 : (DuplicateContext.isScanning ? "扫描中..." : "选择目录并点击「开始扫描」查找重复文件")
                        }

                        Item { Layout.fillWidth: true }
                    }
                }

                // 重复组列表
                Flickable {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    contentWidth: resultColumn.width
                    contentHeight: resultColumn.height
                    boundsBehavior: Flickable.StopAtBounds

                    ScrollBar.vertical: ScrollBar {
                        policy: ScrollBar.AsNeeded
                        width: 12
                        contentItem: Rectangle {
                            implicitWidth: 12
                            radius: 6
                            color: Qt.rgba(Theme.border.r, Theme.border.g, Theme.border.b, 0.5)
                            opacity: 0.8
                        }
                    }

                    Column {
                        id: resultColumn
                        width: duplicatePage.width - 20
                        spacing: 0

                        Repeater {
                            model: DuplicateContext.duplicateGroupsList

                            Column {
                                width: parent.width - 20
                                x: 10

                                // 组标题（可展开）
                                Rectangle {
                                    width: parent.width - 20
                                    height: 40
                                    color: groupArea.containsMouse ? Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.06) : Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.03)
                                    border.color: Qt.rgba(Theme.border.r, Theme.border.g, Theme.border.b, 0.4)
                                    border.width: 1
                                    radius: 6

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.margins: 12
                                        spacing: 8

                                        Text {
                                            font.pixelSize: 14
                                            color: Theme.accent
                                            text: groupExpanded ? "▼" : "▶"
                                        }
                                        Text {
                                            font.pixelSize: 12
                                            font.family: Theme.fontFamily
                                            color: Theme.text
                                            text: "第 " + (index + 1) + " 组 · " + (modelData.count || 0) + " 个相同文件 · " + DuplicateContext.formatSize(modelData.size || 0)
                                        }
                                        Item { Layout.fillWidth: true }
                                        Button {
                                            text: "保留第一个"
                                            font.pixelSize: 10
                                            implicitHeight: 24
                                            visible: groupExpanded && (modelData.count || 0) > 1
                                            background: Rectangle {
                                                color: parent.pressed ? Qt.darker(Theme.surface, 1.1) : (parent.hovered ? Qt.lighter(Theme.surface, 1.05) : Theme.surface)
                                                radius: 4
                                                border.color: Theme.border
                                            }
                                            contentItem: Text {
                                                text: parent.text
                                                font: parent.font
                                                color: Theme.text
                                                horizontalAlignment: Text.AlignHCenter
                                                verticalAlignment: Text.AlignVCenter
                                            }
                                            onClicked: { /* TODO: 标记保留第一个，其余待删 */ }
                                        }
                                    }

                                    MouseArea {
                                        id: groupArea
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        onClicked: groupExpanded = !groupExpanded
                                    }
                                }

                                property bool groupExpanded: true

                                // 组内文件列表
                                Repeater {
                                    model: groupExpanded ? (modelData.files || []) : []
                                    delegate: Rectangle {
                                        width: parent.width - 20
                                        x: 20
                                        height: 36
                                        color: fileArea.containsMouse ? Qt.rgba(Theme.border.r, Theme.border.g, Theme.border.b, 0.15) : "transparent"
                                        border.color: Qt.rgba(Theme.border.r, Theme.border.g, Theme.border.b, 0.2)
                                        border.width: 1

                                        RowLayout {
                                            anchors.fill: parent
                                            anchors.margins: 12
                                            spacing: 8

                                            Text {
                                                font.pixelSize: 11
                                                color: modelData.path ? Theme.bright : Theme.muted
                                                text: (modelData.name || "") + (index === 0 ? " ✓ 保留" : "")
                                                elide: Text.ElideMiddle
                                                Layout.fillWidth: true
                                            }
                                            Text {
                                                font.pixelSize: 10
                                                font.family: Theme.fontFamily
                                                color: Theme.muted
                                                text: DuplicateContext.formatSize(modelData.size || 0)
                                            }
                                            Button {
                                                text: index === 0 ? "—" : "删除"
                                                font.pixelSize: 10
                                                implicitHeight: 22
                                                implicitWidth: 48
                                                visible: index > 0
                                                background: Rectangle {
                                                    color: parent.pressed ? Qt.darker(Theme.accent3, 1.2) : (parent.hovered ? Qt.lighter(Theme.accent3, 0.9) : Qt.rgba(Theme.accent3.r, Theme.accent3.g, Theme.accent3.b, 0.15))
                                                    radius: 4
                                                    border.color: Qt.rgba(Theme.accent3.r, Theme.accent3.g, Theme.accent3.b, 0.4)
                                                }
                                                contentItem: Text {
                                                    text: parent.text
                                                    font: parent.font
                                                    color: Theme.accent3
                                                    horizontalAlignment: Text.AlignHCenter
                                                    verticalAlignment: Text.AlignVCenter
                                                }
                                                onClicked: {
                                                    if (typeof fileOperationService !== "undefined" && fileOperationService && modelData.path) {
                                                        fileOperationService.deleteFiles([modelData.path], false)
                                                    }
                                                }
                                            }
                                        }

                                        MouseArea {
                                            id: fileArea
                                            anchors.fill: parent
                                            hoverEnabled: true
                                        }

                                        ToolTip.visible: fileArea.containsMouse
                                        ToolTip.text: modelData.path || ""
                                        ToolTip.delay: 500
                                    }
                                }
                            }
                        }

                        // 空状态
                        Item {
                            width: parent.width - 20
                            height: 200
                            visible: !DuplicateContext.isScanning && DuplicateContext.duplicateGroupsList.length === 0

                            Column {
                                anchors.centerIn: parent
                                spacing: 12

                                Text {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    font.pixelSize: 48
                                    color: Qt.rgba(Theme.muted.r, Theme.muted.g, Theme.muted.b, 0.5)
                                    text: "⧉"
                                }
                                Text {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    font.pixelSize: 13
                                    font.family: Theme.fontFamily
                                    color: Theme.muted
                                    text: "暂无重复文件"
                                }
                                Text {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    font.pixelSize: 11
                                    color: Theme.muted
                                    text: "选择目录并点击「开始扫描」开始查找"
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
