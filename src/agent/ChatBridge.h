#ifndef CHATBRIDGE_H
#define CHATBRIDGE_H

#include <QObject>

class ChatBridge : public QObject
{
    Q_OBJECT

public:
    explicit ChatBridge(QObject *parent = nullptr);

public slots:
    void addUserMessage(const QString &text);
    void addAiMessage(const QString &text);
    void addToolExecution(const QString &name, const QString &status, const QString &result);

signals:
    void userMessageAdded(const QString &text);
    void aiMessageAdded(const QString &text);
    void toolExecutionAdded(const QString &name, const QString &status, const QString &result);
};

#endif // CHATBRIDGE_H
