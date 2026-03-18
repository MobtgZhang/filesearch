import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../theme" 1.0

Rectangle {
    id: statusBar
    Layout.fillWidth: true
    Layout.preferredHeight: Theme.statusBarHeight
    Layout.minimumHeight: Theme.statusBarHeight
    clip: true
    color: Theme.surface
    border.color: Theme.border
    border.width: 1

    function formatNumber(n) {
        if (n >= 1000000)
            return (n / 1000000).toFixed(1) + "M"
        if (n >= 1000)
            return (n / 1000).toFixed(1) + "K"
        return n.toString()
    }

    function formatSize(bytes) {
        if (bytes >= 1024 * 1024 * 1024 * 1024)
            return (bytes / (1024 * 1024 * 1024 * 1024)).toFixed(1) + " TB"
        if (bytes >= 1024 * 1024 * 1024)
            return (bytes / (1024 * 1024 * 1024)).toFixed(1) + " GB"
        if (bytes >= 1024 * 1024)
            return (bytes / (1024 * 1024)).toFixed(1) + " MB"
        if (bytes >= 1024)
            return (bytes / 1024).toFixed(1) + " KB"
        return bytes + " B"
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        anchors.topMargin: 8
        anchors.bottomMargin: 8
        spacing: 0

        StatusItem {
            dot: true
            text: "已索引 "
            accentText: typeof statusContext !== "undefined" && statusContext
                ? formatNumber(statusContext.indexedFileCount) : "0"
            suffix: " 个文件"
            Layout.alignment: Qt.AlignVCenter
        }

        Rectangle {
            Layout.preferredWidth: 70
            Layout.preferredHeight: 18
            Layout.rightMargin: 14
            Layout.alignment: Qt.AlignVCenter
            radius: 9
            color: "transparent"
            border.color: Qt.rgba(74/255, 240/255, 180/255, 0.3)
            border.width: 1

            Text {
                anchors.centerIn: parent
                font.family: Theme.fontFamily
                font.pixelSize: 10
                color: Theme.accent
                text: "✦ AI 已就绪"
            }
        }

        Rectangle {
            Layout.preferredWidth: 1
            Layout.preferredHeight: 12
            Layout.leftMargin: 14
            Layout.rightMargin: 14
            color: Theme.border
            Layout.alignment: Qt.AlignVCenter
        }

        StatusItem {
            text: "耗时 "
            accentText: typeof statusContext !== "undefined" && statusContext
                ? statusContext.operationTimeFormatted : "0 毫秒"
            suffix: ""
            Layout.alignment: Qt.AlignVCenter
        }

        StatusItem {
            text: "找到 "
            accentText: {
                if (typeof statusContext === "undefined" || !statusContext) return "0"
                var n = statusContext.foundFileCount
                var sz = statusContext.foundTotalSize
                var szStr = formatSize(sz)
                return n + " 个文件，共 " + szStr
            }
            suffix: ""
            Layout.alignment: Qt.AlignVCenter
        }

        Rectangle {
            Layout.preferredWidth: 80
            Layout.preferredHeight: 4
            Layout.alignment: Qt.AlignVCenter
            radius: 2
            color: Theme.border

            Rectangle {
                width: parent.width * 0.85
                height: parent.height
                radius: 2
                gradient: Gradient {
                    GradientStop { position: 0; color: Theme.accent }
                    GradientStop { position: 1; color: Theme.accent2 }
                }
            }
        }

        Item { Layout.fillWidth: true }

        StatusItem {
            text: "文件监听 "
            accentText: "活跃"
            showBorder: false
            Layout.alignment: Qt.AlignVCenter
        }

        StatusItem {
            text: "Qt 6.7 · Linux · x86_64"
            showBorder: false
            Layout.alignment: Qt.AlignVCenter
        }
    }
}
