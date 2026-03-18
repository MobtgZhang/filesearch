#include "DeleteFilesTool.h"
#include "../../service/FileOperationService.h"
#include <QStringList>
#include <QVariantList>

DeleteFilesTool::DeleteFilesTool(FileOperationService *service)
    : m_service(service)
{
}

QString DeleteFilesTool::name() const
{
    return QStringLiteral("delete_files");
}

QString DeleteFilesTool::description() const
{
    return QStringLiteral("删除指定路径的文件或目录");
}

QVariant DeleteFilesTool::execute(const QVariantMap &params)
{
    if (!m_service)
        return QVariantMap{{"error", "FileOperationService 未初始化"}};

    QStringList paths;
    QVariant v = params.value("paths");
    if (v.canConvert<QStringList>())
        paths = v.toStringList();
    else if (v.canConvert<QVariantList>()) {
        for (const QVariant &item : v.toList())
            paths.append(item.toString());
    }

    bool dryRun = params.value("dryRun", false).toBool();
    bool ok = m_service->deleteFiles(paths, dryRun);
    return QVariantMap{
        {"success", ok},
        {"deletedCount", paths.size()},
        {"dryRun", dryRun}
    };
}
