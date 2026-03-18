#include "ToolExecutor.h"
#include "tools/SearchFilesTool.h"
#include "tools/DeleteFilesTool.h"
#include "tools/MoveFilesTool.h"
#include "tools/ShellTool.h"
#include "tools/WebSearchTool.h"
#include "engine/SearchEngine.h"
#include "service/FileOperationService.h"
#include "AppSettings.h"

ToolExecutor::ToolExecutor(QObject *parent)
    : QObject(parent)
{
}

void ToolExecutor::setSearchEngine(SearchEngine *engine)
{
    m_searchEngine = engine;
    rebuildTools();
}

void ToolExecutor::setFileOperationService(FileOperationService *service)
{
    m_fileOperationService = service;
    rebuildTools();
}

void ToolExecutor::setAppSettings(AppSettings *settings)
{
    m_appSettings = settings;
    rebuildTools();
}

void ToolExecutor::rebuildTools()
{
    m_tools.clear();
    if (m_searchEngine)
        m_tools.push_back(std::make_unique<SearchFilesTool>(m_searchEngine));
    if (m_fileOperationService) {
        m_tools.push_back(std::make_unique<DeleteFilesTool>(m_fileOperationService));
        m_tools.push_back(std::make_unique<MoveFilesTool>(m_fileOperationService));
    }
    m_tools.push_back(std::make_unique<ShellTool>());
    if (m_appSettings)
        m_tools.push_back(std::make_unique<WebSearchTool>(m_appSettings));
}

IAgentTool *ToolExecutor::toolForName(const QString &name) const
{
    for (const auto &t : m_tools) {
        if (t && t->name() == name)
            return t.get();
    }
    return nullptr;
}

QVariant ToolExecutor::execute(const QString &toolName, const QVariantMap &params)
{
    emit toolStarted(toolName);
    IAgentTool *tool = toolForName(toolName);
    QVariant result;
    if (tool) {
        result = tool->execute(params);
    } else {
        result = QVariantMap{{"error", "未知工具: " + toolName}};
    }
    emit toolFinished(toolName, result);
    return result;
}

QStringList ToolExecutor::registeredToolNames() const
{
    QStringList names;
    for (const auto &t : m_tools) {
        if (t)
            names << t->name();
    }
    return names;
}
