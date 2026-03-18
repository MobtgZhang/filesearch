#include "AIBridge.h"

AIBridge::AIBridge(QObject *parent)
    : QObject(parent)
{
}

void AIBridge::sendMessage(const QString &text)
{
    Q_UNUSED(text);
    // TODO: 接入 LLM（本地/云端）
    emit responseReceived(QString());
}

void AIBridge::setContext(const QString &context)
{
    m_context = context;
}
