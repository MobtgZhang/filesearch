#include "MoveFilesTool.h"
#include "../../service/FileOperationService.h"
#include <QStringList>
#include <QVariantList>

MoveFilesTool::MoveFilesTool(FileOperationService *service)
    : m_service(service)
{
}

QString MoveFilesTool::name() const
{
    return QStringLiteral("move_files");
}

QString MoveFilesTool::description() const
{
    return QStringLiteral("将文件或目录移动到目标路径");
}

QVariant MoveFilesTool::execute(const QVariantMap &params)
{
    if (!m_service)
        return QVariantMap{{"error", "FileOperationService 未初始化"}};

    QStringList sources;
    QVariant v = params.value("sources");
    if (v.canConvert<QStringList>())
        sources = v.toStringList();
    else if (v.canConvert<QVariantList>()) {
        for (const QVariant &item : v.toList())
            sources.append(item.toString());
    }

    QString destination = params.value("destination").toString();
    bool ok = m_service->moveFiles(sources, destination);
    return QVariantMap{
        {"success", ok},
        {"movedCount", sources.size()},
        {"destination", destination}
    };
}
