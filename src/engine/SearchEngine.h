#ifndef SEARCHENGINE_H
#define SEARCHENGINE_H

#include <QObject>
#include "../model/UnifiedFileRecord.h"

class SearchEngine : public QObject
{
    Q_OBJECT

public:
    explicit SearchEngine(QObject *parent = nullptr);

    Q_INVOKABLE void query(const QString &pattern);
    Q_INVOKABLE void setBaseFiles(const QList<UnifiedFileRecord> &files);
    Q_INVOKABLE void clear();

    /** 同步查询，供 Agent 工具调用，返回匹配的文件列表 */
    QList<UnifiedFileRecord> querySync(const QString &pattern) const;

signals:
    void resultsReady(const QList<UnifiedFileRecord> &files);
    void searchStats(int foundCount, qint64 totalSizeBytes, qint64 elapsedMs);

private:
    QList<UnifiedFileRecord> m_baseFiles;
};

#endif // SEARCHENGINE_H
