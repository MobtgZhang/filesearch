// 实心扇形：从中心到外缘的完整扇区（饼图风格），无半扇
import QtQuick 2.15
import QtQuick.Shapes
import "../theme" 1.0

Shape {
    id: shape

    property var item: parent
    property real radius: 0
    property real startAngleDeg: 0
    property real sweepAngleDeg: 0
    property color fillColor: Theme.accent
    property string segmentUuid: ""
    property int segmentIndex: -1
    property string path: ""
    property string label: ""
    property real size: 0

    readonly property real centerX: (item && item.width > 0) ? item.width / 2 : (parent ? parent.width / 2 : 0)
    readonly property real centerY: (item && item.height > 0) ? item.height / 2 : (parent ? parent.height / 2 : 0)

    anchors.fill: parent
    containsMode: Shape.FillContains
    preferredRendererType: Shape.CurveRenderer
    asynchronous: true

    // 完整扇形：从中心到 radius，仅当 sweepAngleDeg 足够大时渲染
    ShapePath {
        fillColor: shape.fillColor
        strokeColor: Theme.border
        strokeWidth: 0.5
        capStyle: ShapePath.FlatCap

        startX: shape.centerX
        startY: shape.centerY

        PathLine {
            x: shape.centerX + shape.radius * Math.cos(shape.startAngleDeg * Math.PI / 180)
            y: shape.centerY + shape.radius * Math.sin(shape.startAngleDeg * Math.PI / 180)
        }

        PathAngleArc {
            centerX: shape.centerX
            centerY: shape.centerY
            radiusX: shape.radius
            radiusY: shape.radius
            startAngle: shape.startAngleDeg
            sweepAngle: shape.sweepAngleDeg
            moveToStart: false
        }

        PathLine {
            x: shape.centerX
            y: shape.centerY
        }
    }
}
