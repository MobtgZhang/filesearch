import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: chip
    property string label: ""
    property color chipColor: "#7b6ff0"

    width: label.length * 8 + 20
    height: 24
    radius: 6
    color: Qt.rgba(chipColor.r, chipColor.g, chipColor.b, 0.12)
    border.color: Qt.rgba(chipColor.r, chipColor.g, chipColor.b, 0.3)
    border.width: 1

    Text {
        anchors.centerIn: parent
        font.family: "JetBrains Mono, monospace"
        font.pixelSize: 11
        color: chip.chipColor
        text: chip.label
    }
}
