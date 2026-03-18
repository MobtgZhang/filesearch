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
    color: {
        if (mouseArea.pressed) return Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.25)
        if (mouseArea.containsMouse && !active) return Qt.rgba(Theme.border.r, Theme.border.g, Theme.border.b, 0.5)
        if (active) return Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.15)
        return "transparent"
    }
    border.width: active ? 1 : 0
    border.color: active ? Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.4) : "transparent"

    // 激活态左侧指示条
    Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.topMargin: 6
        anchors.bottomMargin: 6
        width: 3
        radius: 2
        color: Theme.accent
        opacity: active ? 1 : 0

        Behavior on opacity {
            NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
        }
    }

    Behavior on color {
        ColorAnimation { duration: 150; easing.type: Easing.OutCubic }
    }
    Behavior on border.width {
        NumberAnimation { duration: 120 }
    }
    Behavior on border.color {
        ColorAnimation { duration: 120 }
    }
    Behavior on scale {
        NumberAnimation { duration: 100; easing.type: Easing.OutQuad }
    }

    transformOrigin: Item.Center

    Text {
        id: iconText
        anchors.centerIn: parent
        text: navIcon.icon
        font.pixelSize: 16
        color: active ? Theme.accent : Theme.muted

        Behavior on color {
            ColorAnimation { duration: 150; easing.type: Easing.OutCubic }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onPressed: navIcon.scale = 0.88
        onReleased: navIcon.scale = 1.0
        onCanceled: navIcon.scale = 1.0
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
