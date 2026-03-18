import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtWebEngine
import "../theme" 1.0

Rectangle {
    id: aiPanel
    Layout.preferredWidth: Theme.aiPanelWidth
    Layout.fillHeight: true
    color: Theme.surface
    border.color: Theme.border
    border.width: 1

    function applyThemeToWeb() {
        if (!webLoader.item) return
        var mode = (typeof appSettings !== "undefined" && appSettings) ? appSettings.themeMode : "dark"
        webLoader.item.runJavaScript(
            "(function(){ setTimeout(function(){ var d=document.documentElement; if(d) d.setAttribute('data-theme','" + mode + "'); }, 0); })()"
        )
    }

    Connections {
        target: (typeof appSettings !== "undefined" && appSettings) ? appSettings : null
        function onThemeModeChanged() { aiPanel.applyThemeToWeb() }
    }

    Loader {
        id: webLoader
        anchors.fill: parent
        active: typeof aiChatHtmlPath !== "undefined" && aiChatHtmlPath !== ""

        sourceComponent: Component {
            WebEngineView {
                id: webView
                anchors.fill: parent
                property string _theme: (typeof appSettings !== "undefined" && appSettings) ? appSettings.themeMode : "dark"
                url: "file://" + aiChatHtmlPath + "?theme=" + _theme
                backgroundColor: Theme.surface
                onLoadProgressChanged: function(progress) {
                    if (progress === 100) {
                        aiPanel.applyThemeToWeb()
                        // 延迟再执行一次，确保 DOM 完全就绪（解决首次打开主题不同步）
                        themeSyncTimer.restart()
                    }
                }
            }
        }
    }

    Timer {
        id: themeSyncTimer
        interval: 150
        repeat: false
        onTriggered: aiPanel.applyThemeToWeb()
    }

    // 当无法加载 HTML 时的占位提示
    Rectangle {
        anchors.fill: parent
        visible: !webLoader.active
        color: Theme.surface

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 12

            Text {
                text: "✦"
                font.pixelSize: 32
                color: Theme.accent
                Layout.alignment: Qt.AlignHCenter
            }
            Text {
                text: "NexFile AI"
                font.pixelSize: 14
                font.weight: Font.Bold
                color: Theme.bright
                Layout.alignment: Qt.AlignHCenter
            }
            Text {
                text: "需要 Qt WebEngineQuick 模块\n请确保 ai-chat/index.html 路径正确"
                font.pixelSize: 11
                color: Theme.muted
                horizontalAlignment: Text.AlignHCenter
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
}
