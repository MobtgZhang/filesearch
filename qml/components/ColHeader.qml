import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../theme" 1.0

Item {
    id: colHeader
    property string label: ""
    property bool sort: false
    property int colWidth: 80

    Layout.preferredWidth: colWidth > 0 ? colWidth : 100
    Layout.fillWidth: colWidth < 0

    Row {
        anchors.verticalCenter: parent.verticalCenter
        spacing: 4

        Text {
            font.pixelSize: 10
            font.weight: Font.Bold
            font.letterSpacing: 0.12
            color: sort ? Theme.accent : Theme.muted
            text: colHeader.label
        }
        Text {
            visible: sort
            font.pixelSize: 9
            color: Theme.accent
            text: "↓"
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: colHeader.sort = !colHeader.sort
    }
}
