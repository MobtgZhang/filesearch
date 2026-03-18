import QtQuick 2.15
import QtQuick.Controls 2.15
import "../theme" 1.0

Rectangle {
    id: btn
    property string label: ""
    property color textColor: Theme.accent
    property color borderColor: Theme.border
    property color bgColor: "transparent"

    width: label.length * 8 + 20
    height: 26
    radius: 5
    color: btn.bgColor
    border.color: btn.borderColor
    border.width: 1

    Text {
        anchors.centerIn: parent
        font.pixelSize: 11
        color: btn.textColor
        text: btn.label
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: parent.opacity = 0.9
        onExited: parent.opacity = 1
        onClicked: { /* 执行操作 */ }
    }
}
