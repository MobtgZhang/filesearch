import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../theme" 1.0

ColumnLayout {
    id: radialMap
    Layout.preferredHeight: 260
    Layout.fillWidth: true
    spacing: 6

    property var categories: []
    property real usedSize: 0
    property real totalSize: 0

    readonly property var categoryLabels: ["视频", "文档", "图片", "音频", "系统", "其他"]
    readonly property var categoryColors: ["#4af0b4", "#7b6ff0", "#f07b6f", "#f0c46f", "#6b8e23", "#2a3040"]

    function formatSize(bytes) {
        var b = Number(bytes) || 0
        if (b >= 1024 * 1024 * 1024 * 1024)
            return (b / (1024 * 1024 * 1024 * 1024)).toFixed(1) + " TB"
        if (b >= 1024 * 1024 * 1024)
            return (b / (1024 * 1024 * 1024)).toFixed(1) + " GB"
        if (b >= 1024 * 1024)
            return (b / (1024 * 1024)).toFixed(1) + " MB"
        if (b >= 1024)
            return (b / 1024).toFixed(1) + " KB"
        return Math.round(b) + " B"
    }

    function getSizeForLabel(label) {
        for (var i = 0; i < radialMap.categories.length; i++) {
            if (radialMap.categories[i].labelShort === label)
                return radialMap.categories[i].sizeFormatted || "0 B"
        }
        return "0 B"
    }

    function getColorForLabel(label) {
        var idx = categoryLabels.indexOf(label)
        if (idx >= 0 && idx < categoryColors.length)
            return categoryColors[idx]
        return "#2a3040"
    }

    Item {
        Layout.fillWidth: true
        Layout.preferredHeight: 180

        Canvas {
            id: canvas
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            width: 160
            height: 160

            onPaint: {
                var ctx = getContext("2d")
                var cx = 80, cy = 80

                ctx.beginPath()
                ctx.arc(cx, cy, 58, 0, 2 * Math.PI)
                ctx.fillStyle = Theme.surface
                ctx.fill()

                var cats = radialMap.categories
                var total = radialMap.totalSize > 0 ? radialMap.totalSize : radialMap.usedSize

                if (total <= 0 && (!cats || cats.length === 0)) {
                    ctx.fillStyle = Theme.muted
                    ctx.font = "11px sans-serif"
                    ctx.textAlign = "center"
                    ctx.fillText("扫描中...", cx, cy - 4)
                    ctx.fillText("或未挂载", cx, cy + 10)
                } else {
                    var innerR = 22, outerR = 54
                    var gap = 0.02
                    var startAngle = -Math.PI / 2

                    if (cats && cats.length > 0) {
                        var sum = 0
                        for (var i = 0; i < cats.length; i++)
                            sum += cats[i].size || 0
                        var displayTotal = sum > 0 ? sum : total

                        for (var j = 0; j < cats.length; j++) {
                            var seg = cats[j]
                            var sz = seg.size || 0
                            if (sz <= 0) continue
                            var ratio = sz / displayTotal
                            var endAngle = startAngle + 2 * Math.PI * ratio
                            var color = seg.color || radialMap.categoryColors[j] || Theme.accent

                            ctx.beginPath()
                            ctx.moveTo(cx, cy)
                            ctx.arc(cx, cy, outerR, startAngle + gap, endAngle - gap)
                            ctx.arc(cx, cy, innerR, endAngle - gap, startAngle + gap, true)
                            ctx.closePath()
                            ctx.fillStyle = color
                            ctx.fill()

                            startAngle = endAngle
                        }

                        if (sum < displayTotal && displayTotal > 0) {
                            var remainRatio = 1 - sum / displayTotal
                            if (remainRatio > 0.01) {
                                var remainEnd = startAngle + 2 * Math.PI * remainRatio
                                ctx.beginPath()
                                ctx.moveTo(cx, cy)
                                ctx.arc(cx, cy, outerR, startAngle + gap, remainEnd - gap)
                                ctx.arc(cx, cy, innerR, remainEnd - gap, startAngle + gap, true)
                                ctx.closePath()
                                ctx.fillStyle = Qt.rgba(Theme.muted.r, Theme.muted.g, Theme.muted.b, 0.5)
                                ctx.fill()
                            }
                        }
                    } else {
                        var used = radialMap.usedSize
                        var ratio = total > 0 ? Math.min(1, used / total) : 0
                        ctx.beginPath()
                        ctx.moveTo(cx, cy)
                        ctx.arc(cx, cy, outerR, -Math.PI/2 + gap, -Math.PI/2 + 2*Math.PI*ratio - gap)
                        ctx.arc(cx, cy, innerR, -Math.PI/2 + 2*Math.PI*ratio - gap, -Math.PI/2 + gap, true)
                        ctx.closePath()
                        ctx.fillStyle = Theme.accent
                        ctx.fill()
                        ctx.beginPath()
                        ctx.moveTo(cx, cy)
                        ctx.arc(cx, cy, outerR, -Math.PI/2 + 2*Math.PI*ratio + gap, -Math.PI/2 + 2*Math.PI - gap)
                        ctx.arc(cx, cy, innerR, -Math.PI/2 + 2*Math.PI - gap, -Math.PI/2 + 2*Math.PI*ratio + gap, true)
                        ctx.closePath()
                        ctx.fillStyle = Qt.rgba(Theme.muted.r, Theme.muted.g, Theme.muted.b, 0.5)
                        ctx.fill()
                    }
                }

                ctx.beginPath()
                ctx.arc(cx, cy, 60, 0, 2 * Math.PI)
                ctx.strokeStyle = Theme.border
                ctx.lineWidth = 1
                ctx.stroke()
            }
        }
    }

    // 已用/总量 显示在环状图下面
    Text {
        Layout.alignment: Qt.AlignHCenter
        font.family: Theme.fontFamily
        font.pixelSize: 12
        font.weight: Font.Bold
        color: Theme.text
        text: radialMap.formatSize(radialMap.usedSize) + " / " + radialMap.formatSize(radialMap.totalSize > 0 ? radialMap.totalSize : radialMap.usedSize)
    }

    // 图例：颜色对应分类
    GridLayout {
        Layout.fillWidth: true
        Layout.leftMargin: 8
        Layout.rightMargin: 8
        columns: 3
        rowSpacing: 4
        columnSpacing: 8

        Repeater {
            model: radialMap.categoryLabels

            RowLayout {
                Layout.fillWidth: true
                spacing: 4

                Rectangle {
                    Layout.preferredWidth: 8
                    Layout.preferredHeight: 8
                    radius: 2
                    color: radialMap.getColorForLabel(modelData)
                }
                Text {
                    font.pixelSize: 10
                    font.family: Theme.fontFamily
                    color: Theme.text
                    text: modelData + " " + radialMap.getSizeForLabel(modelData)
                }
            }
        }
    }

    onCategoriesChanged: canvas.requestPaint()
    onUsedSizeChanged: canvas.requestPaint()
    onTotalSizeChanged: canvas.requestPaint()
}
