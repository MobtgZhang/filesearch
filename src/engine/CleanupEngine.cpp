#include "CleanupEngine.h"
#include "CleanupWorker.h"
#include <QThread>

CleanupEngine::CleanupEngine(QObject *parent)
    : QObject(parent)
{
    m_thread = new QThread(this);
    m_worker = new CleanupWorker();
    m_worker->moveToThread(m_thread);

    connect(m_worker, &CleanupWorker::progress, this, &CleanupEngine::progress);
    connect(m_worker, &CleanupWorker::categoryReady, this, &CleanupEngine::categoryReady);
    connect(m_worker, &CleanupWorker::finished, this, &CleanupEngine::finished);

    m_thread->start();
}

CleanupEngine::~CleanupEngine()
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

void CleanupEngine::scan(const QVariantList &categoryIds)
{
    QVariantList ids = categoryIds;
    if (ids.isEmpty()) {
        ids << 0 << 1 << 2 << 3 << 4 << 5;
    }
    QMetaObject::invokeMethod(m_worker, "scan", Qt::QueuedConnection,
        Q_ARG(QVariantList, ids));
}

void CleanupEngine::stop()
{
    if (m_worker)
        m_worker->cancel();
}
