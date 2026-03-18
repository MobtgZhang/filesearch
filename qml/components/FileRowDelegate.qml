import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../theme" 1.0

Rectangle {
    id: row
    width: ListView.view ? ListView.view.width - (ListView.view.ScrollBar.vertical && ListView.view.ScrollBar.vertical.visible ? 8 : 0) : parent.width
    height: Theme.fileRowHeight
    color: {
        if (selected) return Qt.rgba(74/255, 240/255, 180/255, 0.07)
        if (highlighted) return Qt.rgba(74/255, 240/255, 180/255, 0.04)
        return "transparent"
    }

    property bool selected: model.selected
    property bool highlighted: model.highlighted

    RowLayout {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 0

        Row {
            Layout.preferredWidth: 220
            spacing: 8
            Text { text: model.icon; font.pixelSize: 14 }
            Text {
                Layout.fillWidth: true
                font.pixelSize: 12
                color: selected ? Theme.accent : Theme.bright
                text: model.name
                elide: Text.ElideRight
            }
        }

        Text {
            Layout.fillWidth: true
            font.family: Theme.fontFamily
            font.pixelSize: 10
            color: Theme.muted
            text: model.path
            elide: Text.ElideMiddle
        }

        Rectangle {
            Layout.preferredWidth: 80
            height: 16
            radius: 3
            color: typeColor(model.type)

            Text {
                anchors.centerIn: parent
                font.pixelSize: 9
                font.family: Theme.fontFamily
                font.letterSpacing: 0.06
                color: typeTextColor(model.type)
                text: model.type
            }
        }

        Text {
            Layout.preferredWidth: 80
            font.family: Theme.fontFamily
            font.pixelSize: 11
            color: Theme.text
            text: model.size
        }

        Text {
            Layout.preferredWidth: 120
            font.family: Theme.fontFamily
            font.pixelSize: 10
            color: Theme.muted
            text: model.date
        }

        Row {
            Layout.preferredWidth: 60
            spacing: 4
            opacity: rowArea.containsMouse ? 1 : 0

            Rectangle {
                width: 20
                height: 20
                radius: 4
                color: Theme.border

                Text {
                    anchors.centerIn: parent
                    font.pixelSize: 11
                    text: "👁"
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: { /* 预览 */ }
                }
            }
            Rectangle {
                width: 20
                height: 20
                radius: 4
                color: Theme.border

                Text {
                    anchors.centerIn: parent
                    font.pixelSize: 11
                    text: "⋯"
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: { /* 更多 */ }
                }
            }
        }
    }

    MouseArea {
        id: rowArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            if (ListView.view && ListView.view.model) {
                if (typeof ListView.view.model.toggleSelection === "function")
                    ListView.view.model.toggleSelection(index)
                else
                    ListView.view.model.setProperty(index, "selected", !model.selected)
            }
        }
    }

    function typeColor(type) {
        if (type === "MKV" || type === "MP4") return Qt.rgba(74/255, 240/255, 180/255, 0.12)
        if (type === "ISO" || type === "VMDK") return Qt.rgba(240/255, 196/255, 111/255, 0.12)
        if (type === "MOV") return Qt.rgba(240/255, 123/255, 111/255, 0.12)
        return Qt.rgba(123/255, 111/255, 240/255, 0.12)
    }
    function typeTextColor(type) {
        if (type === "MKV" || type === "MP4") return Theme.accent
        if (type === "ISO" || type === "VMDK") return Theme.accent4
        if (type === "MOV") return Theme.accent3
        return Theme.accent2
    }
}
