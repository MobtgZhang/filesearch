import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../theme" 1.0

Rectangle {
    id: navIcon
    property string icon: ""
    property bool active: false
    property string tooltip: ""
    property var onClicked: null

    Layout.preferredWidth: 36
    Layout.preferredHeight: 36
    Layout.alignment: Qt.AlignHCenter
    radius: 8
    color: active ? Qt.rgba(74/255, 240/255, 180/255, 0.12) : "transparent"

    Text {
        anchors.centerIn: parent
        text: navIcon.icon
        font.pixelSize: 16
        color: active ? Theme.accent : Theme.muted
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {
            if (!active) navIcon.color = Theme.border
        }
        onExited: {
            if (!active) navIcon.color = "transparent"
        }
        onClicked: {
            if (navIcon.onClicked) navIcon.onClicked()
            else navIcon.active = true
        }
    }

    ToolTip {
        visible: mouseArea.containsMouse
        delay: 500
        text: tooltip
    }
}
