pragma Singleton
import QtQuick 2.15

QtObject {
    id: ctx

    property bool isScanning: false
    property int scannedFiles: 0
    property int candidateGroups: 0
    property int duplicateGroups: 0
    property int totalScanned: 0
    property int elapsedMs: 0
    property var duplicateGroupsList: []  // [{ files: [...], count: N, size: N }, ...]

    function updateProgress(scanned, candidates, duplicates, ms) {
        scannedFiles = scanned
        candidateGroups = candidates
        duplicateGroups = duplicates
        elapsedMs = ms
    }

    function updateFromResult(groups, total, ms) {
        duplicateGroupsList = groups || []
        totalScanned = total || 0
        elapsedMs = ms || 0
        duplicateGroups = (groups || []).length
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
