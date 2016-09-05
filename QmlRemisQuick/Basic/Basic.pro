TEMPLATE = aux
TARGET = Basic

TARGET = $$qtLibraryTarget($$TARGET)
uri = qmlremis.Basic

DISTFILES = \
    DelegateCola.qml \
    DelegateMovil.qml \
    FieldGeoBox.qml \
    ViewMoviles.qml \
    qmldir

include(../qmlmodule.pri)

qmldir.files = $$DISTFILES

unix {
    installPath = $$[QT_INSTALL_QML]/$$replace(uri, \\., /)
    qmldir.path = $$installPath
    INSTALLS += qmldir
}
