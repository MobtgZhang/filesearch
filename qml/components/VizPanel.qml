import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../theme" 1.0

Rectangle {
    id: vizPanel
    Layout.preferredWidth: Theme.vizPanelWidth
    Layout.fillHeight: true
    color: Theme.panel
    border.color: Theme.border
    border.width: 1

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // 面板标题
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            color: "transparent"
            border.color: Theme.border
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.margins: 14
                spacing: 8

                Text {
                    font.pixelSize: 11
                    font.weight: Font.Bold
                    font.letterSpacing: 0.12
                    color: Theme.muted
                    text: "磁盘视图"
                }

                Item { Layout.fillWidth: true }

                Row {
                    spacing: 4
                    VizTab { label: "环形图"; active: true }
                    VizTab { label: "树图"; active: false }
                }
            }
        }

        // 环形图区域
        RadialMapView { }

        // 图例
        LegendView { }

        // 树图
        TreeMapView {
            Layout.fillHeight: true
        }
    }
}
