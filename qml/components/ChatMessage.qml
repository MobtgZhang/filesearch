import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../theme" 1.0

ColumnLayout {
    id: msg
    property bool isUser: false
    property string label: ""
    property string text: ""
    property bool resultCard: false
    property var resultRows: []
    property string extraText: ""
    property string codeBlock: ""

    Layout.fillWidth: true
    Layout.alignment: isUser ? Qt.AlignRight : Qt.AlignLeft
    spacing: 4

    Text {
        Layout.alignment: isUser ? Qt.AlignRight : Qt.AlignLeft
        font.pixelSize: 9
        font.weight: Font.Bold
        font.letterSpacing: 0.12
        font.family: Theme.fontFamily
        color: Theme.muted
        text: msg.label
    }

    Rectangle {
        Layout.preferredWidth: parent.width - 20
        Layout.alignment: isUser ? Qt.AlignRight : Qt.AlignLeft
        Layout.maximumWidth: isUser ? parent.width * 0.9 : parent.width
        radius: 8
        color: isUser ? Qt.rgba(123/255, 111/255, 240/255, 0.12) : Theme.panel
        border.color: isUser ? Qt.rgba(123/255, 111/255, 240/255, 0.25) : Theme.border
        border.width: 1

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 6

            Text {
                Layout.fillWidth: true
                font.pixelSize: 12
                wrapMode: Text.WordWrap
                color: Theme.text
                text: msg.text
            }

            // 结果卡片
            Rectangle {
                visible: msg.resultCard && msg.resultRows && msg.resultRows.length > 0
                Layout.fillWidth: true
                Layout.preferredHeight: resultCol.implicitHeight + 16
                radius: 6
                color: Theme.bg
                border.color: Theme.border
                border.width: 1

                ColumnLayout {
                    id: resultCol
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 2

                    Repeater {
                        model: msg.resultRows
                        RowLayout {
                            Layout.fillWidth: true
                            Text {
                                font.pixelSize: 11
                                color: Theme.muted
                                text: modelData.label
                            }
                            Item { Layout.fillWidth: true }
                            Text {
                                font.family: Theme.fontFamily
                                font.pixelSize: 11
                                color: modelData.valueColor === "red" ? Theme.accent3 :
                                      (modelData.valueColor === "yellow" ? Theme.accent4 : Theme.accent)
                                text: modelData.value
                            }
                        }
                    }
                }
            }

            Text {
                visible: msg.extraText !== ""
                Layout.fillWidth: true
                font.pixelSize: 12
                wrapMode: Text.WordWrap
                color: Theme.text
                text: msg.extraText
            }

            // 代码块
            Rectangle {
                visible: msg.codeBlock !== ""
                Layout.fillWidth: true
                Layout.preferredHeight: codeText.implicitHeight + 12
                radius: 4
                color: Theme.bg
                border.color: Theme.border
                border.width: 1

                Text {
                    id: codeText
                    anchors.fill: parent
                    anchors.margins: 8
                    font.family: Theme.fontFamily
                    font.pixelSize: 10
                    color: Theme.accent
                    text: msg.codeBlock
                }
            }
        }
    }
}
