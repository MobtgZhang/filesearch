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

    property var segments: []
    property real totalSize: 0

    Repeater {
        model: legend.segments

        LegendItem {
            dotColor: modelData.color || Theme.accent
            name: modelData.label || ""
            barWidth: legend.totalSize > 0 ? (modelData.size || 0) / legend.totalSize : 0
            size: modelData.sizeFormatted || ""
        }
    }
}
