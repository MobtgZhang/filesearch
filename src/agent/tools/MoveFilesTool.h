#ifndef MOVEFILESTOOL_H
#define MOVEFILESTOOL_H

#include "IAgentTool.h"

class FileOperationService;

/**
 * 移动文件原子工具
 * 参数: sources (QStringList) - 源路径列表
 *       destination (QString) - 目标目录
 */
class MoveFilesTool : public IAgentTool
{
public:
    explicit MoveFilesTool(FileOperationService *service);

    QString name() const override;
    QString description() const override;
    QVariant execute(const QVariantMap &params) override;

private:
    FileOperationService *m_service = nullptr;
};

#endif // MOVEFILESTOOL_H
