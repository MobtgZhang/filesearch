import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../theme" 1.0

Rectangle {
    id: statusBar
    Layout.fillWidth: true
    Layout.preferredHeight: Theme.statusBarHeight
    color: Theme.surface
    border.color: Theme.border
    border.width: 1

    RowLayout {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 0

        StatusItem {
            dot: true
            text: "已索引 "
            accentText: "1,284,392"
            suffix: " 个文件"
        }

        Rectangle {
            Layout.preferredWidth: 70
            Layout.preferredHeight: 18
            Layout.rightMargin: 14
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

        Rectangle {
            Layout.preferredWidth: 1
            Layout.preferredHeight: 12
            Layout.leftMargin: 14
            Layout.rightMargin: 14
            color: Theme.border
        }

        StatusItem {
            text: "搜索耗时 "
            accentText: "12ms"
        }

        StatusItem {
            text: "磁盘已用 "
            accentText: "847 GB / 1 TB"
            warn: true
        }

        Rectangle {
            Layout.preferredWidth: 80
            Layout.preferredHeight: 4
            radius: 2
            color: Theme.border

            Rectangle {
                width: parent.width * 0.85
                height: parent.height
                radius: 2
                gradient: Gradient {
                    GradientStop { position: 0; color: Theme.accent }
                    GradientStop { position: 1; color: Theme.accent2 }
                }
            }
        }

        Item { Layout.fillWidth: true }

        StatusItem {
            text: "文件监听 "
            accentText: "活跃"
            showBorder: false
        }

        StatusItem {
            text: "Qt 6.7 · Linux · x86_64"
            showBorder: false
        }
    }
}
