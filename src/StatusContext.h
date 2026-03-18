#ifndef STATUSCONTEXT_H
#define STATUSCONTEXT_H

#include <QObject>

class StatusContext : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int indexedFileCount READ indexedFileCount WRITE setIndexedFileCount NOTIFY indexedFileCountChanged)
    Q_PROPERTY(int operationTimeMs READ operationTimeMs WRITE setOperationTimeMs NOTIFY operationTimeMsChanged)
    Q_PROPERTY(int foundFileCount READ foundFileCount WRITE setFoundFileCount NOTIFY foundFileCountChanged)
    Q_PROPERTY(qint64 foundTotalSize READ foundTotalSize WRITE setFoundTotalSize NOTIFY foundTotalSizeChanged)
    Q_PROPERTY(QString operationTimeFormatted READ operationTimeFormatted NOTIFY operationTimeFormattedChanged)

public:
    explicit StatusContext(QObject *parent = nullptr);

    int indexedFileCount() const { return m_indexedFileCount; }
    void setIndexedFileCount(int v);

    int operationTimeMs() const { return m_operationTimeMs; }
    void setOperationTimeMs(int v);

    int foundFileCount() const { return m_foundFileCount; }
    void setFoundFileCount(int v);

    qint64 foundTotalSize() const { return m_foundTotalSize; }
    void setFoundTotalSize(qint64 v);

    QString operationTimeFormatted() const { return m_operationTimeFormatted; }

signals:
    void indexedFileCountChanged();
    void operationTimeMsChanged();
    void operationTimeFormattedChanged();
    void foundFileCountChanged();
    void foundTotalSizeChanged();

private:
    void updateFormatted();

    int m_indexedFileCount = 0;
    int m_operationTimeMs = 0;
    int m_foundFileCount = 0;
    qint64 m_foundTotalSize = 0;
    QString m_operationTimeFormatted;
};

#endif // STATUSCONTEXT_H
