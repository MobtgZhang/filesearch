import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../theme" 1.0

// 收藏页：显示右侧 Agent 部分的文件操作 Skill，支持收藏/取消收藏
Rectangle {
    id: favoritesPage
    color: Theme.panel
    border.color: Theme.border
    border.width: 1

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // ── 顶部标题 ──
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            color: Qt.rgba(Theme.surface.r, Theme.surface.g, Theme.surface.b, 0.5)
            border.color: Theme.border
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 14
                spacing: 6

                Text {
                    font.pixelSize: 11
                    font.weight: Font.Bold
                    font.letterSpacing: 0.12
                    font.family: Theme.fontFamily
                    color: Theme.muted
                    text: "收藏 · 文件操作 Skill"
                }
                Text {
                    font.pixelSize: 12
                    color: Theme.text
                    text: "来自右侧 Agent 面板的工具，点击 ☆ 可收藏/取消"
                }
            }
        }

        // ── Skill 列表 ──
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            ScrollBar.vertical.policy: ScrollBar.AsNeeded

            ColumnLayout {
                width: favoritesPage.width - 24
                Layout.alignment: Qt.AlignTop
                anchors.margins: 12
                spacing: 0

                Repeater {
                    model: FavoriteSkillsContext.skills

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 56
                        color: modelData.favorited ? Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.08) : "transparent"
                        border.color: index > 0 ? "transparent" : Theme.border
                        border.width: index > 0 ? 0 : 1

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 14
                            anchors.rightMargin: 14
                            spacing: 10

                            // 收藏按钮
                            Button {
                                Layout.preferredWidth: 28
                                Layout.preferredHeight: 28
                                Layout.alignment: Qt.AlignVCenter
                                flat: true
                                text: modelData.favorited ? "★" : "☆"
                                font.pixelSize: 14
                                onClicked: FavoriteSkillsContext.toggleFavorite(modelData.id)
                                background: Rectangle {
                                    color: parent.hovered ? Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.15) : "transparent"
                                    radius: 6
                                }
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                Layout.topMargin: 8
                                Layout.bottomMargin: 8
                                spacing: 2

                                Text {
                                    font.pixelSize: 13
                                    font.weight: Font.Medium
                                    font.family: Theme.fontFamily
                                    color: Theme.bright
                                    text: modelData.name
                                }
                                Text {
                                    font.pixelSize: 11
                                    color: Theme.muted
                                    text: modelData.desc
                                }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            acceptedButtons: Qt.NoButton
                        }
                    }
                }
            }
        }
    }
}
