import QtQuick 2.15
import QtQuick.Controls 2.15
import "../theme" 1.0

Rectangle {
    id: btn
    property string label: ""
    property bool active: false

    width: 70
    height: 32
    radius: 6
    color: active ? Theme.accent : "transparent"
    border.color: active ? Theme.accent : Theme.border
    border.width: 1

    Text {
        anchors.centerIn: parent
        font.pixelSize: 12
        color: active ? (Theme._mode === "dark" ? "#0a0c10" : "#ffffff") : Theme.text
        text: btn.label
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: if (!active) btn.color = Theme.border
        onExited: if (!active) btn.color = "transparent"
        onClicked: btn.clicked()
    }

    signal clicked()
}
