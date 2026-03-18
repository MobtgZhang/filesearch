#include "ToolExecutor.h"

ToolExecutor::ToolExecutor(QObject *parent)
    : QObject(parent)
{
}

QVariant ToolExecutor::execute(const QString &toolName, const QVariantMap &params)
{
    Q_UNUSED(toolName);
    Q_UNUSED(params);
    // TODO: search_files, delete_files, move_files 等
    return QVariant();
}
