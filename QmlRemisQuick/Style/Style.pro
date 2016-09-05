TEMPLATE = aux
TARGET = Style

TARGET = $$qtLibraryTarget($$TARGET)
uri = qmlremis.Style

DISTFILES = qmldir \
    ButtonEditStyle.qml \
    TableViewStyle.qml \
    TabViewStyle.qml \
    TextStyled.qml


include(../qmlmodule.pri)


qmldir.files = $$DISTFILES

unix {
    installPath = $$[QT_INSTALL_QML]/$$replace(uri, \\., /)
    qmldir.path = $$installPath
    INSTALLS += qmldir
}
