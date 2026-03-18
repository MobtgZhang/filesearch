#include "AppSettings.h"
#include <QStandardPaths>
#include <QDir>

AppSettings::AppSettings(QObject *parent)
    : QObject(parent)
    , m_settings("NexFile", "FileSearch")
{
    m_themeMode = m_settings.value("themeMode", "dark").toString();
    m_language = m_settings.value("language", "zh").toString();
    m_cacheDir = m_settings.value("cacheDir",
        QDir::homePath() + "/.cache/FileSearch").toString();
    m_apiBaseUrl = m_settings.value("apiBaseUrl", "https://api.openai.com/v1").toString();
    m_apiModel = m_settings.value("apiModel", "gpt-4o-mini").toString();
    m_apiModelList = m_settings.value("apiModelList",
        QStringList{"gpt-4o", "gpt-4o-mini", "gpt-4-turbo", "gpt-3.5-turbo"}).toStringList();
    m_modelTemperature = m_settings.value("modelTemperature", 0.7).toDouble();
    m_topK = m_settings.value("topK", 40).toInt();
    m_topP = m_settings.value("topP", 0.9).toDouble();
    if (m_settings.contains("maxTokens"))
        m_maxTokens = m_settings.value("maxTokens", 4096).toInt();
    else if (m_settings.contains("maxTokensMax"))
        m_maxTokens = m_settings.value("maxTokensMax", 4096).toInt();
    else
        m_maxTokens = 4096;
    m_systemPrompt = m_settings.value("systemPrompt",
        "你是 NexFile 的 AI 助手，帮助用户管理文件。").toString();
    m_webSearchEngine = m_settings.value("webSearchEngine", "bing").toString();
    m_proxyMode = m_settings.value("proxyMode", "auto").toString();
    m_proxyUrl = m_settings.value("proxyUrl", "").toString();
}

void AppSettings::setThemeMode(const QString &mode)
{
    if (m_themeMode != mode) {
        m_themeMode = mode;
        m_settings.setValue("themeMode", mode);
        emit themeModeChanged();
    }
}

void AppSettings::setLanguage(const QString &lang)
{
    if (m_language != lang) {
        m_language = lang;
        m_settings.setValue("language", lang);
        emit languageChanged();
    }
}

void AppSettings::setCacheDir(const QString &dir)
{
    if (m_cacheDir != dir) {
        m_cacheDir = dir;
        m_settings.setValue("cacheDir", dir);
        emit cacheDirChanged();
    }
}

void AppSettings::setApiBaseUrl(const QString &url)
{
    if (m_apiBaseUrl != url) {
        m_apiBaseUrl = url;
        m_settings.setValue("apiBaseUrl", url);
        emit apiBaseUrlChanged();
    }
}

void AppSettings::setApiModel(const QString &model)
{
    if (m_apiModel != model) {
        m_apiModel = model;
        m_settings.setValue("apiModel", model);
        emit apiModelChanged();
    }
}

void AppSettings::setApiModelList(const QStringList &list)
{
    if (m_apiModelList != list) {
        m_apiModelList = list;
        m_settings.setValue("apiModelList", list);
        emit apiModelListChanged();
    }
}

void AppSettings::refreshApiModelList()
{
    // TODO: 调用 API 获取模型列表，暂时使用默认列表
    setApiModelList(QStringList{"gpt-4o", "gpt-4o-mini", "gpt-4-turbo", "gpt-3.5-turbo"});
}

void AppSettings::setModelTemperature(double v)
{
    v = qBound(0.0, v, 1.0);
    if (!qFuzzyCompare(m_modelTemperature, v)) {
        m_modelTemperature = v;
        m_settings.setValue("modelTemperature", v);
        emit modelTemperatureChanged();
    }
}

void AppSettings::setTopK(int v)
{
    v = qBound(1, v, 100);
    if (m_topK != v) {
        m_topK = v;
        m_settings.setValue("topK", v);
        emit topKChanged();
    }
}

void AppSettings::setTopP(double v)
{
    v = qBound(0.0, v, 1.0);
    if (!qFuzzyCompare(m_topP, v)) {
        m_topP = v;
        m_settings.setValue("topP", v);
        emit topPChanged();
    }
}

void AppSettings::setMaxTokens(int v)
{
    v = qBound(64, v, 128000);
    if (m_maxTokens != v) {
        m_maxTokens = v;
        m_settings.setValue("maxTokens", v);
        emit maxTokensChanged();
    }
}

void AppSettings::setSystemPrompt(const QString &prompt)
{
    if (m_systemPrompt != prompt) {
        m_systemPrompt = prompt;
        m_settings.setValue("systemPrompt", prompt);
        emit systemPromptChanged();
    }
}

void AppSettings::setWebSearchEngine(const QString &engine)
{
    if (m_webSearchEngine != engine) {
        m_webSearchEngine = engine;
        m_settings.setValue("webSearchEngine", engine);
        emit webSearchEngineChanged();
    }
}

void AppSettings::setProxyMode(const QString &mode)
{
    if (m_proxyMode != mode) {
        m_proxyMode = mode;
        m_settings.setValue("proxyMode", mode);
        emit proxyModeChanged();
    }
}

void AppSettings::setProxyUrl(const QString &url)
{
    if (m_proxyUrl != url) {
        m_proxyUrl = url;
        m_settings.setValue("proxyUrl", url);
        emit proxyUrlChanged();
    }
}
