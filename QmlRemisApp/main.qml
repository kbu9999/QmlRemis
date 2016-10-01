import QtQuick 2.2
import QtQuick.Window 2.1
import QtQuick.Controls 1.1

import OrmQuick 1.0
import com.kbu9999.SimpleDBSec 1.0
import com.kbu9999.SimpleDBSec.Meta 1.0

import "ui"
import Models 1.0
import qmlremis.Style 1.0
import qmlremis.Basic 1.0
import qmlremis.DB.Meta 1.0

SecWindow {
    id: main
    visible: true
    width: 1024
    height: 768

    title: "QmlRemisApp"
    menuView: MyMenu { }

    loginStyle: LoginStyle {
        background: Item {

            Rectangle {
                anchors.fill: parent
                color: "#f3f3f3"
                opacity: 0.75
            }

            Rectangle {
                color: "#211d1b"
                radius: 4

                width: 300
                height: 500
                anchors.centerIn: parent
            }
        }

        userComponent: Image {
            width: 40; height: 40
            source: "../assets/icons/im-user-offline.png"
        }

        passComponent: Image {
            width: 40; height: 40
            source: "../assets/icons/object-locked.png"
        }
    }

    mainComponent: RemisWindow {
    }

    config: [
        ConfigDB { }
    ]

    db: OrmDataBase  {
        tables: [
            MetaAlquiler,
            MetaCliente,
            MetaLlamadas,
            MetaMovil,
            MetaParada,

            MetaUsuario, MetaPlugin,
            MetaRol, MetaRolDetalle, MetaLog
        ]

        onError: console.log(error)
    }

    Component.onCompleted: {
        showMaximized()
    }

}
