#include "IndexEngine.h"

IndexEngine::IndexEngine(QObject *parent)
    : QObject(parent)
{
}

void IndexEngine::buildIndex(const QString &rootPath)
{
    Q_UNUSED(rootPath);
    m_fileCount = 0;
    emit fileCountChanged();
}

void IndexEngine::stop()
{
}
