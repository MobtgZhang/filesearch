#include "FileOperationService.h"

FileOperationService::FileOperationService(QObject *parent)
    : QObject(parent)
{
}

bool FileOperationService::deleteFiles(const QStringList &paths, bool dryRun)
{
    Q_UNUSED(paths);
    Q_UNUSED(dryRun);
    return false;
}

bool FileOperationService::moveFiles(const QStringList &sources, const QString &destination)
{
    Q_UNUSED(sources);
    Q_UNUSED(destination);
    return false;
}
