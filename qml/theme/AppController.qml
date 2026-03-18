pragma Singleton
import QtQuick 2.15

QtObject {
    id: controller
    signal openSettingsRequested

    // 左侧导航当前页面："search" | "disk" | "duplicate" | "cleanup" | "favorites" | "history"
    property string currentPage: "search"

    // 扫描状态：true=扫描中，false=未扫描或已完成
    property bool isScanning: false

    // 与搜索栏共享的扫描目录（主目录、桌面、文档、下载、自定义）
    property int searchDirectoryIndex: 0
    property string searchDirectoryCustom: ""

    function resolveSearchPath() {
        if (searchDirectoryCustom.length > 0)
            return searchDirectoryCustom
        if (typeof pathProvider === "undefined" || !pathProvider)
            return ""
        if (searchDirectoryIndex === 0) return pathProvider.homePath
        if (searchDirectoryIndex === 1) return pathProvider.desktopPath
        if (searchDirectoryIndex === 2) return pathProvider.documentsPath
        if (searchDirectoryIndex === 3) return pathProvider.downloadPath
        return pathProvider.homePath
    }
}
