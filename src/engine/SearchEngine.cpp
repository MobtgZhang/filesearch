#include "SearchEngine.h"
#include <QElapsedTimer>

SearchEngine::SearchEngine(QObject *parent)
    : QObject(parent)
{
}

void SearchEngine::setBaseFiles(const QList<UnifiedFileRecord> &files)
{
    m_baseFiles = files;
}

void SearchEngine::query(const QString &pattern)
{
    QElapsedTimer timer;
    timer.start();

    QList<UnifiedFileRecord> results;
    QString lowerPattern = pattern.trimmed().toLower();

    if (lowerPattern.isEmpty()) {
        results = m_baseFiles;
    } else {
        for (const auto &f : m_baseFiles) {
            if (f.name.toLower().contains(lowerPattern)
                || f.path.toLower().contains(lowerPattern)
                || f.extension.toLower().contains(lowerPattern)) {
                results.append(f);
            }
        }
    }

    qint64 totalSize = 0;
    for (const auto &f : results)
        totalSize += f.size;

    qint64 elapsed = timer.elapsed();
    emit resultsReady(results);
    emit searchStats(results.size(), totalSize, elapsed);
}

void SearchEngine::clear()
{
    m_baseFiles.clear();
}

QList<UnifiedFileRecord> SearchEngine::querySync(const QString &pattern) const
{
    QString lowerPattern = pattern.trimmed().toLower();
    if (lowerPattern.isEmpty())
        return m_baseFiles;

    QList<UnifiedFileRecord> results;
    for (const auto &f : m_baseFiles) {
        if (f.name.toLower().contains(lowerPattern)
            || f.path.toLower().contains(lowerPattern)
            || f.extension.toLower().contains(lowerPattern)) {
            results.append(f);
        }
    }
    return results;
}
