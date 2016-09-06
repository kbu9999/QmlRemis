import QtQuick 2.0
import QtQuick.Controls 1.1
import QtGraphicalEffects 1.0 as G
import OrmQuick 1.0

import "ui"
import "Models"

ApplicationWindow {
    visible: true
    width: 1024
    height: 768

    /*Connections {
        target: Service
        onUpdateParada: MainHandler.updateParada(idParada)
        onUpdateEspera: MainHandler.updateEspera()
    }//*/

    property alias db: config.db
    property alias loginManager: login.loginManager
    property alias window: mainld.item

    MainMenu {
        id: menu
        height: 60
        anchors.right: parent.right
        anchors.left: parent.left

        Component {
            id: rwcomp
            RemisWindow {
            }
        }

        model: ListModel {
            //ListElement { title: "centro" }
            //ListElement { title: "moviles" }

            onCountChanged: {
                //mainld.source = "qrc:/ui/RemisWindow.qml"
                mainld.sourceComponent = rwcomp

                menu.reset()
            }
        }

        onPluginLoad: window.pluginLoad(source)
    } //*/

    Item {
        //anchors.topMargin: 0
        anchors.top: menu.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.left: parent.left

        Item {
            anchors.fill: parent
            focus: true

            layer.enabled: config.visible || login.visible
            layer.effect: G.FastBlur { radius: 16 }

            enabled: !layer.enabled

            Loader {
                id: mainld
                anchors.fill: parent
            }
        }

        PanelLogin {
            id: login
            anchors.fill: parent
            model: menu.model
            visible: !loginManager.connected
        }

        PanelConfig {
            id: config
            anchors.fill: parent
            visible: false
        }
    }

    Component.onCompleted: {
        //showMaximized()
    }
}
