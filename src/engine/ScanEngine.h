#ifndef SCANENGINE_H
#define SCANENGINE_H

#include <QObject>
#include "../model/UnifiedFileRecord.h"

struct DiskSegment {
    QString path;
    QString label;
    qint64 size;
    QString color;
};

class ScanEngine : public QObject
{
    Q_OBJECT

public:
    explicit ScanEngine(QObject *parent = nullptr);

    Q_INVOKABLE void scan(const QString &path);

signals:
    void segmentsReady(const QList<DiskSegment> &segments);

private:
};

#endif // SCANENGINE_H
