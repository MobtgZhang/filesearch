import QtQuick 2.15
import QtQuick.Layouts 1.15
import "../theme" 1.0

RowLayout {
    id: legendItem
    property color dotColor: Theme.accent
    property string name: ""
    property real barWidth: 0.5
    property string size: ""

    Layout.fillWidth: true
    spacing: 8

    Rectangle {
        Layout.preferredWidth: 10
        Layout.preferredHeight: 10
        radius: 2
        color: legendItem.dotColor
        border.width: legendItem.dotColor === "#2a3040" ? 1 : 0
        border.color: Theme.border
    }

    Text {
        Layout.fillWidth: true
        font.pixelSize: 12
        color: Theme.text
        text: legendItem.name
    }

    Rectangle {
        Layout.preferredWidth: 60
        Layout.preferredHeight: 4
        radius: 2
        color: Theme.border

        Rectangle {
            width: parent.width * legendItem.barWidth
            height: parent.height
            radius: 2
            color: legendItem.dotColor
        }
    }

    Text {
        font.family: Theme.fontFamily
        font.pixelSize: 11
        color: Theme.muted
        text: legendItem.size
    }
}
