#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDir>
#include <QUrl>
#include <QtWebEngineQuick>

#include "AppSettings.h"
#include "model/FileItemModel.h"
#include "model/UnifiedFileRecord.h"
#include "engine/SearchEngine.h"

int main(int argc, char *argv[])
{
    QtWebEngineQuick::initialize();
    QGuiApplication app(argc, argv);

    AppSettings appSettings;
    FileItemModel fileModel;
    SearchEngine searchEngine;

    // 填充演示数据
    QList<UnifiedFileRecord> demoFiles;
    auto addDemo = [&](const QString &name, const QString &path, const QString &ext, qint64 size, const QString &date) {
        UnifiedFileRecord r;
        r.name = name;
        r.path = path;
        r.extension = ext;
        r.size = size;
        r.modified = QDateTime::fromString(date, "yyyy-MM-dd");
        r.isDirectory = false;
        demoFiles.append(r);
    };
    addDemo("Interstellar.4K.mkv", "~/Movies/Sci-Fi/", "mkv", 45400000000ULL, "2024-11-03");
    addDemo("Dune.Part2.2160p.mkv", "~/Movies/2024/", "mkv", 41500000000ULL, "2024-12-15");
    addDemo("Ubuntu-24.04-desktop.iso", "~/Downloads/", "iso", 6550000000ULL, "2024-09-22");
    addDemo("Avatar.WoW.Extended.mkv", "~/Movies/Sci-Fi/", "mkv", 6200000000ULL, "2025-01-08");
    addDemo("project-backup-2023.tar.gz", "~/Backups/annual/", "tar.gz", 4500000000ULL, "2023-12-31");
    addDemo("GoPro_footage_raw.mp4", "~/Videos/Travel/2024/", "mp4", 4200000000ULL, "2024-08-14");
    addDemo("wedding-raw-edit-v3.mov", "~/Videos/Events/", "mov", 3650000000ULL, "2024-06-20");
    addDemo("vm-windows11.vmdk", "~/VirtualMachines/", "vmdk", 2900000000ULL, "2024-03-05");
    fileModel.setFiles(demoFiles);

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("appSettings", &appSettings);
    engine.rootContext()->setContextProperty("fileModel", &fileModel);
    engine.rootContext()->setContextProperty("searchEngine", &searchEngine);

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
