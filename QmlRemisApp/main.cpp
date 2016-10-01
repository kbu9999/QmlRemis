#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQml>


/*static QObject *create_cmi(QQmlEngine *e, QJSEngine *js) {
    Q_UNUSED(e)
    Q_UNUSED(js)
    //CallManagerInterface *ci = new CallManagerInterface(QDBusConnection::sessionBus());
    return CallManager::manager;
}

qmlRegisterSingletonType<CallManager>("QmlRemis", 1, 0, "CallManager", create_cmi);
//*/

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setOrganizationName("KISystem");
    app.setOrganizationDomain("kisystem.com.ar");
    app.setApplicationName("QmlRemis");
    qDebug()<<"version: 0.2.3";

    QQmlApplicationEngine engine;
    engine.addImportPath("../qml");
    engine.addImportPath("qrc:/");
    engine.load(QUrl("qrc:/main.qml"));
    return app.exec();
}
