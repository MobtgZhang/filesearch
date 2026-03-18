#ifndef DUPLICATEENGINE_H
#define DUPLICATEENGINE_H

#include <QObject>
#include <QVariantList>

class DuplicateWorker;
class QThread;

class DuplicateEngine : public QObject
{
    Q_OBJECT

public:
    explicit DuplicateEngine(QObject *parent = nullptr);
    ~DuplicateEngine();

    Q_INVOKABLE void scan(const QString &path, int hashAlgo = 0, int fileTypeFilter = 0, qint64 minSizeBytes = 0);
    Q_INVOKABLE void stop();

signals:
    void progress(int scannedFiles, int candidateGroups, int duplicateGroups, qint64 elapsedMs);
    void duplicatesReady(const QVariantList &groups, int totalScanned, qint64 elapsedMs);

private:
    DuplicateWorker *m_worker = nullptr;
    QThread *m_thread = nullptr;
};

#endif // DUPLICATEENGINE_H
