#ifndef PATHPROVIDER_H
#define PATHPROVIDER_H

#include <QObject>

class PathProvider : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString homePath READ homePath CONSTANT)
    Q_PROPERTY(QString desktopPath READ desktopPath CONSTANT)
    Q_PROPERTY(QString documentsPath READ documentsPath CONSTANT)
    Q_PROPERTY(QString downloadPath READ downloadPath CONSTANT)

public:
    explicit PathProvider(QObject *parent = nullptr);
    QString homePath() const;
    QString desktopPath() const;
    QString documentsPath() const;
    QString downloadPath() const;
};

#endif // PATHPROVIDER_H
