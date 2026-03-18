#include "ContextBuilder.h"

ContextBuilder::ContextBuilder(QObject *parent)
    : QObject(parent)
{
}

QString ContextBuilder::buildContext(const QList<UnifiedFileRecord> &files)
{
    Q_UNUSED(files);
    return QString();
}
