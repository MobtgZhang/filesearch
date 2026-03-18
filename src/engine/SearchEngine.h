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
    Q_INVOKABLE void clear();

signals:
    void resultsReady(const QList<UnifiedFileRecord> &files);

private:
    QList<UnifiedFileRecord> m_index;
};

#endif // SEARCHENGINE_H
