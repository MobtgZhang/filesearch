pragma Singleton
import QtQuick 2.15

QtObject {
    id: ctx

    // 文件操作 Skill 定义（与 framework.md 中 TOOLS 一致）
    property var skills: [
        { id: "search_files", name: "search_files", desc: "按条件搜索文件", favorited: true },
        { id: "scan_directory", name: "scan_directory", desc: "扫描目录并返回大小分布", favorited: true },
        { id: "find_duplicates", name: "find_duplicates", desc: "在指定目录查找重复文件", favorited: false },
        { id: "delete_files", name: "delete_files", desc: "删除文件列表（需用户二次确认）", favorited: true },
        { id: "move_files", name: "move_files", desc: "移动文件到目标目录", favorited: false },
        { id: "analyze_space", name: "analyze_space", desc: "分析哪些类型/目录占用空间最多", favorited: false },
        { id: "semantic_search", name: "semantic_search", desc: "用自然语言描述搜索文件内容", favorited: false }
    ]

    // 工具执行记录（来自 Agent 面板的 ai-tools 区域）
    property var toolExecutions: []

    function toggleFavorite(skillId) {
        var list = []
        for (var i = 0; i < skills.length; i++) {
            var s = skills[i]
            if (s.id === skillId) {
                list.push({ id: s.id, name: s.name, desc: s.desc, favorited: !s.favorited })
            } else {
                list.push(s)
            }
        }
        skills = list
    }

    function addToolExecution(name, status, result) {
        toolExecutions = [{
            name: name,
            status: status,  // "running" | "done" | "error"
            result: result || "",
            timestamp: Qt.formatDateTime(new Date(), "yyyy-MM-dd hh:mm:ss")
        }].concat(toolExecutions)
    }

    function getFavoritedSkills() {
        var list = []
        for (var i = 0; i < skills.length; i++) {
            if (skills[i].favorited) list.push(skills[i])
        }
        return list
    }
}
