#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "manager.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    Manager man(11);

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("manager", &man);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    QObject::connect(&man, &Manager::requestReload, [&](){ engine.load(QUrl(QStringLiteral("qrc:/main.qml"))); });

    return app.exec();
}
