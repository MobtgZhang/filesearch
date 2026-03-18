#include "DuplicateEngine.h"
#include "DuplicateWorker.h"
#include <QThread>

DuplicateEngine::DuplicateEngine(QObject *parent)
    : QObject(parent)
{
    m_thread = new QThread(this);
    m_worker = new DuplicateWorker();
    m_worker->moveToThread(m_thread);

    connect(m_worker, &DuplicateWorker::progress, this, &DuplicateEngine::progress);
    connect(m_worker, &DuplicateWorker::finished, this, [this](const QVariantList &groups, int totalScanned, qint64 elapsedMs) {
        emit duplicatesReady(groups, totalScanned, elapsedMs);
    });

    m_thread->start();
}

DuplicateEngine::~DuplicateEngine()
{
    if (m_worker)
        m_worker->cancel();
    if (m_thread && m_thread->isRunning()) {
        m_thread->quit();
        if (!m_thread->wait(3000)) {
            m_thread->terminate();
            m_thread->wait(500);
        }
    }
}

void DuplicateEngine::scan(const QString &path, int hashAlgo, int fileTypeFilter, qint64 minSizeBytes)
{
    QString scanPath = path;
    if (scanPath.isEmpty()) scanPath = "/";

    QMetaObject::invokeMethod(m_worker, "scan", Qt::QueuedConnection,
        Q_ARG(QString, scanPath),
        Q_ARG(int, hashAlgo),
        Q_ARG(int, fileTypeFilter),
        Q_ARG(qint64, minSizeBytes));
}

void DuplicateEngine::stop()
{
    if (m_worker)
        m_worker->cancel();
}
