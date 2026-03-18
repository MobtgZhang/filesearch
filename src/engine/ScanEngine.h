#ifndef SCANENGINE_H
#define SCANENGINE_H

#include <QObject>
#include <QVariantList>
#include <QVariantMap>

struct DiskSegment {
    QString path;
    QString label;
    qint64 size;
    QString color;
};

class ScanWorker;
class QThread;

class ScanEngine : public QObject
{
    Q_OBJECT

public:
    explicit ScanEngine(QObject *parent = nullptr);
    ~ScanEngine();

    Q_INVOKABLE void scan(const QString &path);
    Q_INVOKABLE void stop();
    Q_INVOKABLE QVariantList mountedVolumes();

signals:
    void segmentsReady(const QVariantMap &result);
    void scanProgress(int fileCount, qint64 elapsedMs, const QVariantList &categories);

private:
    ScanWorker *m_worker = nullptr;
    QThread *m_thread = nullptr;
};

#endif // SCANENGINE_H
