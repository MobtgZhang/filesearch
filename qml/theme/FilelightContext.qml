pragma Singleton
import QtQuick 2.15

QtObject {
    id: ctx

    property var directoryTree: ({})
    property real usedSize: 0
    property real totalSize: 0
    property string scanPath: ""

    function updateFromResult(result) {
        if (!result) return
        directoryTree = result["directoryTree"] || {}
        usedSize = Number(result["usedSize"]) || 0
        totalSize = Number(result["totalSize"]) || 0
        scanPath = result["scanPath"] || ""
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
}
