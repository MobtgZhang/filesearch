// 实心饼图：圆内不同颜色扇形，仅显示已有文件，无半扇
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Shapes
import "../theme" 1.0

Item {
    id: filelightView
    property var directoryTree: ({})
    property real usedSize: 0
    property real totalSize: 0
    property string focusedPath: ""
    property int hoveredSegmentIndex: -1

    readonly property var segmentColors: ["#4af0b4", "#7b6ff0", "#f07b6f", "#f0c46f", "#6b8e23", "#4ecdc4", "#ff6b6b", "#95e1d3"]

    readonly property int maxSegments: 24
    readonly property real minSweepDeg: 2

    property var segmentsList: []

    function getViewRoot() {
        if (!focusedPath || !directoryTree || !directoryTree.children)
            return directoryTree
        return findNodeByPath(directoryTree, focusedPath) || directoryTree
    }

    function findNodeByPath(node, path) {
        if (!node || !path) return null
        var p = (path.endsWith("/") ? path.slice(0,-1) : path)
        var nodePath = (node.path || "").replace(/\/$/, "")
        if (nodePath === p) return node
        var children = node.children || []
        for (var i = 0; i < children.length; i++) {
            var found = findNodeByPath(children[i], path)
            if (found) return found
        }
        return null
    }

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

    // 单层饼图：仅显示当前层级子项，完整扇形，小项合并为「其他」
    function buildSegmentsLimited() {
        var segs = []
        var tree = getViewRoot()
        if (!tree || !tree.children || width <= 0 || height <= 0) return segs

        var children = tree.children
        var total = 0
        var valid = []
        for (var i = 0; i < children.length; i++) {
            var sz = Number(children[i].size) || 0
            if (sz > 0) {
                total += sz
                valid.push({ node: children[i], size: sz })
            }
        }
        if (total <= 0 || valid.length === 0) return segs

        var maxR = Math.min(width, height) / 2 - 30
        var centerR = 28
        var gap = 0.003
        var acc = 0
        var othersSize = 0
        var others = []

        for (var j = 0; j < valid.length && segs.length < maxSegments; j++) {
            var v = valid[j]
            var segStart = 2 * Math.PI * (acc / total)
            acc += v.size
            var segEnd = 2 * Math.PI * (acc / total)
            var sweep = (segEnd - segStart) * 180 / Math.PI
            if (sweep < minSweepDeg) {
                othersSize += v.size
                others.push(v.node)
                continue
            }
            var colorIdx = segs.length % segmentColors.length
            segs.push({
                startAngleDeg: (segStart + gap) * 180 / Math.PI,
                sweepAngleDeg: (segEnd - segStart - 2 * gap) * 180 / Math.PI,
                radius: maxR,
                label: v.node.name || "?",
                path: v.node.path || "",
                size: v.size,
                color: segmentColors[colorIdx],
                uuid: "s" + segs.length
            })
        }
        if (othersSize > 0 && segs.length < maxSegments) {
            var sweepDeg = (othersSize / total) * 360
            if (sweepDeg >= minSweepDeg) {
                var colorIdx = segs.length % segmentColors.length
                var startDeg = ((acc - othersSize) / total) * 360
                segs.push({
                    startAngleDeg: startDeg + gap * 180 / Math.PI,
                    sweepAngleDeg: sweepDeg - 2 * gap * 180 / Math.PI,
                    radius: maxR,
                    label: "其他",
                    path: "",
                    size: othersSize,
                    color: segmentColors[colorIdx],
                    uuid: "s" + segs.length
                })
            }
        }
        return segs
    }

    function refreshSegments() {
        segmentsList = buildSegmentsLimited()
    }

    Timer {
        id: deferBuild
        interval: 0
        repeat: false
        onTriggered: refreshSegments()
    }

    Item {
        id: shapeItem
        anchors.fill: parent
        antialiasing: true

        property var zOrderedShapes: []
        property bool hasShapes: segmentsList.length > 0

        function objectToArray(obj) {
            var arr = []
            for (var i in obj) arr.push(obj[i])
            return arr
        }

        onChildrenChanged: {
            var children = objectToArray(shapeItem.children)
            children = children.filter(function(c) { return c && c.hasOwnProperty("contains") })
            children.sort(function(a, b) { return (b.z || 0) - (a.z || 0) })
            zOrderedShapes = children
        }

        Repeater {
            anchors.fill: parent
            model: segmentsList
            delegate: FilelightSegmentShape {
                anchors.fill: parent
                z: 100
                item: shapeItem
                radius: modelData.radius
                startAngleDeg: modelData.startAngleDeg
                sweepAngleDeg: modelData.sweepAngleDeg
                fillColor: hoveredSegmentIndex === index ? Qt.darker(modelData.color, 1.15) : modelData.color
                segmentUuid: modelData.uuid
                segmentIndex: index
                path: modelData.path || ""
                label: modelData.label || ""
                size: modelData.size || 0
            }
        }

        Rectangle {
            id: centerCircle
            z: 500
            visible: shapeItem.hasShapes
            width: 56
            height: 56
            radius: 28
            anchors.centerIn: parent
            color: Theme.surface
            border.color: Theme.border
            border.width: 1

            Column {
                anchors.centerIn: parent
                spacing: 2
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: 10
                    font.bold: true
                    font.family: Theme.fontFamily
                    color: Theme.text
                    text: "已用"
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: 9
                    font.family: Theme.fontFamily
                    color: Theme.muted
                    text: formatSize(usedSize)
                }
            }
        }

        Text {
            anchors.centerIn: parent
            visible: !shapeItem.hasShapes
            font.pixelSize: 12
            font.family: Theme.fontFamily
            color: Theme.muted
            text: AppController.isScanning ? "扫描中..." : "选择目录并点击开始扫描"
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        function findTarget(mouse) {
            if (centerCircle.visible) {
                var dx = mouse.x - centerCircle.x - centerCircle.width / 2
                var dy = mouse.y - centerCircle.y - centerCircle.height / 2
                if (dx * dx + dy * dy <= 28 * 28)
                    return { type: "center", segment: null }
            }
            var shapes = shapeItem.zOrderedShapes
            for (var i = 0; i < shapes.length; i++) {
                var s = shapes[i]
                if (s && s.contains && s.contains(Qt.point(mouse.x - shapeItem.x, mouse.y - shapeItem.y)))
                    return { type: "segment", segment: s, index: (s.segmentIndex >= 0 ? s.segmentIndex : i) }
            }
            return null
        }

        onPositionChanged: function(mouse) {
            var hit = findTarget(mouse)
            if (hit) {
                if (hit.type === "center")
                    hoveredSegmentIndex = -2
                else if (hit.index >= 0)
                    hoveredSegmentIndex = hit.index
            } else {
                hoveredSegmentIndex = -1
            }
        }

        onExited: hoveredSegmentIndex = -1

        onClicked: function(mouse) {
            var hit = findTarget(mouse)
            if (!hit) return
            if (hit.type === "center") {
                if (focusedPath) {
                    var lastSlash = focusedPath.replace(/\/$/, "").lastIndexOf("/")
                    focusedPath = lastSlash > 0 ? focusedPath.substring(0, lastSlash) : ""
                }
                return
            }
            if (hit.segment && hit.segment.path)
                focusedPath = hit.segment.path
        }
    }

    ToolTip {
        visible: hoveredSegmentIndex >= 0 && hoveredSegmentIndex < segmentsList.length
        delay: 200
        text: {
            var seg = segmentsList[hoveredSegmentIndex]
            return (seg && seg.label !== undefined) ? (seg.label + " — " + formatSize(seg.size || 0)) : ""
        }
    }

    Connections {
        target: AppController
        function onIsScanningChanged() { deferBuild.restart() }
    }

    onDirectoryTreeChanged: {
        focusedPath = ""
        deferBuild.restart()
    }
    onFocusedPathChanged: deferBuild.restart()
    onWidthChanged: deferBuild.restart()
    onHeightChanged: deferBuild.restart()
}
