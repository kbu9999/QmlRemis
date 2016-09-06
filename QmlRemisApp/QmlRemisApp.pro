TEMPLATE = app

QT += qml quick #printsupport dbus

SOURCES += main.cpp
CONFIG += c++11
RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH = $$OUT_PWD/../qml/

# Default rules for deployment.
include(deployment.pri)

#LIBS += -lqpjsua -lpjsua -lpj

target.path = /usr/bin
