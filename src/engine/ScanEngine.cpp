#include "ScanEngine.h"
#include "ScanWorker.h"
#include <QDir>
#include <QFileInfo>
#include <QStandardPaths>
#include <QStorageInfo>
#include <QThread>
#include <algorithm>

ScanEngine::ScanEngine(QObject *parent)
    : QObject(parent)
{
    m_thread = new QThread(this);
    m_worker = new ScanWorker();
    m_worker->moveToThread(m_thread);

    connect(m_worker, &ScanWorker::progress, this, &ScanEngine::scanProgress);
    connect(m_worker, &ScanWorker::finished, this, [this](const QVariantMap &result) {
        emit segmentsReady(result);
    });

    m_thread->start();
}

ScanEngine::~ScanEngine()
{
    if (m_worker) {
        m_worker->cancel();
    }
    if (m_thread && m_thread->isRunning()) {
        m_thread->quit();
        if (!m_thread->wait(2000)) {
            m_thread->terminate();
            m_thread->wait(500);
        }
    }
}

QVariantList ScanEngine::mountedVolumes()
{
    QVariantList list;
    const auto volumes = QStorageInfo::mountedVolumes();
    for (const QStorageInfo &info : volumes) {
        if (!info.isValid() || !info.isReady() || info.bytesTotal() <= 0)
            continue;
        QString root = info.rootPath();
        if (root == "/proc" || root == "/sys" || root == "/dev" || root.startsWith("/run/"))
            continue;
        if (info.bytesTotal() < 50 * 1024 * 1024)
            continue;
        QVariantMap m;
        m["path"] = root;
        m["name"] = info.displayName().isEmpty() ? root : info.displayName();
        m["total"] = info.bytesTotal();
        m["available"] = info.bytesAvailable();
        m["used"] = info.bytesTotal() - info.bytesAvailable();
        list.append(m);
    }
    std::sort(list.begin(), list.end(), [](const QVariant &a, const QVariant &b) {
        return a.toMap()["path"].toString() < b.toMap()["path"].toString();
    });
    if (list.isEmpty()) {
        QVariantMap m;
        m["path"] = "/";
        m["name"] = "/";
        m["total"] = 0;
        m["available"] = 0;
        m["used"] = 0;
        list.append(m);
    }
    return list;
}

void ScanEngine::scan(const QString &path)
{
    QString scanPath = path;
    if (scanPath.isEmpty()) scanPath = "/";

    QMetaObject::invokeMethod(m_worker, "scan", Qt::QueuedConnection, Q_ARG(QString, scanPath));
}

void ScanEngine::stop()
{
    if (m_worker)
        m_worker->cancel();
}
