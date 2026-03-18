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
    color: Theme.panel
    border.color: Theme.border
    border.width: 1

    Text {
        anchors.centerIn: parent
        font.pixelSize: 12
        color: Theme.text
        text: btn.label
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: btn.color = Qt.lighter(Theme.panel, 1.1)
        onExited: btn.color = Theme.panel
        onClicked: btn.clicked()
    }

    signal clicked()
}
