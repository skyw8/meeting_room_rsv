#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QNetworkProxy>
#include <QQmlContext>
#include <QProcess>
#include <FramelessHelper/Quick/framelessquickmodule.h>
#include <FramelessHelper/Core/private/framelessconfig_p.h>
#include <QtSql/QSqlDatabase>
#include <QtSql/QSqlError>
#include <QDebug>
#include <QSqlTableModel>
#include "SettingsHelper.h"
#include "CircularReveal.h"
#include "DatabaseManager.h"

FRAMELESSHELPER_USE_NAMESPACE

int main(int argc, char *argv[])
{
    QNetworkProxy::setApplicationProxy(QNetworkProxy::NoProxy);
    //将样式设置为Basic，不然会导致组件显示异常
    qputenv("QT_QUICK_CONTROLS_STYLE","Basic");
    QGuiApplication::setOrganizationName("Skywalker");
    QGuiApplication::setApplicationName("会议室预约系统");

    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
    //必须在创建DatabaseManager前
    SettingsHelper::getInstance()->init(argv);
    DatabaseManager db_mng;
    qmlRegisterType<CircularReveal>("meeting_room_rsv", 1, 0, "CircularReveal");
    engine.rootContext()->setContextProperty("SettingsHelper",SettingsHelper::getInstance());
    engine.rootContext()->setContextProperty("db_mng",&db_mng);

    qDebug()<<engine.importPathList();
    const QUrl url("qrc:meeting_room_rsv/qml/App.qml");
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);
    engine.load(url);
    const int exec = QGuiApplication::exec();
    if (exec == 931) {
        QProcess::startDetached(qApp->applicationFilePath(), QStringList());
    }
    return exec;
}
