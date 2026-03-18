#ifndef AIBRIDGE_H
#define AIBRIDGE_H

#include <QObject>

class AIBridge : public QObject
{
    Q_OBJECT

public:
    explicit AIBridge(QObject *parent = nullptr);

    Q_INVOKABLE void sendMessage(const QString &text);
    Q_INVOKABLE void setContext(const QString &context);

signals:
    void responseReceived(const QString &text);
    void errorOccurred(const QString &message);

private:
    QString m_context;
};

#endif // AIBRIDGE_H
