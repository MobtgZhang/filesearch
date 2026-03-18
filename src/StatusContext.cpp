#include "StatusContext.h"

StatusContext::StatusContext(QObject *parent)
    : QObject(parent)
{
}

void StatusContext::setIndexedFileCount(int v)
{
    if (m_indexedFileCount != v) {
        m_indexedFileCount = v;
        emit indexedFileCountChanged();
    }
}

void StatusContext::setOperationTimeMs(int v)
{
    if (m_operationTimeMs != v) {
        m_operationTimeMs = v;
        m_operationTimeFormatted = v < 1000 ? QString::number(v) + " 毫秒"
                                            : QString::number(v / 1000.0, 'f', 1) + " 秒";
        emit operationTimeMsChanged();
        emit operationTimeFormattedChanged();
    }
}

void StatusContext::setFoundFileCount(int v)
{
    if (m_foundFileCount != v) {
        m_foundFileCount = v;
        emit foundFileCountChanged();
    }
}

void StatusContext::setFoundTotalSize(qint64 v)
{
    if (m_foundTotalSize != v) {
        m_foundTotalSize = v;
        emit foundTotalSizeChanged();
    }
}

void StatusContext::updateFormatted()
{
    m_operationTimeFormatted = m_operationTimeMs < 1000
        ? QString::number(m_operationTimeMs) + " 毫秒"
        : QString::number(m_operationTimeMs / 1000.0, 'f', 1) + " 秒";
}
