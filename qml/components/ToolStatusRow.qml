import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../theme" 1.0

RowLayout {
    id: toolRow
    property bool active: false
    property bool done: false
    property string text: ""

    Layout.fillWidth: true
    spacing: 6

    Item {
        Layout.preferredWidth: 12
        Layout.preferredHeight: 12

        Item {
            visible: toolRow.active
            width: 12
            height: 12
            anchors.centerIn: parent

            Rectangle {
                id: spinnerRect
                anchors.fill: parent
                radius: 6
                color: "transparent"
                border.color: Theme.accent
                border.width: 1

                RotationAnimation on rotation {
                    from: 0
                    to: 360
                    duration: 800
                    loops: Animation.Infinite
                    running: toolRow.active
                }
            }
        }

        Text {
            visible: toolRow.done
            anchors.centerIn: parent
            font.pixelSize: 10
            color: Theme.accent
            text: "✓"
        }

        Rectangle {
            visible: !toolRow.active && !toolRow.done
            anchors.centerIn: parent
            width: 6
            height: 6
            radius: 3
            color: Theme.border
        }
    }

    Text {
        font.pixelSize: 10
        font.family: Theme.fontFamily
        color: toolRow.active ? Theme.accent : Theme.muted
        text: toolRow.text
    }
}
