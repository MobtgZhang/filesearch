#include "CleanupWorker.h"
#include <QDir>
#include <QElapsedTimer>
#include <QFileInfo>
#include <QStandardPaths>

namespace {
const int PROGRESS_INTERVAL_MS = 150;
const int PROGRESS_INTERVAL_FILES = 50;

QStringList getCategoryPaths(int categoryId)
{
    QString home = QStandardPaths::writableLocation(QStandardPaths::HomeLocation);
    QString cache = QStandardPaths::writableLocation(QStandardPaths::CacheLocation);
    QString genericCache = QStandardPaths::writableLocation(QStandardPaths::GenericCacheLocation);
    QString temp = QDir::tempPath();
    QString genericData = QStandardPaths::writableLocation(QStandardPaths::GenericDataLocation);

    QStringList paths;
    switch (categoryId) {
    case 0: // 系统缓存
        if (!cache.isEmpty()) paths << cache;
        if (!genericCache.isEmpty()) paths << genericCache;
        if (!home.isEmpty()) paths << (home + "/.cache");
        break;
    case 1: // 临时文件
        if (!temp.isEmpty()) paths << temp;
        paths << qEnvironmentVariable("TMPDIR", "");
        paths << qEnvironmentVariable("TEMP", "");
        paths << qEnvironmentVariable("TMP", "");
        paths.removeAll("");
        paths.removeDuplicates();
        break;
    case 2: // 回收站
        paths << (home + "/.local/share/Trash/files");
        paths << (genericData + "/Trash/files");
        break;
    case 3: // 浏览器缓存
        paths << (home + "/.cache/google-chrome");
        paths << (home + "/.cache/google-chrome-beta");
        paths << (home + "/.cache/google-chrome-unstable");
        paths << (home + "/.cache/chromium");
        paths << (home + "/.cache/mozilla/firefox");
        paths << (home + "/.cache/microsoft-edge");
        paths << (home + "/.cache/opera");
        paths << (home + "/.cache/brave");
        paths << (home + "/.var/app/org.mozilla.firefox/cache");
        break;
    case 4: // 软件缓存 (thumbnails, package cache 等)
        paths << (home + "/.cache/thumbnails");
        paths << (home + "/.cache/pip");
        paths << (home + "/.npm");
        paths << (home + "/.yarn/cache");
        break;
    case 5: // 下载缓存 (下载目录中的临时/未完成文件)
        paths << QStandardPaths::writableLocation(QStandardPaths::DownloadLocation);
        break;
    default:
        break;
    }
    QStringList existing;
    for (const QString &p : paths) {
        if (QDir(p).exists())
            existing << p;
    }
    return existing;
}

QString getCategoryName(int categoryId)
{
    switch (categoryId) {
    case 0: return "系统缓存";
    case 1: return "临时文件";
    case 2: return "回收站";
    case 3: return "浏览器缓存";
    case 4: return "软件缓存";
    case 5: return "下载缓存";
    default: return "未知";
    }
}
} // namespace

CleanupWorker::CleanupWorker(QObject *parent)
    : QObject(parent)
{
}

void CleanupWorker::cancel()
{
    m_abort = true;
}

void CleanupWorker::scan(const QVariantList &categoryIds)
{
    m_abort = false;
    QElapsedTimer timer;
    timer.start();

    for (int i = 0; i < categoryIds.size() && !m_abort; ++i) {
        int catId = categoryIds[i].toInt();
        ScanResult result = scanCategory(catId);
        emit categoryReady(catId, result.name, result.files, result.totalSize);
        emit progress(i, result.files.size(), result.totalSize, timer.elapsed());
    }
    emit finished(timer.elapsed());
}

namespace {
bool isDownloadTempFile(const QString &fileName)
{
    QString lower = fileName.toLower();
    return lower.endsWith(".crdownload") || lower.endsWith(".part") || lower.endsWith(".tmp")
        || lower.endsWith(".temp") || lower.endsWith(".!ut") || lower.endsWith(".download");
}
}

CleanupWorker::ScanResult CleanupWorker::scanCategory(int categoryId)
{
    ScanResult r;
    r.categoryId = categoryId;
    r.name = getCategoryName(categoryId);

    QStringList paths = getCategoryPaths(categoryId);
    for (const QString &dirPath : paths) {
        if (m_abort) break;
        r.totalSize += collectFiles(dirPath, r.files, categoryId != 5, QStringList(), categoryId == 5);
    }
    return r;
}

qint64 CleanupWorker::collectFiles(const QString &dirPath, QVariantList &outFiles, bool recursive, const QStringList &nameFilters, bool downloadTempOnly)
{
    Q_UNUSED(nameFilters);
    qint64 total = 0;
    QDir dir(dirPath);
    if (!dir.exists()) return 0;

    QFileInfoList entries = dir.entryInfoList(QDir::Files | QDir::Dirs | QDir::NoDotAndDotDot | QDir::Hidden);
    for (const QFileInfo &fi : entries) {
        if (m_abort) break;
        QString path = fi.absoluteFilePath();
        if (fi.isDir()) {
            if (recursive) {
                total += collectFiles(path, outFiles, true, QStringList(), false);
            }
        } else {
            if (downloadTempOnly && !isDownloadTempFile(fi.fileName()))
                continue;
            qint64 sz = fi.size();
            total += sz;
            QVariantMap m;
            m["path"] = path;
            m["name"] = fi.fileName();
            m["size"] = sz;
            outFiles.append(m);
        }
    }
    return total;
}
