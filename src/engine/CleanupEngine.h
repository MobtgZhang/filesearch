#ifndef CLEANUPENGINE_H
#define CLEANUPENGINE_H

#include <QObject>
#include <QVariantList>

class CleanupWorker;
class QThread;

class CleanupEngine : public QObject
{
    Q_OBJECT

public:
    explicit CleanupEngine(QObject *parent = nullptr);
    ~CleanupEngine();

    Q_INVOKABLE void scan(const QVariantList &categoryIds);
    Q_INVOKABLE void stop();

signals:
    void progress(int categoryIndex, int scannedFiles, qint64 scannedSize, qint64 elapsedMs);
    void categoryReady(int categoryId, const QString &name, const QVariantList &files, qint64 totalSize);
    void finished(qint64 elapsedMs);

private:
    CleanupWorker *m_worker = nullptr;
    QThread *m_thread = nullptr;
};

#endif // CLEANUPENGINE_H
