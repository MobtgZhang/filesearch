#include "PathProvider.h"
#include <QStandardPaths>

PathProvider::PathProvider(QObject *parent)
    : QObject(parent)
{
}

QString PathProvider::homePath() const
{
    return QStandardPaths::writableLocation(QStandardPaths::HomeLocation);
}

QString PathProvider::desktopPath() const
{
    return QStandardPaths::writableLocation(QStandardPaths::DesktopLocation);
}

QString PathProvider::documentsPath() const
{
    return QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
}

QString PathProvider::downloadPath() const
{
    return QStandardPaths::writableLocation(QStandardPaths::DownloadLocation);
}
