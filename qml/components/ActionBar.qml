import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../theme" 1.0

Rectangle {
    id: actionBar
    Layout.fillWidth: true
    Layout.preferredHeight: Theme.actionBarHeight
    clip: true
    color: Qt.rgba(74/255, 240/255, 180/255, 0.06)
    border.color: Qt.rgba(74/255, 240/255, 180/255, 0.15)
    border.width: 1

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        anchors.topMargin: 6
        anchors.bottomMargin: 6
        spacing: 8

        // 已选统计（可点击，展开候选框）
        MouseArea {
            id: selCountArea
            Layout.preferredHeight: 20
            Layout.minimumWidth: selCountText.width + 16
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            property int _selRev: 0

            Text {
                id: selCountText
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                font.family: Theme.fontFamily
                font.pixelSize: 11
                color: Theme.accent
                text: {
                    var _ = selCountArea._selRev
                    if (typeof fileModel === "undefined" || !fileModel) return "✓ 已选 0 个文件，共 0 B"
                    var n = fileModel.selectedCount()
                    var sz = fileModel.selectedSize()
                    var szStr = fileModel.formatSize(sz)
                    return "✓ 已选 " + n + " 个文件，共 " + szStr
                }
            }

            Connections {
                target: typeof fileModel !== "undefined" && fileModel ? fileModel : null
                function onSelectionChanged() { selCountArea._selRev += 1 }
            }

            Text {
                anchors.left: selCountText.right
                anchors.leftMargin: 4
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 9
                color: Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.8)
                text: "▾"
                visible: selCountPop.visible
            }

            onClicked: selCountPop.visible ? selCountPop.close() : selCountPop.open()
        }

        // 候选框：全选/全不选/反选
        Popup {
            id: selCountPop
            parent: selCountArea
            x: 0
            y: selCountArea.height + 4
            width: 140
            padding: 6
            closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

            background: Rectangle {
                color: Theme.surface
                border.color: Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.3)
                border.width: 1
                radius: 8
            }

            contentItem: Column {
                spacing: 2

                Repeater {
                    model: ["全选", "全不选", "反选"]

                    Rectangle {
                        width: selCountPop.width - 12
                        height: 28
                        radius: 6
                        color: itemMa.containsMouse ? Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.12) : "transparent"

                        Text {
                            anchors.left: parent.left
                            anchors.leftMargin: 12
                            anchors.verticalCenter: parent.verticalCenter
                            font.family: Theme.fontFamily
                            font.pixelSize: 11
                            color: Theme.text
                            text: modelData
                        }

                        MouseArea {
                            id: itemMa
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                if (typeof fileModel !== "undefined" && fileModel) {
                                    if (modelData === "全选") fileModel.selectAll()
                                    else if (modelData === "全不选") fileModel.selectNone()
                                    else if (modelData === "反选") fileModel.invertSelection()
                                }
                                selCountPop.close()
                            }
                        }
                    }
                }
            }
        }

        Item { Layout.fillWidth: true }

        ActionButton {
            label: "🗑 删除"
            textColor: Theme.accent3
            borderColor: Qt.rgba(240/255, 123/255, 111/255, 0.3)
            bgColor: Qt.rgba(240/255, 123/255, 111/255, 0.08)
            Layout.alignment: Qt.AlignVCenter
        }
        ActionButton {
            label: "→ 移动"
            textColor: Theme.accent2
            borderColor: Qt.rgba(123/255, 111/255, 240/255, 0.3)
            bgColor: Qt.rgba(123/255, 111/255, 240/255, 0.08)
            Layout.alignment: Qt.AlignVCenter
        }
        ActionButton {
            label: "⬛ 压缩"
            textColor: Theme.accent4
            borderColor: Qt.rgba(240/255, 196/255, 111/255, 0.3)
            bgColor: Qt.rgba(240/255, 196/255, 111/255, 0.08)
            Layout.alignment: Qt.AlignVCenter
        }
    }
}
