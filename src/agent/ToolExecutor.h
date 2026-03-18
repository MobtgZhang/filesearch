#ifndef TOOLEXECUTOR_H
#define TOOLEXECUTOR_H

#include <QObject>
#include <QVariantMap>
#include <memory>
#include <vector>

#include "tools/IAgentTool.h"

class SearchEngine;
class FileOperationService;
class AppSettings;

class ToolExecutor : public QObject
{
    Q_OBJECT

public:
    explicit ToolExecutor(QObject *parent = nullptr);

    void setSearchEngine(SearchEngine *engine);
    void setFileOperationService(FileOperationService *service);
    void setAppSettings(AppSettings *settings);

    Q_INVOKABLE QVariant execute(const QString &toolName, const QVariantMap &params);

    /** 获取已注册工具名称列表，供 LLM Function Calling 使用 */
    Q_INVOKABLE QStringList registeredToolNames() const;

signals:
    void toolStarted(const QString &name);
    void toolFinished(const QString &name, const QVariant &result);

private:
    void rebuildTools();
    IAgentTool *toolForName(const QString &name) const;

    SearchEngine *m_searchEngine = nullptr;
    FileOperationService *m_fileOperationService = nullptr;
    AppSettings *m_appSettings = nullptr;
    std::vector<std::unique_ptr<IAgentTool>> m_tools;
};

#endif // TOOLEXECUTOR_H
