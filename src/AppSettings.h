#ifndef APPSETTINGS_H
#define APPSETTINGS_H

#include <QObject>
#include <QSettings>

class AppSettings : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString themeMode READ themeMode WRITE setThemeMode NOTIFY themeModeChanged)

public:
    explicit AppSettings(QObject *parent = nullptr);
    QString themeMode() const { return m_themeMode; }
    void setThemeMode(const QString &mode);

signals:
    void themeModeChanged();

private:
    QString m_themeMode;
    QSettings m_settings;
};

#endif // APPSETTINGS_H
