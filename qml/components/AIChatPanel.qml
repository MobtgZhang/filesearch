import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../theme" 1.0

Rectangle {
    id: aiPanel
    Layout.preferredWidth: Theme.aiPanelWidth
    Layout.fillHeight: true
    color: Theme.surface
    border.color: Theme.border
    border.width: 1

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // AI 头部
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 70
            color: "transparent"
            border.color: Theme.border
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 6

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    Rectangle {
                        width: 28
                        height: 28
                        radius: 8
                        gradient: Gradient {
                            GradientStop { position: 0; color: Theme.accent }
                            GradientStop { position: 1; color: Theme.accent2 }
                        }

                        Text {
                            anchors.centerIn: parent
                            font.pixelSize: 14
                            text: "✦"
                        }
                    }

                    Text {
                        font.pixelSize: 13
                        font.weight: Font.Bold
                        color: Theme.bright
                        text: "NexFile AI"
                    }

                    Item { Layout.fillWidth: true }

                    Text {
                        font.family: Theme.fontFamily
                        font.pixelSize: 9
                        color: Theme.muted
                        text: "claude-sonnet"
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 6

                    Rectangle {
                        width: 6
                        height: 6
                        radius: 3
                        color: Theme.accent
                    }

                    Text {
                        font.pixelSize: 10
                        font.family: Theme.fontFamily
                        color: Theme.muted
                        text: "已分析当前磁盘状态"
                    }

                    Item { Layout.fillWidth: true }

                    Rectangle {
                        width: 50
                        height: 16
                        radius: 4
                        color: Qt.rgba(74/255, 240/255, 180/255, 0.1)
                        border.color: Qt.rgba(74/255, 240/255, 180/255, 0.2)
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            font.pixelSize: 9
                            font.family: Theme.fontFamily
                            color: Theme.accent
                            text: "23 文件"
                        }
                    }
                }
            }
        }

        // 消息列表
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 12
            clip: true
            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded
                width: 3
                contentItem: Rectangle {
                    implicitWidth: 3
                    color: Theme.border
                }
            }

            ColumnLayout {
                width: aiPanel.width - 36
                spacing: 10

                ChatMessage {
                    isUser: true
                    label: "你"
                    text: "帮我找出 6 个月内没有访问过的大视频文件，给清理建议"
                }

                ChatMessage {
                    isUser: false
                    label: "✦ NexFile AI"
                    text: "正在扫描文件访问记录…已找到符合条件的文件："
                    resultCard: true
                    resultRows: [
                        { label: "符合条件文件", value: "5 个", valueColor: "accent" },
                        { label: "可释放空间", value: "89.1 GB", valueColor: "red" },
                        { label: "最老访问时间", value: "2023-06-12", valueColor: "yellow" }
                    ]
                    extraText: "建议将 Interstellar.4K.mkv 等 3 个文件移至冷存储，预计节省 81.6 GB。"
                }

                ChatMessage {
                    isUser: true
                    label: "你"
                    text: "好的，帮我执行删除但先预览一下"
                }

                ChatMessage {
                    isUser: false
                    label: "✦ NexFile AI"
                    text: "正在执行 dry-run 预览…"
                    codeBlock: "delete_files(\n  paths=[3 个文件],\n  dry_run=true\n)"
                }
            }
        }

        // 工具执行状态
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            color: "transparent"
            border.color: Theme.border
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 4

                ToolStatusRow {
                    active: true
                    text: "delete_files · dry_run 预览中…"
                }
                ToolStatusRow {
                    done: true
                    text: "search_files · 完成 (23 结果)"
                }
                ToolStatusRow {
                    done: true
                    text: "scan_directory · ~/Movies 完成"
                }
            }
        }

        // 输入框
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 70
            color: "transparent"
            border.color: Theme.border
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 8

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 56
                    radius: 8
                    color: Theme.panel
                    border.color: Theme.border
                    border.width: 1

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 10

                        TextField {
                            Layout.fillWidth: true
                            placeholderText: "输入指令，例如：找出重复文件…"
                            font.pixelSize: 12
                            color: Theme.bright
                            background: Item {}
                            verticalAlignment: TextInput.AlignTop
                        }

                        Rectangle {
                            width: 28
                            height: 28
                            radius: 6
                            Layout.alignment: Qt.AlignBottom
                            gradient: Gradient {
                                GradientStop { position: 0; color: Theme.accent }
                                GradientStop { position: 1; color: Theme.accent2 }
                            }

                            Text {
                                anchors.centerIn: parent
                                font.pixelSize: 13
                                color: "white"
                                text: "↑"
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: { /* 发送 */ }
                            }
                        }
                    }
                }
            }
        }
    }
}
