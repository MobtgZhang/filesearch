#ifndef DELETEFILESTOOL_H
#define DELETEFILESTOOL_H

#include "IAgentTool.h"

class FileOperationService;

/**
 * 删除文件原子工具
 * 参数: paths (QStringList) - 待删除路径列表
 *       dryRun (bool, 可选) - 若为 true 仅模拟不实际删除
 */
class DeleteFilesTool : public IAgentTool
{
public:
    explicit DeleteFilesTool(FileOperationService *service);

    QString name() const override;
    QString description() const override;
    QVariant execute(const QVariantMap &params) override;

private:
    FileOperationService *m_service = nullptr;
};

#endif // DELETEFILESTOOL_H
