import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../theme" 1.0

Rectangle {
    id: row
    width: ListView.view ? ListView.view.width - (ListView.view.ScrollBar.vertical && ListView.view.ScrollBar.vertical.visible ? 8 : 0) : parent.width
    height: Theme.fileRowHeight
    color: {
        if (selected) return Qt.rgba(74/255, 240/255, 180/255, 0.12)
        if (highlighted) return Qt.rgba(74/255, 240/255, 180/255, 0.05)
        return "transparent"
    }

    property bool selected: model.selected
    property bool highlighted: model.highlighted

    Rectangle {
        visible: selected
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 3
        color: Theme.accent
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 0

        Item {
            Layout.preferredWidth: 220
            Layout.minimumWidth: 0

            RowLayout {
                anchors.fill: parent
                spacing: 8

                Text {
                    text: model.icon
                    font.pixelSize: 14
                    Layout.preferredWidth: 14
                }
                Text {
                    Layout.fillWidth: true
                    Layout.minimumWidth: 0
                    font.pixelSize: 12
                    color: selected ? Theme.accent : Theme.bright
                    text: model.name
                    elide: Text.ElideRight
                }
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
        acceptedButtons: Qt.LeftButton
        onClicked: (mouse) => {
            if (!ListView.view || !ListView.view.model) return
            ListView.view.forceActiveFocus()
            var mdl = ListView.view.model
            var ctrl = (mouse.modifiers & Qt.ControlModifier) || (mouse.modifiers & Qt.MetaModifier) || (ListView.view.ctrlHeld || false)
            var shift = (mouse.modifiers & Qt.ShiftModifier) || (ListView.view.shiftHeld || false)

            if (shift) {
                // Shift+点击：从锚点选区到当前行
                if (typeof mdl.selectRange === "function" && typeof mdl.selectionAnchor === "function") {
                    var anchor = mdl.selectionAnchor()
                    if (anchor < 0) {
                        var sel = mdl.selectedRows()
                        anchor = (sel.length > 0) ? Math.min.apply(null, sel) : index
                    }
                    if (typeof mdl.selectNone === "function") mdl.selectNone()
                    mdl.selectRange(anchor, index)
                } else {
                    mdl.toggleSelection(index)
                }
            } else if (ctrl) {
                // Ctrl+点击：切换当前行选中状态
                if (typeof mdl.toggleSelection === "function") {
                    mdl.toggleSelection(index)
                    if (typeof mdl.setSelectionAnchor === "function")
                        mdl.setSelectionAnchor(index)
                } else {
                    mdl.setProperty(index, "selected", !model.selected)
                }
            } else {
                // 普通点击：仅选中当前行
                if (typeof mdl.selectSingle === "function") {
                    mdl.selectSingle(index)
                } else if (typeof mdl.selectNone === "function" && typeof mdl.setProperty !== "undefined") {
                    mdl.selectNone()
                    mdl.setProperty(index, "selected", true)
                    if (typeof mdl.setSelectionAnchor === "function")
                        mdl.setSelectionAnchor(index)
                } else {
                    mdl.toggleSelection(index)
                }
            }
        }
    }

    ToolTip.visible: rowArea.containsMouse && rowArea.mouseX >= 14 && rowArea.mouseX < 234
    ToolTip.text: {
        var p = model.path || ""
        var lastSlash = p.lastIndexOf('/')
        return lastSlash >= 0 ? p.substring(0, lastSlash + 1) : p
    }
    ToolTip.delay: 400

    function typeColor(type) {
        if (type === "文件夹") return Qt.rgba(123/255, 111/255, 240/255, 0.15)
        if (type === "MKV" || type === "MP4") return Qt.rgba(74/255, 240/255, 180/255, 0.12)
        if (type === "ISO" || type === "VMDK") return Qt.rgba(240/255, 196/255, 111/255, 0.12)
        if (type === "MOV") return Qt.rgba(240/255, 123/255, 111/255, 0.12)
        return Qt.rgba(123/255, 111/255, 240/255, 0.12)
    }
    function typeTextColor(type) {
        if (type === "文件夹") return Theme.accent2
        if (type === "MKV" || type === "MP4") return Theme.accent
        if (type === "ISO" || type === "VMDK") return Theme.accent4
        if (type === "MOV") return Theme.accent3
        return Theme.accent2
    }
}
