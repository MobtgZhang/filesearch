#include "ShellTool.h"
#include <QProcess>
#include <QEventLoop>
#include <QTimer>

ShellTool::ShellTool()
{
}

QString ShellTool::name() const
{
    return QStringLiteral("shell");
}

QString ShellTool::description() const
{
    return QStringLiteral("在本地执行 shell 命令，返回标准输出和错误输出");
}

QVariant ShellTool::execute(const QVariantMap &params)
{
    QString command = params.value("command").toString().trimmed();
    if (command.isEmpty())
        return QVariantMap{{"error", "命令不能为空"}};

    int timeoutMs = params.value("timeoutMs", 30000).toInt();
    timeoutMs = qBound(5000, timeoutMs, 120000);  // 5s~120s

    QProcess process;
    process.setProcessChannelMode(QProcess::MergedChannels);
    process.start("/bin/bash", QStringList{"-c", command});

    QEventLoop loop;
    QTimer::singleShot(timeoutMs, &loop, [&process, &loop]() {
        if (process.state() == QProcess::Running) {
            process.kill();
            process.waitForFinished(2000);
        }
        loop.quit();
    });
    QObject::connect(&process, QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished), &loop, &QEventLoop::quit);
    loop.exec();

    QString stdoutStr = QString::fromUtf8(process.readAllStandardOutput());
    QString stderrStr = QString::fromUtf8(process.readAllStandardError());
    int exitCode = process.exitCode();

    return QVariantMap{
        {"exitCode", exitCode},
        {"stdout", stdoutStr.trimmed()},
        {"stderr", stderrStr.trimmed()},
        {"success", exitCode == 0}
    };
}
