#include "ScanWorker.h"
#include <QDir>
#include <QElapsedTimer>
#include <QFileInfo>
#include <QStandardPaths>
#include <QStorageInfo>
#include <algorithm>
#include <functional>

namespace {
const QStringList ACCENT_COLORS = {
    "#4af0b4", "#7b6ff0", "#f07b6f", "#f0c46f", "#6b8e23", "#2a3040"
};

const QStringList MOVIE_EXTS = {"mp4", "mkv", "avi", "mov", "wmv", "flv", "webm", "m4v", "mpg", "mpeg", "3gp"};
const QStringList DOC_EXTS = {"pdf", "doc", "docx", "xls", "xlsx", "ppt", "pptx", "txt", "md", "odt", "ods", "odp", "rtf", "csv"};
const QStringList PICTURE_EXTS = {"jpg", "jpeg", "png", "gif", "webp", "bmp", "svg", "ico", "tiff", "tif", "raw", "heic"};
const QStringList MUSIC_EXTS = {"mp3", "flac", "wav", "ogg", "m4a", "aac", "wma"};

QString formatSize(qint64 bytes)
{
    if (bytes >= 1024ULL * 1024 * 1024 * 1024)
        return QString::number(bytes / (1024.0 * 1024 * 1024 * 1024), 'f', 1) + " TB";
    if (bytes >= 1024ULL * 1024 * 1024)
        return QString::number(bytes / (1024.0 * 1024 * 1024), 'f', 1) + " GB";
    if (bytes >= 1024ULL * 1024)
        return QString::number(bytes / (1024.0 * 1024), 'f', 1) + " MB";
    if (bytes >= 1024)
        return QString::number(bytes / 1024.0, 'f', 1) + " KB";
    return QString::number(bytes) + " B";
}

int categoryForFile(const QString &path, const QString &ext)
{
    QString lowerExt = ext.toLower();
    if (MOVIE_EXTS.contains(lowerExt)) return 0;
    if (DOC_EXTS.contains(lowerExt)) return 1;
    if (PICTURE_EXTS.contains(lowerExt)) return 2;
    if (MUSIC_EXTS.contains(lowerExt)) return 3;
    if (path.contains("/.config/") || path.contains("/.cache/") || path.contains("/.local/")
        || path.contains("/node_modules/") || path.contains("/.npm/")
        || lowerExt == "db" || lowerExt == "sqlite" || lowerExt == "log" || lowerExt == "conf")
        return 4;
    return 5;
}

const int PROGRESS_INTERVAL_MS = 150;
const int PROGRESS_INTERVAL_FILES = 50;
const int MAX_TREE_DEPTH = 5;
const int MAX_CHILDREN_PER_LEVEL = 25;
} // namespace

ScanWorker::ScanWorker(QObject *parent)
    : QObject(parent)
{
}

QVariantList ScanWorker::buildCategoriesFromSizes(const qint64 *sizes) const
{
    const char *labelsZh[] = {"视频", "文档", "图片", "音频", "系统", "其他"};
    QVariantList categories;
    for (int i = 0; i < 6; i++) {
        QVariantMap m;
        m["labelShort"] = labelsZh[i];
        m["size"] = sizes[i];
        m["sizeFormatted"] = formatSize(sizes[i]);
        m["color"] = ACCENT_COLORS[i];
        categories.append(m);
    }
    return categories;
}

void ScanWorker::cancel()
{
    m_abort = true;
}

