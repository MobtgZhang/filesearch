#ifndef TOOLEXECUTOR_H
#define TOOLEXECUTOR_H

#include <QObject>
#include <QVariantMap>

class ToolExecutor : public QObject
{
    Q_OBJECT

public:
    explicit ToolExecutor(QObject *parent = nullptr);

    Q_INVOKABLE QVariant execute(const QString &toolName, const QVariantMap &params);

signals:
    void toolStarted(const QString &name);
    void toolFinished(const QString &name, const QVariant &result);

private:
};

#endif // TOOLEXECUTOR_H
