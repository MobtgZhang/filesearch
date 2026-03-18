#ifndef INDEXENGINE_H
#define INDEXENGINE_H

#include <QObject>
#include "../model/UnifiedFileRecord.h"

class IndexEngine : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int fileCount READ fileCount NOTIFY fileCountChanged)

public:
    explicit IndexEngine(QObject *parent = nullptr);
    int fileCount() const { return m_fileCount; }

    Q_INVOKABLE void buildIndex(const QString &rootPath);
    Q_INVOKABLE void stop();

signals:
    void fileCountChanged();
    void indexProgress(int current, int total);

private:
    int m_fileCount = 0;
};

#endif // INDEXENGINE_H
