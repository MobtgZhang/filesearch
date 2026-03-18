import QtQuick 2.15

Item {
    id: root
    implicitWidth: 20
    implicitHeight: 20

    property color color: "#4af0b4"

    Canvas {
        id: canvas
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)
            ctx.strokeStyle = root.color
            ctx.lineWidth = 2
            ctx.lineCap = "round"
            ctx.lineJoin = "round"

            var s = Math.min(width, height) / 24
            var cx = 11 * s, cy = 11 * s, r = 8 * s

            ctx.beginPath()
            ctx.arc(cx, cy, r, 0, Math.PI * 2)
            ctx.stroke()

            ctx.beginPath()
            ctx.moveTo(17 * s, 17 * s)
            ctx.lineTo(12.65 * s, 12.65 * s)
            ctx.stroke()
        }
        Component.onCompleted: requestPaint()
    }

    onColorChanged: canvas.requestPaint()
    onWidthChanged: canvas.requestPaint()
    onHeightChanged: canvas.requestPaint()
}
