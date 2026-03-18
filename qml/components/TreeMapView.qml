import QtQuick 2.15
import QtQuick.Layouts 1.15
import "../theme" 1.0

GridLayout {
    id: treemap
    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.margins: 14
    columns: 2
    rowSpacing: 3
    columnSpacing: 3

    property var segments: []

    Repeater {
        model: treemap.segments

        TreeMapCell {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.columnSpan: (index === treemap.segments.length - 1 && treemap.segments.length % 2 === 1) ? 2 : 1
            label: "📁 " + (modelData.label || "")
            size: modelData.sizeFormatted || ""
            gradientColors: getGradientColors(modelData.color)
        }
    }

    Text {
        visible: treemap.segments.length === 0
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.columnSpan: 2
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 12
        color: Theme.muted
        text: "扫描中...或目录为空"
    }

    function getGradientColors(hexColor) {
        if (!hexColor) return ["#1e1e1e", "#141414"]
        var r = parseInt(hexColor.slice(1, 3), 16) / 255
        var g = parseInt(hexColor.slice(3, 5), 16) / 255
        var b = parseInt(hexColor.slice(5, 7), 16) / 255
        var dark1 = Qt.rgba(r * 0.3, g * 0.3, b * 0.3, 1)
        var dark2 = Qt.rgba(r * 0.15, g * 0.15, b * 0.15, 1)
        return [dark1, dark2]
    }
}
