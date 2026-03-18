import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../theme" 1.0

Item {
    id: radialMap
    Layout.preferredHeight: 256
    Layout.fillWidth: true

    Canvas {
        id: canvas
        anchors.centerIn: parent
        width: 256
        height: 256

        onPaint: {
            var ctx = getContext("2d")
            var cx = 128, cy = 128

            // 背景圆
            ctx.beginPath()
            ctx.arc(cx, cy, 92, 0, 2 * Math.PI)
            ctx.fillStyle = Theme.surface
            ctx.fill()

            // 环形扇区数据 (内环)
            var segments = [
                { start: -Math.PI/2, end: -Math.PI/2 + 2*Math.PI*0.72, color: Theme.accent },
                { start: -Math.PI/2 + 2*Math.PI*0.72, end: -Math.PI/2 + 2*Math.PI*0.90, color: Theme.accent2 },
                { start: -Math.PI/2 + 2*Math.PI*0.90, end: -Math.PI/2 + 2*Math.PI*1.0, color: Theme.accent3 }
            ]

            var innerR = 36, outerR = 62
            var gap = 0.018

            for (var i = 0; i < segments.length; i++) {
                var seg = segments[i]
                ctx.beginPath()
                ctx.moveTo(cx, cy)
                ctx.arc(cx, cy, outerR, seg.start + gap, seg.end - gap)
                ctx.arc(cx, cy, innerR, seg.end - gap, seg.start + gap, true)
                ctx.closePath()
                ctx.fillStyle = seg.color
                ctx.fill()
            }

            // 外环
            var outerSegments = [
                { start: -Math.PI/2, end: -Math.PI/2 + 2*Math.PI*0.45, color: Theme.accent },
                { start: -Math.PI/2 + 2*Math.PI*0.45, end: -Math.PI/2 + 2*Math.PI*0.62, color: Theme.accent },
                { start: -Math.PI/2 + 2*Math.PI*0.62, end: -Math.PI/2 + 2*Math.PI*0.78, color: Theme.accent4 },
                { start: -Math.PI/2 + 2*Math.PI*0.78, end: -Math.PI/2 + 2*Math.PI*0.91, color: Theme.accent2 },
                { start: -Math.PI/2 + 2*Math.PI*0.91, end: -Math.PI/2 + 2*Math.PI*1.0, color: Theme.accent3 }
            ]
            innerR = 64
            outerR = 90

            for (var j = 0; j < outerSegments.length; j++) {
                var oseg = outerSegments[j]
                ctx.beginPath()
                ctx.moveTo(cx, cy)
                ctx.arc(cx, cy, outerR, oseg.start + gap, oseg.end - gap)
                ctx.arc(cx, cy, innerR, oseg.end - gap, oseg.start + gap, true)
                ctx.closePath()
                ctx.fillStyle = oseg.color
                ctx.fill()
            }

            // 中心文字
            ctx.fillStyle = Theme.text
            ctx.font = "bold 18px sans-serif"
            ctx.textAlign = "center"
            ctx.fillText("480", cx, cy - 6)
            ctx.fillStyle = Theme.muted
            ctx.font = "10px monospace"
            ctx.fillText("GB 已用", cx, cy + 10)

            // 外圈描边
            ctx.beginPath()
            ctx.arc(cx, cy, 94, 0, 2 * Math.PI)
            ctx.strokeStyle = Theme.border
            ctx.lineWidth = 1
            ctx.stroke()
        }
    }
}
