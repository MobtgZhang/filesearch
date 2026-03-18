#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDir>
#include <QTimer>
#include <QUrl>
#include <QtWebEngineQuick>
#include <QtConcurrent>
#include <QFutureWatcher>

#include "AppSettings.h"
#include "PathProvider.h"
#include "StatusContext.h"
#include "model/FileItemModel.h"
#include "model/UnifiedFileRecord.h"
#include "engine/SearchEngine.h"
#include "engine/ScanEngine.h"
#include "engine/DuplicateEngine.h"
#include "engine/CleanupEngine.h"
#include "service/FileOperationService.h"
#include "agent/ChatBridge.h"
#include "agent/ToolExecutor.h"

int main(int argc, char *argv[])
{
    QtWebEngineQuick::initialize();
    QGuiApplication app(argc, argv);

    AppSettings appSettings;
    PathProvider pathProvider;
    StatusContext statusContext;
    FileItemModel fileModel;
    SearchEngine searchEngine;
    ScanEngine scanEngine;
    DuplicateEngine duplicateEngine;
    CleanupEngine cleanupEngine;
    FileOperationService fileOperationService;
    ChatBridge chatBridge;
    ToolExecutor toolExecutor;

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("appSettings", &appSettings);
    engine.rootContext()->setContextProperty("pathProvider", &pathProvider);
    engine.rootContext()->setContextProperty("statusContext", &statusContext);
    engine.rootContext()->setContextProperty("fileModel", &fileModel);
    engine.rootContext()->setContextProperty("searchEngine", &searchEngine);
    engine.rootContext()->setContextProperty("scanEngine", &scanEngine);
    engine.rootContext()->setContextProperty("duplicateEngine", &duplicateEngine);
    engine.rootContext()->setContextProperty("cleanupEngine", &cleanupEngine);
    engine.rootContext()->setContextProperty("fileOperationService", &fileOperationService);
    engine.rootContext()->setContextProperty("chatBridge", &chatBridge);
    engine.rootContext()->setContextProperty("toolExecutor", &toolExecutor);

    toolExecutor.setSearchEngine(&searchEngine);
    toolExecutor.setFileOperationService(&fileOperationService);
    toolExecutor.setAppSettings(&appSettings);

    QObject::connect(&searchEngine, &SearchEngine::resultsReady, &fileModel, [&fileModel](const QList<UnifiedFileRecord> &files) {
        fileModel.setFiles(files);
    });
    QObject::connect(&searchEngine, &SearchEngine::searchStats, &statusContext, [&statusContext](int count, qint64 totalSize, qint64 ms) {
        statusContext.setFoundFileCount(count);
        statusContext.setFoundTotalSize(totalSize);
        statusContext.setOperationTimeMs(static_cast<int>(ms));
    });

    // 限制文件列表大小，避免扫描完成后 setBaseFiles+query 阻塞主线程导致点击卡顿
    QObject::connect(&scanEngine, &ScanEngine::segmentsReady, &app, [&app, &searchEngine, &fileModel](const QVariantMap &result) {
        QVariantList list = result["fileList"].toList();
        if (list.isEmpty()) {
            QTimer::singleShot(0, &app, [&searchEngine]() {
                searchEngine.setBaseFiles(QList<UnifiedFileRecord>());
                searchEngine.query("");
            });
            return;
        }
        const int cap = qMin(list.size(), 15000);
        auto convert = [list, cap]() -> QList<UnifiedFileRecord> {
            QList<UnifiedFileRecord> records;
            records.reserve(cap);
            for (int i = 0; i < cap; i++) {
                QVariantMap m = list[i].toMap();
                UnifiedFileRecord r;
                r.path = m["path"].toString();
                r.name = m["name"].toString();
                r.size = m["size"].toLongLong();
                r.modified = QDateTime::fromString(m["modified"].toString(), Qt::ISODate);
                r.extension = m["extension"].toString();
                r.isDirectory = m["isDirectory"].toBool();
                records.append(r);
            }
            return records;
        };
        auto *watcher = new QFutureWatcher<QList<UnifiedFileRecord>>(&app);
        QObject::connect(watcher, &QFutureWatcher<QList<UnifiedFileRecord>>::finished, &app, [watcher, &searchEngine]() {
            QList<UnifiedFileRecord> records = watcher->result();
            watcher->deleteLater();
            // 延迟到下一事件循环，避免阻塞主线程导致点击无响应
            QTimer::singleShot(0, qApp, [records, &searchEngine]() {
                searchEngine.setBaseFiles(records);
                searchEngine.query("");
            });
        });
        watcher->setFuture(QtConcurrent::run(convert));
    });

    // 添加 QML 导入路径
    QDir appDir(QCoreApplication::applicationDirPath());
    QStringList searchDirs;
    searchDirs << appDir.absolutePath()
               << appDir.absoluteFilePath("..")
               << appDir.absoluteFilePath("../..")
               << appDir.absoluteFilePath("../src")
               << QDir::currentPath();

    QString qmlBasePath;
    for (const QString &dir : searchDirs) {
        QDir d(dir);
        if (d.exists("qml")) {
            qmlBasePath = d.absoluteFilePath("qml");
            break;
        }
    }

    if (!qmlBasePath.isEmpty()) {
        // 从文件系统加载（开发模式）
        engine.addImportPath(qmlBasePath);
    } else {
        engine.addImportPath("qrc:/");
    }

    // 供 AI 聊天面板加载 HTML 的路径
    QString aiChatHtmlPath = qmlBasePath.isEmpty()
        ? QString()
        : QDir(qmlBasePath).absoluteFilePath("ai-chat/index.html");
    engine.rootContext()->setContextProperty("aiChatHtmlPath", aiChatHtmlPath);

    // 加载 main.qml
    QUrl url;
    if (!qmlBasePath.isEmpty()) {
        url = QUrl::fromLocalFile(QDir(qmlBasePath).absoluteFilePath("main.qml"));
    } else {
        url = QUrl("qrc:/qml/main.qml");
    }

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.load(url);

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
