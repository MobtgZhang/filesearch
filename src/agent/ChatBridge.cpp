#include "ChatBridge.h"

ChatBridge::ChatBridge(QObject *parent)
    : QObject(parent)
{
}

void ChatBridge::addUserMessage(const QString &text)
{
    if (!text.trimmed().isEmpty())
        emit userMessageAdded(text);
}

void ChatBridge::addAiMessage(const QString &text)
{
    emit aiMessageAdded(text);
}

void ChatBridge::addToolExecution(const QString &name, const QString &status, const QString &result)
{
    emit toolExecutionAdded(name, status, result);
}
