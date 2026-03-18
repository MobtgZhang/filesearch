#include "AppSettings.h"

AppSettings::AppSettings(QObject *parent)
    : QObject(parent)
    , m_settings("NexFile", "FileSearch")
{
    m_themeMode = m_settings.value("themeMode", "dark").toString();
}

void AppSettings::setThemeMode(const QString &mode)
{
    if (m_themeMode != mode) {
        m_themeMode = mode;
        m_settings.setValue("themeMode", mode);
        emit themeModeChanged();
    }
}
