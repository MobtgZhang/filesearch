#include "SearchEngine.h"

SearchEngine::SearchEngine(QObject *parent)
    : QObject(parent)
{
}

void SearchEngine::query(const QString &pattern)
{
    Q_UNUSED(pattern);
    // TODO: 实现倒排索引 + 正则过滤
    emit resultsReady(QList<UnifiedFileRecord>());
}

void SearchEngine::clear()
{
    m_index.clear();
}
