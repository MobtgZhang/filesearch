import QtQuick 2.15
import QtQuick.Layouts 1.15
import "../theme" 1.0

RowLayout {
    id: statusItem
    property bool dot: false
    property string text: ""
    property string accentText: ""
    property string suffix: ""
    property bool warn: false
    property bool showBorder: true

    Layout.rightMargin: 14
    spacing: 5

    Rectangle {
        visible: statusItem.dot
        Layout.preferredWidth: 5
        Layout.preferredHeight: 5
        radius: 3
        color: Theme.accent
    }

    Row {
        spacing: 0
        Text {
            font.family: Theme.fontFamily
            font.pixelSize: 10
            color: Theme.muted
            text: statusItem.text
        }
        Text {
            visible: statusItem.accentText !== ""
            font.family: Theme.fontFamily
            font.pixelSize: 10
            color: statusItem.warn ? Theme.accent4 : Theme.accent
            text: statusItem.accentText
        }
        Text {
            font.family: Theme.fontFamily
            font.pixelSize: 10
            color: Theme.muted
            text: statusItem.suffix
        }
    }

    Rectangle {
        visible: statusItem.showBorder
        Layout.preferredWidth: 1
        Layout.preferredHeight: 12
        color: Theme.border
    }
}
