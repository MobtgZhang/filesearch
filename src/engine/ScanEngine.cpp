#include "ScanEngine.h"

ScanEngine::ScanEngine(QObject *parent)
    : QObject(parent)
{
}

void ScanEngine::scan(const QString &path)
{
    Q_UNUSED(path);
    emit segmentsReady(QList<DiskSegment>());
}