void ScanWorker::scan(const QString &path)
{
    m_abort = false;
    QElapsedTimer timer;
    timer.start();

    QString scanPath = path;
    if (scanPath.isEmpty()) scanPath = "/";
    if (scanPath.startsWith("~"))
        scanPath = QStandardPaths::writableLocation(QStandardPaths::HomeLocation) + scanPath.mid(1);

    QStorageInfo storage(scanPath);
    if (!storage.isValid() || !storage.isReady()) storage.setPath(scanPath);
    qint64 totalBytes = storage.bytesTotal();
    qint64 usedBytes = totalBytes > 0 ? (storage.bytesTotal() - storage.bytesAvailable()) : 0;

    QDir dir(scanPath);
    if (!dir.exists()) {
        emit finished(QVariantMap{{"usedSize", qint64(0)}, {"totalSize", qint64(0)}, {"categories", QVariantList()},
                                 {"fileCount", 0}, {"fileList", QVariantList()}, {"elapsedMs", timer.elapsed()}});
        return;
    }

    qint64 sizes[6] = {0, 0, 0, 0, 0, 0};
    int fileCount = 0;
    qint64 lastEmitMs = 0;
    int lastEmitFiles = 0;
    QVariantList fileList;
    QString rootPath = dir.absolutePath();
    if (!rootPath.endsWith("/")) rootPath += "/";

    QList<QVariantMap> dirTreeChildren;
    std::function<QVariantMap(const QString &, const QString &, int)> scanDirTree;
    scanDirTree = [&](const QString &currentPath, const QString &dirName, int depth) -> QVariantMap {
        QVariantMap node;
        node["path"] = currentPath;
        node["name"] = dirName.isEmpty() ? QFileInfo(currentPath).fileName() : dirName;
        node["isDirectory"] = true;
        qint64 dirSize = 0;
        QList<QVariantMap> children;

        QDir d(currentPath);
        if (!d.exists()) return node;

        const auto entries = d.entryList(QDir::Dirs | QDir::Files | QDir::Hidden | QDir::NoDotAndDotDot,
                                        QDir::Name | QDir::DirsFirst);
        for (const QString &name : entries) {
            if (m_abort) return node;
            QString fullPath = d.absoluteFilePath(name);
            QFileInfo fi(fullPath);
            if (fi.isSymLink()) continue;
            if (fi.isDir()) {
                QVariantMap childNode = scanDirTree(fullPath, name, depth + 1);
                qint64 childSize = childNode["size"].toLongLong();
                dirSize += childSize;
                if (depth < MAX_TREE_DEPTH && childSize > 0) {
                    childNode["sizeFormatted"] = formatSize(childSize);
                    children.append(childNode);
                }
                QVariantMap dm;
                dm["path"] = fullPath;
                dm["name"] = name;
                dm["size"] = childSize;
                dm["modified"] = fi.lastModified().toString(Qt::ISODate);
                dm["extension"] = QString();
                dm["isDirectory"] = true;
                fileList.append(dm);
            } else {
                fileCount++;
                qint64 sz = fi.size();
                dirSize += sz;
                QString relPath = fullPath.mid(rootPath.length());
                int cat = categoryForFile(relPath, fi.suffix());
                sizes[cat] += sz;

                QVariantMap fm;
                fm["path"] = fullPath;
                fm["name"] = name;
                fm["size"] = sz;
                fm["modified"] = fi.lastModified().toString(Qt::ISODate);
                fm["extension"] = fi.suffix();
                fm["isDirectory"] = false;
                fileList.append(fm);

                qint64 now = timer.elapsed();
                if (now - lastEmitMs >= PROGRESS_INTERVAL_MS || fileCount - lastEmitFiles >= PROGRESS_INTERVAL_FILES) {
                    lastEmitMs = now;
                    lastEmitFiles = fileCount;
                    emit progress(fileCount, now, buildCategoriesFromSizes(sizes));
                }
            }
        }
        std::sort(children.begin(), children.end(), [](const QVariantMap &a, const QVariantMap &b) {
            return a["size"].toLongLong() > b["size"].toLongLong();
        });
        if (children.size() > MAX_CHILDREN_PER_LEVEL)
            children = children.mid(0, MAX_CHILDREN_PER_LEVEL);
        node["size"] = dirSize;
        node["sizeFormatted"] = formatSize(dirSize);
        QVariantList childList;
        for (const auto &c : children) childList.append(c);
        node["children"] = childList;
        return node;
    };

    QVariantMap directoryTree = scanDirTree(scanPath, QFileInfo(scanPath).fileName(), 0);
    if (directoryTree["name"].toString().isEmpty())
        directoryTree["name"] = scanPath.endsWith("/") ? QFileInfo(scanPath.left(scanPath.length()-1)).fileName() : QFileInfo(scanPath).fileName();

    qint64 scannedTotal = 0;
    for (int i = 0; i < 6; i++) scannedTotal += sizes[i];
    usedBytes = scannedTotal;
    totalBytes = scannedTotal;

    const char *labels[] = {"Movies", "Documents", "Pictures", "Music", "System", "Others"};
    const char *labelsZh[] = {"视频", "文档", "图片", "音频", "系统", "其他"};
    QVariantList categories;
    for (int i = 0; i < 6; i++) {
        QVariantMap m;
        m["label"] = QString("%1 (%2)").arg(labels[i]).arg(labelsZh[i]);
        m["labelShort"] = labelsZh[i];
        m["size"] = sizes[i];
        m["sizeFormatted"] = formatSize(sizes[i]);
        m["color"] = ACCENT_COLORS[i];
        categories.append(m);
    }

    QVariantMap result;
    result["usedSize"] = usedBytes;
    result["totalSize"] = totalBytes;
    result["categories"] = categories;
    result["fileCount"] = fileCount;
    result["fileList"] = fileList;
    result["directoryTree"] = directoryTree;
    result["scanPath"] = scanPath;
    result["elapsedMs"] = timer.elapsed();
    emit finished(result);
}
