#include "FileOperationService.h"
#include <QDir>
#include <QFile>
#include <QFileInfo>

FileOperationService::FileOperationService(QObject *parent)
    : QObject(parent)
{
}

bool FileOperationService::deleteFiles(const QStringList &paths, bool dryRun)
{
    if (dryRun)
        return true;

    bool allOk = true;
    QString lastError;

    for (const QString &path : paths) {
        QString p = path;
        if (p.startsWith("file://"))
            p = p.mid(7);

        QFileInfo fi(p);
        if (!fi.exists()) {
            lastError = "文件不存在: " + p;
            allOk = false;
            continue;
        }

        if (fi.isDir()) {
            QDir dir(p);
            if (!dir.removeRecursively()) {
                lastError = "无法删除目录: " + p;
                allOk = false;
            }
        } else {
            QFile file(p);
            if (!file.remove()) {
                lastError = file.errorString() + ": " + p;
                allOk = false;
            }
        }
    }

    emit operationCompleted(allOk, allOk ? QString() : lastError);
    return allOk;
}

bool FileOperationService::moveFiles(const QStringList &sources, const QString &destination)
{
    Q_UNUSED(sources);
    Q_UNUSED(destination);
    return false;
}
