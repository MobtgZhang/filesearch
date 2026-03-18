import QtQuick 2.15
import QtQuick.Controls 2.15
import "../theme" 1.0

Rectangle {
    id: cell
    property string label: ""
    property string size: ""
    property var gradientColors: ["#1a3a2a", "#0d2018"]

    radius: 3

    gradient: Gradient {
        GradientStop { position: 0; color: cell.gradientColors[0] }
        GradientStop { position: 1; color: cell.gradientColors[1] }
    }

    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.15)
        radius: parent.radius
    }

    Column {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 8
        spacing: 2

        Text {
            width: parent.width - 16
            font.pixelSize: 10
            font.weight: Font.Bold
            font.letterSpacing: 0.05
            color: Qt.rgba(1, 1, 1, 0.9)
            text: cell.label
            elide: Text.ElideRight
        }
        Text {
            font.family: Theme.fontFamily
            font.pixelSize: 9
            color: Qt.rgba(1, 1, 1, 0.6)
            text: cell.size
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: cell.opacity = 0.9
        onExited: cell.opacity = 1
        onClicked: { /* 联动文件列表 */ }
    }
}
