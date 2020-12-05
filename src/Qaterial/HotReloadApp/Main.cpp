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

// ──── INCLUDE ────

// Qaterial
#include <Qaterial/Qaterial.hpp>
#include <Qaterial/HotReload/HotReload.hpp>
#include <SortFilterProxyModel/SortFilterProxyModel.hpp>

// spdlog
#ifdef WIN32
#    include <spdlog/sinks/msvc_sink.h>
#endif
#include <spdlog/sinks/stdout_color_sinks.h>

// Qt
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include <QIcon>

// ──── DECLARATION ────

void qtMsgOutput(QtMsgType type, const QMessageLogContext& context, const QString& msg)
{
    const auto localMsg = msg.toLocal8Bit();
    switch(type)
    {
    case QtDebugMsg: qaterial::Logger::QATERIAL->debug(localMsg.constData()); break;
    case QtInfoMsg: qaterial::Logger::QATERIAL->info(localMsg.constData()); break;
    case QtWarningMsg: qaterial::Logger::QATERIAL->warn(localMsg.constData()); break;
    case QtCriticalMsg: qaterial::Logger::QATERIAL->error(localMsg.constData()); break;
    case QtFatalMsg: qaterial::Logger::QATERIAL->error(localMsg.constData()); abort();
    }

#if defined(Q_OS_WIN)
    //OutputDebugStringW(reinterpret_cast<const wchar_t*>(msg.utf16()));
#elif defined(Q_OS_ANDROID)
    android_default_message_handler(type, context, msg);
#endif
}

void installLoggers()
{
    qInstallMessageHandler(qtMsgOutput);
#ifdef WIN32
    const auto msvcSink = std::make_shared<spdlog::sinks::msvc_sink_mt>();
    qaterial::Logger::registerSink(msvcSink);
#endif
    const auto stdoutSink = std::make_shared<spdlog::sinks::stdout_color_sink_mt>();
    qaterial::Logger::registerSink(stdoutSink);
    qaterial::Logger::registerSink(qaterial::HotReload::sink());
    stdoutSink->set_level(spdlog::level::debug);
    qaterial::HotReload::sink()->set_level(spdlog::level::debug);
    qaterial::Logger::QATERIAL->set_level(spdlog::level::debug);
}

// ──── FUNCTIONS ────

int main(int argc, char* argv[])
{
#if defined(QATERIALHOTRELOAD_IGNORE_ENV)
    const QString executable = argv[0];
#    if defined(Q_OS_WINDOWS)
    const auto executablePath = executable.mid(0, executable.lastIndexOf("\\"));
    QCoreApplication::setLibraryPaths({executablePath});
#    endif
#endif
    installLoggers();

    QApplication app(argc, argv);
    QQmlApplicationEngine engine;

    // ──── REGISTER APPLICATION ────

    QGuiApplication::setOrganizationName("Qaterial");
    QGuiApplication::setApplicationName("Qaterial Hot Reload");
    QGuiApplication::setOrganizationDomain("https://olivierldff.github.io/Qaterial/");
    QGuiApplication::setApplicationVersion(qaterial::Version::version().readable());
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
