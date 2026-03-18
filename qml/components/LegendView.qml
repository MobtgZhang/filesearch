import QtQuick 2.15
import QtQuick.Layouts 1.15
import "../theme" 1.0

ColumnLayout {
    id: legend
    Layout.fillWidth: true
    Layout.leftMargin: 14
    Layout.rightMargin: 14
    Layout.bottomMargin: 12
    spacing: 6

    LegendItem { dotColor: Theme.accent; name: "视频文件"; barWidth: 0.72; size: "34.9 GB" }
    LegendItem { dotColor: Theme.accent2; name: "文档 & 压缩"; barWidth: 0.18; size: "8.8 GB" }
    LegendItem { dotColor: Theme.accent3; name: "缓存 & 日志"; barWidth: 0.12; size: "5.9 GB" }
    LegendItem { dotColor: Theme.accent4; name: "图片"; barWidth: 0.09; size: "4.3 GB" }
    LegendItem { dotColor: "#2a3040"; name: "其他"; barWidth: 0.06; size: "2.9 GB" }
}
