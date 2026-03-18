#ifndef SEARCHFILESTOOL_H
#define SEARCHFILESTOOL_H

#include "IAgentTool.h"

class SearchEngine;

/**
 * 搜索文件原子工具
 * 参数: pattern (QString) - 搜索关键词
 */
class SearchFilesTool : public IAgentTool
{
public:
    explicit SearchFilesTool(SearchEngine *engine);

    QString name() const override;
    QString description() const override;
    QVariant execute(const QVariantMap &params) override;

private:
    SearchEngine *m_engine = nullptr;
};

#endif // SEARCHFILESTOOL_H
