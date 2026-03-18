#include "FileItemModel.h"

FileItemModel::FileItemModel(QObject *parent)
    : QAbstractTableModel(parent)
{
}

int FileItemModel::rowCount(const QModelIndex &parent) const
{
    return parent.isValid() ? 0 : m_files.size();
}

int FileItemModel::columnCount(const QModelIndex &parent) const
{
    return parent.isValid() ? 0 : 5;
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
    case TypeRole: return r.extension.toUpper();
    case SizeRole: return formatSize(r.size);
    case DateRole: return r.modified.toString("yyyy-MM-dd");
    case IconRole: return iconForExtension(r.extension);
    case SelectedRole: return row.selected;
    case HighlightedRole: return row.highlighted;
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
        {HighlightedRole, "highlighted"}
    };
}

bool FileItemModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (!index.isValid() || index.row() >= m_files.size())
        return false;

    if (role == SelectedRole) {
        m_files[index.row()].selected = value.toBool();
        emit dataChanged(index, index, {SelectedRole});
        return true;
    }
    return false;
}

void FileItemModel::setFiles(const QList<UnifiedFileRecord> &files)
{
    beginResetModel();
    m_files.clear();
    for (const auto &f : files) {
        m_files.append({f, false, false});
    }
    endResetModel();
    emit rowCountChanged();
}

void FileItemModel::toggleSelection(int row)
{
    if (row >= 0 && row < m_files.size()) {
        m_files[row].selected = !m_files[row].selected;
        QModelIndex idx = index(row, 0);
        emit dataChanged(idx, idx, {SelectedRole});
    }
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
