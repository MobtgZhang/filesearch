#ifndef FILEITEMMODEL_H
#define FILEITEMMODEL_H

#include <QAbstractListModel>
#include "UnifiedFileRecord.h"

class FileItemModel : public QAbstractListModel
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
        HighlightedRole,
        IsDirectoryRole
    };

    explicit FileItemModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;
    bool setData(const QModelIndex &index, const QVariant &value, int role = Qt::EditRole) override;

    Q_INVOKABLE void setFiles(const QList<UnifiedFileRecord> &files);
    Q_INVOKABLE void toggleSelection(int row);
    Q_INVOKABLE QList<int> selectedRows() const;
    Q_INVOKABLE int selectedCount() const;
    Q_INVOKABLE qint64 selectedSize() const;
    Q_INVOKABLE QString formatSize(qint64 bytes) const;
    Q_INVOKABLE void selectAll();
    Q_INVOKABLE void selectNone();
    Q_INVOKABLE void invertSelection();
    Q_INVOKABLE void selectSingle(int row);
    Q_INVOKABLE void selectRange(int fromRow, int toRow);
    Q_INVOKABLE void setSelectionAnchor(int row);
    Q_INVOKABLE int selectionAnchor() const;

signals:
    void rowCountChanged();
    void selectionChanged();

private:
    QString iconForExtension(const QString &ext) const;

    struct FileRow {
        UnifiedFileRecord record;
        bool selected = false;
        bool highlighted = false;
    };
    QVector<FileRow> m_files;
    int m_selectionAnchor = -1;
};

#endif // FILEITEMMODEL_H
