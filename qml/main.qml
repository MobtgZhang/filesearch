import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import "theme" 1.0
import "components" 1.0

ApplicationWindow {
    id: root
    visible: true
    width: 1280
    height: 800
    minimumWidth: 900
    minimumHeight: 600
    color: Theme.bg
    title: "NexFile — AI 文件管理器"

    SettingsDialog { id: settingsDialog }

    Connections {
        target: AppController
        function onOpenSettingsRequested() {
            settingsDialog.open()
        }
    }

    // 主布局
    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // ── 搜索栏 ──
        SearchBar { }

        // ── 主体三栏 ──
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            Sidebar { }

            VizPanel { }

            // 文件列表面板
            FileListPanel { }

            AIChatPanel { }
        }

        // ── 状态栏 ──
        StatusBar { }
    }
}
