#ifndef FILEOPERATIONSERVICE_H
#define FILEOPERATIONSERVICE_H

#include <QObject>
#include <QStringList>

class FileOperationService : public QObject
{
    Q_OBJECT

public:
    explicit FileOperationService(QObject *parent = nullptr);

    Q_INVOKABLE bool deleteFiles(const QStringList &paths, bool dryRun = false);
    Q_INVOKABLE bool moveFiles(const QStringList &sources, const QString &destination);

signals:
    void operationCompleted(bool success, const QString &message);

private:
};

#endif // FILEOPERATIONSERVICE_H
