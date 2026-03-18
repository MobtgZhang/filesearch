import QtQuick 2.15
import QtQuick.Layouts 1.15
import "../theme" 1.0

GridLayout {
    id: blocksView
    columns: 2
    rowSpacing: 6
    columnSpacing: 6

    property var categories: []

    readonly property var categoryOrder: ["视频", "文档", "图片", "音频", "系统", "其他"]

    Repeater {
        model: blocksView.categoryOrder

        TreeMapCell {
            Layout.fillWidth: true
            Layout.preferredHeight: 52
            Layout.columnSpan: (index === 5) ? 2 : 1
            label: modelData
            size: getSizeForCategory(modelData)
            gradientColors: getGradientColors(getColorForCategory(modelData))
        }
    }

    function getColorForCategory(key) {
        for (var i = 0; i < blocksView.categories.length; i++) {
            var c = blocksView.categories[i]
            if (c.labelShort === key)
                return c.color || "#2a3040"
        }
        return "#2a3040"
    }

    function getSizeForCategory(key) {
        for (var i = 0; i < blocksView.categories.length; i++) {
            var c = blocksView.categories[i]
            if (c.labelShort === key)
                return c.sizeFormatted || "0 B"
        }
        return "0 B"
    }

    function getGradientColors(hexColor) {
        if (!hexColor) return ["#3a4050", "#2a3040"]
        var r = parseInt(hexColor.slice(1, 3), 16) / 255
        var g = parseInt(hexColor.slice(3, 5), 16) / 255
        var b = parseInt(hexColor.slice(5, 7), 16) / 255
        var mid = Qt.rgba(r, g, b, 1)
        var dark = Qt.rgba(r * 0.85, g * 0.85, b * 0.85, 1)
        return [mid, dark]
    }
}
