import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../theme" 1.0

// 精美的筛选 Pop 菜单组件
// label: 按钮前缀（如 "查找目录"）
// chipColor: 主题色
// model: 选项列表 ["选项1", "选项2", ...]
// currentIndex: 当前选中索引
// customSelection: 自定义显示文本（如选择目录后的路径），优先于 model[currentIndex]
// onSelected: 选中回调
// onItemClicked: 可选，点击某项时调用 (index, text)，若返回 true 则跳过默认选中逻辑
// 按钮显示: label + ": " + (customSelection || model[currentIndex])
Item {
    id: root
    property string label: ""
    property color chipColor: Theme.accent2
    property var model: []
    property int currentIndex: 0
    property string customSelection: ""
    property var onSelected: function(index) {}
    property var onItemClicked: null  // function(index, text) => bool，返回 true 时跳过默认逻辑

    readonly property string displayText: {
        if (root.customSelection.length > 0)
            return root.label + ": " + root.customSelection
        if (root.model.length > 0 && root.currentIndex >= 0 && root.currentIndex < root.model.length)
            return root.label + ": " + root.model[root.currentIndex]
        return root.label
    }

    width: triggerBtn.width
    height: triggerBtn.height

    // 触发按钮
    Rectangle {
        id: triggerBtn
        width: Math.max(100, labelText.width + 36)
        height: 28
        radius: 8
        color: popup.visible ? Qt.rgba(chipColor.r, chipColor.g, chipColor.b, 0.2) : Qt.rgba(chipColor.r, chipColor.g, chipColor.b, 0.12)
        border.color: popup.visible ? Qt.rgba(chipColor.r, chipColor.g, chipColor.b, 0.5) : Qt.rgba(chipColor.r, chipColor.g, chipColor.b, 0.3)
        border.width: 1

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 12
            anchors.rightMargin: 10
            spacing: 6

            Text {
                id: labelText
                font.family: Theme.fontFamily
                font.pixelSize: 11
                color: chipColor
                text: root.displayText
                Layout.alignment: Qt.AlignVCenter
            }

            Text {
                font.pixelSize: 10
                color: Qt.rgba(chipColor.r, chipColor.g, chipColor.b, 0.8)
                text: "▾"
                Layout.alignment: Qt.AlignVCenter
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: if (!popup.visible) triggerBtn.color = Qt.rgba(chipColor.r, chipColor.g, chipColor.b, 0.18)
            onExited: if (!popup.visible) triggerBtn.color = Qt.rgba(chipColor.r, chipColor.g, chipColor.b, 0.12)
            onClicked: popup.visible ? popup.close() : popup.open()
        }
    }

    // 弹出菜单（parent 设为 triggerBtn 以便正确相对定位）
    Popup {
        id: popup
        parent: triggerBtn
        x: 0
        y: triggerBtn.height + 4
        width: Math.max(triggerBtn.width + 20, 180)
        padding: 6
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        background: Rectangle {
            color: Theme.surface
            border.color: Qt.rgba(chipColor.r, chipColor.g, chipColor.b, 0.3)
            border.width: 1
            radius: 10

            // 顶部高光条
            Rectangle {
                width: parent.width - 2
                height: 1
                x: 1
                y: 1
                radius: 9
                color: Qt.rgba(chipColor.r, chipColor.g, chipColor.b, 0.2)
            }

            // 左侧 accent 竖条
            Rectangle {
                width: 3
                height: parent.height - 12
                x: 4
                y: 6
                radius: 2
                color: Qt.rgba(chipColor.r, chipColor.g, chipColor.b, 0.5)
            }
        }

        contentItem: Column {
            spacing: 2

            Repeater {
                model: root.model

                Rectangle {
                    width: popup.width - 12
                    height: 32
                    radius: 6
                    color: index === root.currentIndex
                           ? Qt.rgba(chipColor.r, chipColor.g, chipColor.b, 0.18)
                           : (itemMa.containsMouse ? Qt.rgba(chipColor.r, chipColor.g, chipColor.b, 0.08) : "transparent")

                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: 12
                        anchors.verticalCenter: parent.verticalCenter
                        font.family: Theme.fontFamily
                        font.pixelSize: 12
                        color: index === root.currentIndex ? chipColor : Theme.text
                        text: modelData
                    }

                    Text {
                        visible: index === root.currentIndex
                        anchors.right: parent.right
                        anchors.rightMargin: 12
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: 12
                        color: chipColor
                        text: "✓"
                    }

                    MouseArea {
                        id: itemMa
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            var skipDefault = false
                            if (typeof root.onItemClicked === "function") {
                                skipDefault = root.onItemClicked(index, modelData)
                            }
                            if (!skipDefault) {
                                root.currentIndex = index
                                root.customSelection = ""
                                root.onSelected(index)
                            }
                            popup.close()
                        }
                    }
                }
            }
        }
    }
}
