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

#include <Qaterial/HotReload/HotReload.hpp>
#include <unordered_set>

static void HotReload_loadResources() { Q_INIT_RESOURCE(QaterialHotReload); }

namespace qaterial {

bool HotReload::_resetImportPath = false;
static std::unordered_set<HotReload*> hotReloaders;

HotReload::HotReload(QQmlEngine* engine, QObject* parent) : QObject(parent), _engine(engine)
{
    connect(&_watcher, &QFileSystemWatcher::fileChanged, this, &HotReload::watchedFileChanged);
    HotReload_loadResources();
    hotReloaders.insert(this);
}

HotReload::~HotReload() { hotReloaders.erase(this); }

void HotReload::clearCache() const { _engine->clearComponentCache(); }

void HotReload::registerSingleton()
{
    qmlRegisterSingletonType<qaterial::HotReload>("Qaterial",
        1,
        0,
        "HotReload",
        [](QQmlEngine* engine, QJSEngine* scriptEngine) -> QObject*
        {
            Q_UNUSED(scriptEngine);
            auto* instance = new qaterial::HotReload(engine, engine);
            instance->_defaultImportPaths = engine->importPathList();
            return instance;
        });
}

void HotReload::resetImportPath() { _resetImportPath = true; }

void HotReload::log(QtMsgType type, const QMessageLogContext& context, const QString& msg)
{
    // todo : better log ui
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

    for(auto* hr: hotReloaders) { Q_EMIT hr->newLog(log); }
}

void HotReload::watchFile(const QString& path) { _watcher.addPath(path); }

void HotReload::unWatchFile(const QString& path)
{
    if(!path.isEmpty())
        _watcher.removePath(path);
}

}
