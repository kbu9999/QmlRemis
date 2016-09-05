TEMPLATE = subdirs

DIRCACHE = QMLDIR=$$OUT_PWD/qml
write_file(.qmake.cache,  DIRCACHE)

SUBDIRS += \
    MyQuick \
    QmlRemisQuick \
    QmlRemisApp \
    QmlRemisServer \
    #test
