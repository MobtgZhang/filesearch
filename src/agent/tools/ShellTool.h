#ifndef SHELLTOOL_H
#define SHELLTOOL_H

#include "IAgentTool.h"

/**
 * 执行 Shell 命令原子工具
 * 参数: command (QString) - 要执行的 shell 命令
 *       timeoutMs (int, 可选) - 超时毫秒，默认 30000
 */
class ShellTool : public IAgentTool
{
public:
    ShellTool();

    QString name() const override;
    QString description() const override;
    QVariant execute(const QVariantMap &params) override;
};

#endif // SHELLTOOL_H
