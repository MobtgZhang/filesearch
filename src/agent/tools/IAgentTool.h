#ifndef IAGENTTOOL_H
#define IAGENTTOOL_H

#include <QString>
#include <QVariant>
#include <QVariantMap>

/**
 * Agent 原子操作工具基类接口
 * 所有 Agent 可调用的工具均实现此接口
 */
class IAgentTool
{
public:
    virtual ~IAgentTool() = default;

    /** 工具名称，用于 LLM Function Calling 识别 */
    virtual QString name() const = 0;

    /** 工具描述，供 LLM 理解工具用途 */
    virtual QString description() const = 0;

    /** 执行原子操作，params 为 JSON 风格参数，返回执行结果 */
    virtual QVariant execute(const QVariantMap &params) = 0;
};

#endif // IAGENTTOOL_H
