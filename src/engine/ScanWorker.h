#ifndef SCANWORKER_H
#define SCANWORKER_H

#include <QObject>
#include <QVariantList>
#include <QVariantMap>
#include <atomic>

class ScanWorker : public QObject
{
    Q_OBJECT

public:
    explicit ScanWorker(QObject *parent = nullptr);
    void cancel();

public slots:
    void scan(const QString &path);

signals:
    void progress(int fileCount, qint64 elapsedMs, const QVariantList &categories);
    void finished(const QVariantMap &result);

private:
    QVariantList buildCategoriesFromSizes(const qint64 *sizes) const;

    std::atomic<bool> m_abort{false};
};

#endif // SCANWORKER_H
