#ifndef APPSETTINGS_H
#define APPSETTINGS_H

#include <QObject>
#include <QSettings>

class AppSettings : public QObject
{
    Q_OBJECT

    // 系统设置
    Q_PROPERTY(QString themeMode READ themeMode WRITE setThemeMode NOTIFY themeModeChanged)
    Q_PROPERTY(QString language READ language WRITE setLanguage NOTIFY languageChanged)
    Q_PROPERTY(QString cacheDir READ cacheDir WRITE setCacheDir NOTIFY cacheDirChanged)

    // Agent 设置
    Q_PROPERTY(QString apiBaseUrl READ apiBaseUrl WRITE setApiBaseUrl NOTIFY apiBaseUrlChanged)
    Q_PROPERTY(QString apiModel READ apiModel WRITE setApiModel NOTIFY apiModelChanged)
    Q_PROPERTY(QStringList apiModelList READ apiModelList NOTIFY apiModelListChanged)
    Q_PROPERTY(double modelTemperature READ modelTemperature WRITE setModelTemperature NOTIFY modelTemperatureChanged)
    Q_PROPERTY(int topK READ topK WRITE setTopK NOTIFY topKChanged)
    Q_PROPERTY(double topP READ topP WRITE setTopP NOTIFY topPChanged)
    Q_PROPERTY(int maxTokens READ maxTokens WRITE setMaxTokens NOTIFY maxTokensChanged)
    Q_PROPERTY(QString systemPrompt READ systemPrompt WRITE setSystemPrompt NOTIFY systemPromptChanged)
    Q_PROPERTY(QString webSearchEngine READ webSearchEngine WRITE setWebSearchEngine NOTIFY webSearchEngineChanged)
    Q_PROPERTY(QString proxyMode READ proxyMode WRITE setProxyMode NOTIFY proxyModeChanged)
    Q_PROPERTY(QString proxyUrl READ proxyUrl WRITE setProxyUrl NOTIFY proxyUrlChanged)

public:
    explicit AppSettings(QObject *parent = nullptr);

    // 系统设置
    QString themeMode() const { return m_themeMode; }
    void setThemeMode(const QString &mode);
    QString language() const { return m_language; }
    void setLanguage(const QString &lang);
    QString cacheDir() const { return m_cacheDir; }
    void setCacheDir(const QString &dir);

    // Agent 设置
    QString apiBaseUrl() const { return m_apiBaseUrl; }
    void setApiBaseUrl(const QString &url);
    QString apiModel() const { return m_apiModel; }
    void setApiModel(const QString &model);
    QStringList apiModelList() const { return m_apiModelList; }
    void setApiModelList(const QStringList &list);
    Q_INVOKABLE void refreshApiModelList();
    double modelTemperature() const { return m_modelTemperature; }
    void setModelTemperature(double v);
    int topK() const { return m_topK; }
    void setTopK(int v);
    double topP() const { return m_topP; }
    void setTopP(double v);
    int maxTokens() const { return m_maxTokens; }
    void setMaxTokens(int v);
    QString systemPrompt() const { return m_systemPrompt; }
    void setSystemPrompt(const QString &prompt);
    QString webSearchEngine() const { return m_webSearchEngine; }
    void setWebSearchEngine(const QString &engine);
    QString proxyMode() const { return m_proxyMode; }
    void setProxyMode(const QString &mode);
    QString proxyUrl() const { return m_proxyUrl; }
    void setProxyUrl(const QString &url);

signals:
    void themeModeChanged();
    void languageChanged();
    void cacheDirChanged();
    void apiBaseUrlChanged();
    void apiModelChanged();
    void apiModelListChanged();
    void modelTemperatureChanged();
    void topKChanged();
    void topPChanged();
    void maxTokensChanged();
    void systemPromptChanged();
    void webSearchEngineChanged();
    void proxyModeChanged();
    void proxyUrlChanged();

private:
    QString m_themeMode;
    QString m_language;
    QString m_cacheDir;
    QString m_apiBaseUrl;
    QString m_apiModel;
    QStringList m_apiModelList;
    double m_modelTemperature;
    int m_topK;
    double m_topP;
    int m_maxTokens;
    QString m_systemPrompt;
    QString m_webSearchEngine;
    QString m_proxyMode;
    QString m_proxyUrl;
    QSettings m_settings;
};

#endif // APPSETTINGS_H
