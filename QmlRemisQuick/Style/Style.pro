TEMPLATE = aux
TARGET = Style

TARGET = $$qtLibraryTarget($$TARGET)
uri = qmlremis.Style

DISTFILES = qmldir \
    #TableViewStyle.qml \
    #TabViewStyle.qml \
    TextStyled.qml \
    #ButtonEditStyle.qml \
    #ButtonStyle.qml \
    Button.qml \
    ButtonEdit.qml \
    ButtonMap.qml \
    Panel.qml \
    TableView.qml \
    TableViewColumn.qml


include(../qmlmodule.pri)


qmldir.files = $$DISTFILES

unix {
    installPath = $$[QT_INSTALL_QML]/$$replace(uri, \\., /)
    qmldir.path = $$installPath
    INSTALLS += qmldir
}
