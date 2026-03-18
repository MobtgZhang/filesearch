#ifndef WEBSEARCHTOOL_H
#define WEBSEARCHTOOL_H

#include "IAgentTool.h"

class AppSettings;

/**
 * 网页搜索原子工具
 * 参数: query (QString) - 搜索关键词
 *       engine (QString, 可选) - bing | baidu | duckduckgo，默认从设置读取
 */
class WebSearchTool : public IAgentTool
{
public:
    explicit WebSearchTool(AppSettings *settings);

    QString name() const override;
    QString description() const override;
    QVariant execute(const QVariantMap &params) override;

private:
    QString buildSearchUrl(const QString &query, const QString &engine) const;

    AppSettings *m_settings = nullptr;
};

#endif // WEBSEARCHTOOL_H
