#include "DuplicateWorker.h"
#include <QByteArrayView>
#include <QCryptographicHash>
#include <QDir>
#include <QElapsedTimer>
#include <QFile>
#include <QFileInfo>
#include <QHash>
#include <QStandardPaths>
#include <algorithm>

namespace {
const int PROGRESS_INTERVAL_MS = 200;
const int PROGRESS_INTERVAL_FILES = 100;
const int CHUNK_SIZE = 64 * 1024;  // 64KB per read

const QStringList IMAGE_EXTS = {"jpg", "jpeg", "png", "gif", "webp", "bmp", "svg", "ico", "tiff", "tif", "raw", "heic"};
const QStringList VIDEO_EXTS = {"mp4", "mkv", "avi", "mov", "wmv", "flv", "webm", "m4v", "mpg", "mpeg", "3gp"};
const QStringList DOC_EXTS = {"pdf", "doc", "docx", "xls", "xlsx", "ppt", "pptx", "txt", "md", "odt", "ods", "odp", "rtf", "csv"};
const QStringList ARCHIVE_EXTS = {"zip", "rar", "7z", "tar", "gz", "bz2", "xz", "iso"};

bool matchesFileType(const QString &ext, DuplicateWorker::FileTypeFilter filter)
{
    QString lower = ext.toLower();
    switch (filter) {
    case DuplicateWorker::Images:   return IMAGE_EXTS.contains(lower);
    case DuplicateWorker::Videos:   return VIDEO_EXTS.contains(lower);
    case DuplicateWorker::Documents: return DOC_EXTS.contains(lower);
    case DuplicateWorker::Archives: return ARCHIVE_EXTS.contains(lower);
    case DuplicateWorker::All:
    default: return true;
    }
}

QCryptographicHash::Algorithm toQtAlgo(DuplicateWorker::HashAlgo algo)
{
    switch (algo) {
    case DuplicateWorker::SHA1:   return QCryptographicHash::Sha1;
    case DuplicateWorker::SHA256: return QCryptographicHash::Sha256;
    case DuplicateWorker::MD5:
    default: return QCryptographicHash::Md5;
    }
}

QByteArray computeHash(const QString &path, QCryptographicHash::Algorithm algo)
{
    QFile f(path);
    if (!f.open(QIODevice::ReadOnly))
        return QByteArray();

    QCryptographicHash hash(algo);
    char buf[CHUNK_SIZE];
    while (!f.atEnd()) {
        qint64 n = f.read(buf, sizeof(buf));
        if (n > 0)
            hash.addData(QByteArrayView(buf, static_cast<qsizetype>(n)));
    }
    return hash.result();
}
} // namespace

DuplicateWorker::DuplicateWorker(QObject *parent)
    : QObject(parent)
{
}

void DuplicateWorker::cancel()
{
    m_abort = true;
}

void DuplicateWorker::scan(const QString &path, int hashAlgo, int fileTypeFilter, qint64 minSizeBytes)
{
    m_abort = false;
    QElapsedTimer timer;
    timer.start();

    QString scanPath = path;
    if (scanPath.isEmpty()) scanPath = "/";
    if (scanPath.startsWith("~"))
        scanPath = QStandardPaths::writableLocation(QStandardPaths::HomeLocation) + scanPath.mid(1);

    QDir dir(scanPath);
    if (!dir.exists()) {
        emit finished(QVariantList(), 0, timer.elapsed());
        return;
    }

    // 第一遍：收集文件，按大小分组
    QHash<qint64, QList<QString>> sizeToPaths;
    int fileCount = 0;
    qint64 lastEmitMs = 0;
    int lastEmitFiles = 0;

    std::function<void(const QString &)> collectFiles;
    collectFiles = [&](const QString &currentPath) {
        QDir d(currentPath);
        const auto entries = d.entryList(QDir::Dirs | QDir::Files | QDir::Hidden | QDir::NoDotAndDotDot,
                                        QDir::Name | QDir::DirsFirst);
        for (const QString &name : entries) {
            if (m_abort) return;
            QString fullPath = d.absoluteFilePath(name);
            QFileInfo fi(fullPath);
            if (fi.isSymLink()) continue;
            if (fi.isDir()) {
                collectFiles(fullPath);
            } else {
                qint64 sz = fi.size();
                if (sz < minSizeBytes) continue;
                if (!matchesFileType(fi.suffix(), static_cast<FileTypeFilter>(fileTypeFilter)))
                    continue;
                fileCount++;
                sizeToPaths[sz].append(fullPath);

                qint64 now = timer.elapsed();
                if (now - lastEmitMs >= PROGRESS_INTERVAL_MS || fileCount - lastEmitFiles >= PROGRESS_INTERVAL_FILES) {
                    lastEmitMs = now;
                    lastEmitFiles = fileCount;
                    int candidateGroups = 0;
                    for (const auto &list : sizeToPaths) {
                        if (list.size() >= 2) candidateGroups++;
                    }
                    emit progress(fileCount, candidateGroups, 0, now);
                }
            }
        }
    };
    collectFiles(scanPath);

    // 第二遍：对同大小且数量>=2的组计算哈希，找出重复
    QVariantList duplicateGroups;
    QCryptographicHash::Algorithm algo = toQtAlgo(static_cast<HashAlgo>(hashAlgo));
    int groupsProcessed = 0;

    for (auto it = sizeToPaths.begin(); it != sizeToPaths.end() && !m_abort; ++it) {
        const QList<QString> &paths = it.value();
        if (paths.size() < 2) continue;

        QHash<QByteArray, QList<QVariantMap>> hashToFiles;
        for (const QString &p : paths) {
            if (m_abort) break;
            QByteArray h = computeHash(p, algo);
            if (h.isEmpty()) continue;

            QFileInfo fi(p);
            QVariantMap m;
            m["path"] = p;
            m["name"] = fi.fileName();
            m["size"] = fi.size();
            m["modified"] = fi.lastModified().toString(Qt::ISODate);
            m["extension"] = fi.suffix();
            hashToFiles[h].append(m);
        }

        for (const auto &list : hashToFiles) {
            if (list.size() >= 2) {
                QVariantList fileList;
                for (const QVariantMap &m : list)
                    fileList.append(m);
                QVariantMap group;
                group["hash"] = QString();
                group["files"] = fileList;
                group["count"] = list.size();
                group["size"] = list.first()["size"].toLongLong();
                duplicateGroups.append(group);
            }
        }

        groupsProcessed++;
        qint64 now = timer.elapsed();
        if (now - lastEmitMs >= PROGRESS_INTERVAL_MS) {
            lastEmitMs = now;
            emit progress(fileCount, 0, duplicateGroups.size(), now);
        }
    }

    emit finished(duplicateGroups, fileCount, timer.elapsed());
}
