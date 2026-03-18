#include "FileItemModel.h"
#include <algorithm>

FileItemModel::FileItemModel(QObject *parent)
    : QAbstractListModel(parent)
{
}

int FileItemModel::rowCount(const QModelIndex &parent) const
{
    return parent.isValid() ? 0 : m_files.size();
}

QVariant FileItemModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_files.size())
        return QVariant();

    const FileRow &row = m_files.at(index.row());
    const UnifiedFileRecord &r = row.record;

    switch (role) {
    case NameRole: return r.name;
    case PathRole: return r.path;
    case TypeRole: return r.isDirectory ? QString("文件夹") : r.extension.toUpper();
    case SizeRole: return r.isDirectory ? formatSize(r.size) : formatSize(r.size);
    case DateRole: return r.modified.toString("yyyy-MM-dd");
    case IconRole: return r.isDirectory ? QString("📁") : iconForExtension(r.extension);
    case SelectedRole: return row.selected;
    case HighlightedRole: return row.highlighted;
    case IsDirectoryRole: return r.isDirectory;
    default: return QVariant();
    }
}

QHash<int, QByteArray> FileItemModel::roleNames() const
{
    return {
        {NameRole, "name"},
        {PathRole, "path"},
        {TypeRole, "type"},
        {SizeRole, "size"},
        {DateRole, "date"},
        {IconRole, "icon"},
        {SelectedRole, "selected"},
        {HighlightedRole, "highlighted"},
        {IsDirectoryRole, "isDirectory"}
    };
}

bool FileItemModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (!index.isValid() || index.row() >= m_files.size())
        return false;

    if (role == SelectedRole) {
        m_files[index.row()].selected = value.toBool();
        emit dataChanged(index, index, {SelectedRole});
        emit selectionChanged();
        return true;
    }
    return false;
}

void FileItemModel::setFiles(const QList<UnifiedFileRecord> &files)
{
    beginResetModel();
    m_files.clear();
    m_files.reserve(files.size());
    m_selectionAnchor = -1;
    for (const auto &f : files) {
        m_files.append({f, false, false});
    }
    endResetModel();
    emit rowCountChanged();
}

void FileItemModel::selectSingle(int row)
{
    if (row < 0 || row >= m_files.size()) return;
    for (int i = 0; i < m_files.size(); ++i)
        m_files[i].selected = (i == row);
    m_selectionAnchor = row;
    emit dataChanged(index(0), index(m_files.size() - 1), {SelectedRole});
    emit selectionChanged();
}

void FileItemModel::selectRange(int fromRow, int toRow)
{
    if (m_files.isEmpty()) return;
    int lo = std::min(fromRow, toRow);
    int hi = std::max(fromRow, toRow);
    int last = static_cast<int>(m_files.size()) - 1;
    lo = std::max(0, std::min(lo, last));
    hi = std::max(0, std::min(hi, last));
    for (int i = lo; i <= hi; ++i)
        m_files[i].selected = true;
    emit dataChanged(index(lo), index(hi), {SelectedRole});
    emit selectionChanged();
}

void FileItemModel::setSelectionAnchor(int row)
{
    m_selectionAnchor = (row >= 0 && row < m_files.size()) ? row : -1;
}

int FileItemModel::selectionAnchor() const
{
    return m_selectionAnchor;
}

void FileItemModel::toggleSelection(int row)
{
    if (row >= 0 && row < m_files.size()) {
        m_files[row].selected = !m_files[row].selected;
        QModelIndex idx = index(row);
        emit dataChanged(idx, idx, {SelectedRole});
        emit selectionChanged();
    }
}

int FileItemModel::selectedCount() const
{
    int n = 0;
    for (const auto &row : m_files)
        if (row.selected) ++n;
    return n;
}

qint64 FileItemModel::selectedSize() const
{
    qint64 total = 0;
    for (int i = 0; i < m_files.size(); ++i) {
        if (m_files[i].selected)
            total += m_files[i].record.size;
    }
    return total;
}

void FileItemModel::selectAll()
{
    if (m_files.isEmpty()) return;
    for (int i = 0; i < m_files.size(); ++i)
        m_files[i].selected = true;
    emit dataChanged(index(0), index(m_files.size() - 1), {SelectedRole});
    emit selectionChanged();
}

void FileItemModel::selectNone()
{
    if (m_files.isEmpty()) return;
    for (int i = 0; i < m_files.size(); ++i)
        m_files[i].selected = false;
    emit dataChanged(index(0), index(m_files.size() - 1), {SelectedRole});
    emit selectionChanged();
}

void FileItemModel::invertSelection()
{
    if (m_files.isEmpty()) return;
    for (int i = 0; i < m_files.size(); ++i)
        m_files[i].selected = !m_files[i].selected;
    emit dataChanged(index(0), index(m_files.size() - 1), {SelectedRole});
    emit selectionChanged();
}

QList<int> FileItemModel::selectedRows() const
{
    QList<int> result;
    for (int i = 0; i < m_files.size(); ++i) {
        if (m_files[i].selected)
            result.append(i);
    }
    return result;
}

QString FileItemModel::formatSize(qint64 bytes) const
{
    const qint64 KB = 1024, MB = KB * 1024, GB = MB * 1024;
    if (bytes >= GB) return QString::number(bytes / double(GB), 'f', 1) + " GB";
    if (bytes >= MB) return QString::number(bytes / double(MB), 'f', 1) + " MB";
    if (bytes >= KB) return QString::number(bytes / double(KB), 'f', 1) + " KB";
    return QString::number(bytes) + " B";
}

QString FileItemModel::iconForExtension(const QString &ext) const
{
    QString e = ext.toLower();
    if (e == "mkv" || e == "mp4" || e == "avi") return "🎬";
    if (e == "iso" || e == "vmdk") return "📦";
    if (e == "tar" || e == "gz" || e == "zip") return "🗜";
    if (e == "mov") return "🎬";
    return "📄";
}
