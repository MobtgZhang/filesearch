import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../theme" 1.0

Rectangle {
    id: listPanel
    Layout.fillWidth: true
    Layout.fillHeight: true
    color: Theme.bg

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // 选中操作条
        ActionBar { }

        // 列标题
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.colHeaderHeight
            color: Theme.panel
            border.color: Theme.border
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.margins: 14
                spacing: 0

                ColHeader { label: "文件名"; sort: true; width: 220 }
                ColHeader { label: "路径"; colWidth: -1; Layout.fillWidth: true }
                ColHeader { label: "类型"; width: 80 }
                ColHeader { label: "大小"; width: 80 }
                ColHeader { label: "修改时间"; width: 120 }
                Item { Layout.preferredWidth: 60 }
            }
        }

        // 文件列表
        ListView {
            id: fileListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: fileModel
            delegate: FileRowDelegate { }
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
        }
    }
}
