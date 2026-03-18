import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../theme" 1.0

Popup {
    id: settingsPopup
    width: 400
    height: 280
    modal: true
    focus: true
    anchors.centerIn: parent
    padding: 0
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    background: Rectangle {
        color: Theme.surface
        border.color: Theme.border
        border.width: 1
        radius: 12
    }

    contentItem: ColumnLayout {
        spacing: 0

        // 标题
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            color: Theme.panel
            radius: 12

            RowLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 12

                Text {
                    font.pixelSize: 16
                    font.weight: Font.Bold
                    color: Theme.bright
                    text: "设置"
                }

                Item { Layout.fillWidth: true }

                Rectangle {
                    width: 28
                    height: 28
                    radius: 6
                    color: "transparent"
                    border.color: Theme.border
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        font.pixelSize: 14
                        color: Theme.muted
                        text: "×"
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: settingsPopup.close()
                    }
                }
            }
        }

        // 主题设置
        ColumnLayout {
            Layout.fillWidth: true
            Layout.margins: 20
            spacing: 16

            Text {
                font.pixelSize: 11
                font.weight: Font.Bold
                font.letterSpacing: 0.1
                color: Theme.muted
                text: "外观"
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                Text {
                    font.pixelSize: 13
                    color: Theme.text
                    text: "主题模式"
                }

                Item { Layout.fillWidth: true }

                Row {
                    spacing: 0

                    ThemeModeButton {
                        label: "深色"
                        active: (typeof appSettings !== "undefined" && appSettings) && appSettings.themeMode === "dark"
                        onClicked: {
                            if (appSettings) appSettings.themeMode = "dark"
                        }
                    }

                    ThemeModeButton {
                        label: "浅色"
                        active: (typeof appSettings !== "undefined" && appSettings) && appSettings.themeMode === "light"
                        onClicked: {
                            if (appSettings) appSettings.themeMode = "light"
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: Theme.border
            }

            Text {
                font.pixelSize: 11
                color: Theme.muted
                text: "切换主题将立即生效"
            }
        }
    }
}
