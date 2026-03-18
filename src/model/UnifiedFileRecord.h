#ifndef UNIFIEDFILERECORD_H
#define UNIFIEDFILERECORD_H

#include <QString>
#include <QDateTime>
#include <QByteArray>

struct UnifiedFileRecord {
    QString path;           // 完整路径
    QString name;           // 文件名
    qint64 size = 0;        // 字节大小
    QDateTime modified;     // 修改时间
    QDateTime lastAccessed; // 最后访问时间
    QString extension;      // 扩展名
    QString mimeType;       // MIME 类型
    QByteArray contentHash; // SHA256（重复检测用）
    bool isDirectory = false;
    QString aiTags;         // AI 生成的语义标签
};

#endif // UNIFIEDFILERECORD_H
