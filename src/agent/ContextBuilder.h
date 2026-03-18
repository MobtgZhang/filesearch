#ifndef CONTEXTBUILDER_H
#define CONTEXTBUILDER_H

#include <QObject>
#include "../model/UnifiedFileRecord.h"

class ContextBuilder : public QObject
{
    Q_OBJECT

public:
    explicit ContextBuilder(QObject *parent = nullptr);

    Q_INVOKABLE QString buildContext(const QList<UnifiedFileRecord> &files);

private:
};

#endif // CONTEXTBUILDER_H
