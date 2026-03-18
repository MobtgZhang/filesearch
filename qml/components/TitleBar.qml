import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../theme" 1.0

Rectangle {
    id: titleBar
    Layout.fillWidth: true
    Layout.preferredHeight: Theme.titleBarHeight
    color: Theme.surface
    border.color: Theme.border
    border.width: 1

    RowLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 8

        // 窗口按钮（macOS 风格）
        Row {
            spacing: 6
            Repeater {
                model: [
                    { color: "#ff5f57", radius: 6 },
                    { color: "#febc2e", radius: 6 },
                    { color: "#28c840", radius: 6 }
                ]
                Rectangle {
                    width: 12
                    height: 12
                    radius: 6
                    color: modelData.color
                }
            }
        }

        Text {
            Layout.leftMargin: 12
            text: "Nex<span style='color:" + Theme.accent + "'>File</span>"
            font.family: Theme.fontDisplay
            font.pixelSize: 13
            font.weight: Font.Bold
            font.letterSpacing: 0.08
            color: Theme.bright
            textFormat: Text.RichText
        }

        Item { Layout.fillWidth: true }

        Text {
            font.family: Theme.fontFamily
            font.pixelSize: 10
            font.letterSpacing: 0.1
            color: Theme.muted
            text: "已索引 1,284,392 个文件"
        }

        Rectangle {
            Layout.preferredWidth: 80
            Layout.preferredHeight: 18
            radius: 9
            color: "transparent"
            border.color: Qt.rgba(74/255, 240/255, 180/255, 0.3)
            border.width: 1

            Text {
                anchors.centerIn: parent
                font.family: Theme.fontFamily
                font.pixelSize: 10
                color: Theme.accent
                text: "✦ AI 已就绪"
            }
        }
    }
}
