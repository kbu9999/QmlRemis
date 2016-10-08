TEMPLATE = aux
TARGET = DB

TARGET = $$qtLibraryTarget($$TARGET)
uri = qmlremis.DB

QMLFILES = qmldir \
    OrmObjectMap.qml \
    Alquiler.qml \
    Cliente.qml \
    Llamadas.qml \
    Movil.qml \
    Multa.qml \
    Parada.qml

QMLMETAFILES = Meta/qmldir \
    Meta/MetaAlquiler.qml \
    Meta/MetaCliente.qml \
    Meta/MetaLlamadas.qml \
    Meta/MetaMovil.qml \
    Meta/MetaMulta.qml \
    Meta/MetaParada.qml

DISTFILES = $$QMLFILES $$QMLMETAFILES

include(../qmlmodule.pri)


qmldir1.files = $$QMLFILES
qmldir2.files = $$QMLMETAFILES

unix {
    installPath = $$[QT_INSTALL_QML]/$$replace(uri, \\., /)
    qmldir1.path = $$installPath
    qmldir2.path = $$installPath/Meta
    INSTALLS += qmldir1 qmldir2
}
