import QtQuick 2.15
import QtQuick.Controls 2.15
import "../theme" 1.0

Rectangle {
    id: tab
    property string label: ""
    property bool active: false

    width: label.length * 10 + 16
    height: 22
    radius: 4
    color: active ? Theme.border : "transparent"

    Text {
        anchors.centerIn: parent
        font.pixelSize: 11
        color: active ? Theme.bright : Theme.muted
        text: tab.label
    }

    MouseArea {
        anchors.fill: parent
        onClicked: tab.active = true
    }
}
