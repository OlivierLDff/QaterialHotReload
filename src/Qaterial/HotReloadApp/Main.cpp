// MIT License
//
// Copyright (c) 2020 Olivier Le Doeuff
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#include <Qaterial/Qaterial.hpp>
#include <Qaterial/HotReload/HotReload.hpp>
#include <SortFilterProxyModel/SortFilterProxyModel.hpp>

#include <QtGui/QIcon>
#include <QtQml/QQmlApplicationEngine>
#include <QtQml/QtQml>
#include <QtWidgets/QApplication>

#ifdef Q_OS_WIN
#    include <Windows.h>
#endif

void qtMsgOutput(QtMsgType type, const QMessageLogContext& context, const QString& msg)
{
    const auto timestamp = QDateTime::currentDateTime().toString("hh:mm:ss.zzz");
    const auto category = [type]() -> QString
    {
        switch(type)
        {
        case QtDebugMsg: return "debug";
        case QtWarningMsg: return "warning";
        case QtCriticalMsg: return "error";
        case QtFatalMsg: return "error";
        case QtInfoMsg: return "info";
        default: return "unknown";
        }
    }();

    const auto log = "[" + timestamp + "] [" + context.category + "] [" + category + "] : " + msg;
    qaterial::HotReload::log(type, context, log);
#if defined(Q_OS_WIN)
    const auto winLog = log + "\n";
    OutputDebugStringW(reinterpret_cast<const wchar_t*>(winLog.utf16()));
#elif defined(Q_OS_ANDROID)
    android_default_message_handler(type, context, msg);
#endif
}

int main(int argc, char* argv[])
{
#if defined(QATERIALHOTRELOAD_IGNORE_ENV)
    const QString executable = argv[0];
#    if defined(Q_OS_WINDOWS)
    const auto executablePath = executable.mid(0, executable.lastIndexOf("\\"));
    QCoreApplication::setLibraryPaths({executablePath});
#    endif
#endif
    qInstallMessageHandler(qtMsgOutput);

    QApplication app(argc, argv);
    QQmlApplicationEngine engine;

    // ──── REGISTER APPLICATION ────

    QGuiApplication::setOrganizationName("Qaterial");
    QGuiApplication::setApplicationName("Qaterial Hot Reload");
    QGuiApplication::setOrganizationDomain("https://olivierldff.github.io/Qaterial/");
    const QString version = QString::number(qaterial::versionMajor()) + QStringLiteral(".") + QString::number(qaterial::versionMinor()) +
                            QStringLiteral(".") + QString::number(qaterial::versionPatch()) + QStringLiteral(".0x") +
                            QString::number(qaterial::versionTag(), 16).rightJustified(8, QChar('0'));
    QGuiApplication::setApplicationVersion(version);
    QGuiApplication::setWindowIcon(QIcon(":/Qaterial/HotReload/Images/icon.svg"));

    QCommandLineParser parser;
    QCommandLineOption resetimport(QStringList({"reset-imports"}), QCoreApplication::translate("main", "Force reset of imports"));
    parser.addOption(resetimport);
    parser.process(app);

    // ──── LOAD AND REGISTER QML ────

#if defined(QATERIALHOTRELOAD_IGNORE_ENV)
    engine.setImportPathList({QLibraryInfo::location(QLibraryInfo::Qml2ImportsPath), "qrc:/", "qrc:/qt-project.org/imports"});
#else
    engine.addImportPath("qrc:/");
#endif

    // Load Qaterial
    qaterial::loadQmlResources();
    qaterial::registerQmlTypes();
    qaterial::HotReload::registerSingleton();
    if(parser.isSet(resetimport))
        qaterial::HotReload::resetImportPath();
    qqsfpm::registerQmlTypes();

    // ──── LOAD QML MAIN ────

    engine.load(QUrl("qrc:/Qaterial/HotReload/Main.qml"));
    if(engine.rootObjects().isEmpty())
        return -1;

    // ──── START EVENT LOOP ────

    return QGuiApplication::exec();
}
