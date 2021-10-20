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

#ifndef __QATERIAL_HOT_RELOAD_HPP__
#define __QATERIAL_HOT_RELOAD_HPP__

#include <QtCore/QStringList>
#include <QtCore/QFileSystemWatcher>
#include <QtQml/QQmlEngine>
#include <QtQml/QtQml>

namespace qaterial {

class HotReload : public QObject
{
    Q_OBJECT

public:
    HotReload(QQmlEngine* engine, QObject* parent);
    ~HotReload();

private:
    QQmlEngine* _engine;
    QFileSystemWatcher _watcher;
    QStringList _defaultImportPaths;

    Q_PROPERTY(QStringList importPaths READ importPaths WRITE setImportPaths RESET resetImportPaths NOTIFY importPathsChanged)
    Q_PROPERTY(bool resetImportPath READ getResetImportPath CONSTANT);
    Q_PROPERTY(bool resetCurrentFile READ getResetCurrentFile CONSTANT);

public:
    QStringList importPaths() const { return _engine->importPathList(); }
    void setImportPaths(const QStringList& paths)
    {
        _engine->setImportPathList(paths);
        Q_EMIT importPathsChanged();
    }
    void resetImportPaths() { setImportPaths(_defaultImportPaths); }

Q_SIGNALS:
    void importPathsChanged();

public Q_SLOTS:
    void clearCache() const;

    void watchFile(const QString& path);
    void unWatchFile(const QString& path);
Q_SIGNALS:
    void watchedFileChanged();
    void newLog(QString s);

public:
    static void registerSingleton();
    static void resetImportPath();
    static void resetCurrentFile();
    static bool getResetImportPath() { return _resetImportPath; }
    static bool getResetCurrentFile() { return _resetCurrentFile; }
    static void log(QtMsgType type, const QMessageLogContext& context, const QString& msg);

private:
    static bool _resetImportPath;
    static bool _resetCurrentFile;
};

}

#endif
