#ifndef FILEITEMMODEL_H
#define FILEITEMMODEL_H

#include <QAbstractTableModel>
#include "UnifiedFileRecord.h"

class FileItemModel : public QAbstractTableModel
{
    Q_OBJECT
    Q_PROPERTY(int rowCount READ rowCount NOTIFY rowCountChanged)

public:
    enum Roles {
        NameRole = Qt::UserRole + 1,
        PathRole,
        TypeRole,
        SizeRole,
        DateRole,
        IconRole,
        SelectedRole,
        HighlightedRole
    };

    explicit FileItemModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;
    bool setData(const QModelIndex &index, const QVariant &value, int role = Qt::EditRole) override;

    Q_INVOKABLE void setFiles(const QList<UnifiedFileRecord> &files);
    Q_INVOKABLE void toggleSelection(int row);
    Q_INVOKABLE QList<int> selectedRows() const;

signals:
    void rowCountChanged();

private:
    QString formatSize(qint64 bytes) const;
    QString iconForExtension(const QString &ext) const;

    struct FileRow {
        UnifiedFileRecord record;
        bool selected = false;
        bool highlighted = false;
    };
    QVector<FileRow> m_files;
};

#endif // FILEITEMMODEL_H
