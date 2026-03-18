#include "WebSearchTool.h"
#include "AppSettings.h"
#include <QUrl>
#include <QRegularExpression>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QNetworkProxy>
#include <QEventLoop>
#include <QTimer>

WebSearchTool::WebSearchTool(AppSettings *settings)
    : m_settings(settings)
{
}

QString WebSearchTool::name() const
{
    return QStringLiteral("web_search");
}

QString WebSearchTool::description() const
{
    return QStringLiteral("在网页上搜索信息，支持 Bing、百度等搜索引擎");
}

QString WebSearchTool::buildSearchUrl(const QString &query, const QString &engine) const
{
    QString enc = QString::fromUtf8(QUrl::toPercentEncoding(query));
    QString eng = engine.toLower();
    if (eng == "baidu")
        return QString("https://www.baidu.com/s?wd=%1").arg(enc);
    if (eng == "duckduckgo")
        return QString("https://html.duckduckgo.com/html/?q=%1").arg(enc);
    return QString("https://www.bing.com/search?q=%1").arg(enc);
}

QVariant WebSearchTool::execute(const QVariantMap &params)
{
    QString query = params.value("query").toString().trimmed();
    if (query.isEmpty())
        return QVariantMap{{"error", "搜索关键词不能为空"}};

    QString engine = params.value("engine").toString();
    if (engine.isEmpty() && m_settings)
        engine = m_settings->webSearchEngine();

    if (engine.isEmpty())
        engine = "bing";

    QString searchUrl = buildSearchUrl(query, engine);

    QNetworkRequest request;
    request.setUrl(QUrl(searchUrl));
    request.setRawHeader("User-Agent",
        "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36");

    QNetworkAccessManager nam;
    if (m_settings) {
        if (m_settings->proxyMode() == "manual" && !m_settings->proxyUrl().isEmpty()) {
            QUrl proxyUrl(m_settings->proxyUrl());
            if (!proxyUrl.scheme().isEmpty())
                nam.setProxy(QNetworkProxy(QNetworkProxy::HttpProxy, proxyUrl.host(),
                    proxyUrl.port(8080), proxyUrl.userName(), proxyUrl.password()));
            else {
                QString manual = m_settings->proxyUrl().trimmed();
                int colon = manual.indexOf(':');
                QString host = colon > 0 ? manual.left(colon) : manual;
                int port = colon > 0 ? manual.mid(colon + 1).toInt() : 8080;
                nam.setProxy(QNetworkProxy(QNetworkProxy::HttpProxy, host, port));
            }
        } else {
            nam.setProxy(QNetworkProxy::applicationProxy());
        }
    }
    QNetworkReply *reply = nam.get(request);

    QEventLoop loop;
    QObject::connect(reply, &QNetworkReply::finished, &loop, &QEventLoop::quit);
    QTimer::singleShot(15000, &loop, [&loop, reply]() {
        reply->abort();
        loop.quit();
    });
    loop.exec();

    QVariantMap result;
    result["query"] = query;
    result["engine"] = engine;
    result["searchUrl"] = searchUrl;

    if (reply->error() != QNetworkReply::NoError) {
        result["error"] = reply->errorString();
        result["snippets"] = QVariantList();
        result["message"] = QString("搜索完成，请访问: %1").arg(searchUrl);
        reply->deleteLater();
        return result;
    }

    QString html = QString::fromUtf8(reply->readAll());
    reply->deleteLater();

    QVariantList snippets;
    QRegularExpression bingRe("<li class=\"b_algo\"[^>]*>.*?<h2[^>]*>.*?<a[^>]*href=\"([^\"]+)\"[^>]*>([^<]+)</a>",
        QRegularExpression::DotMatchesEverythingOption);
    auto bingIt = bingRe.globalMatch(html);
    int count = 0;
    while (bingIt.hasNext() && count < 5) {
        auto m = bingIt.next();
        QVariantMap item;
        item["url"] = m.captured(1);
        item["title"] = m.captured(2).replace(QRegularExpression("<[^>]+>"), "").trimmed();
        item["snippet"] = "";
        if (!item["title"].toString().isEmpty()) {
            snippets.append(item);
            count++;
        }
    }

    if (snippets.isEmpty())
        result["message"] = QString("搜索完成，请访问: %1").arg(searchUrl);

    result["snippets"] = snippets;
    result["count"] = snippets.size();
    return result;
}
