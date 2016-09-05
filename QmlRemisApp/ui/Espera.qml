import QtQuick 2.0
import OrmQuick 1.0

import qmlremis.DB 1.0
import qmlremis.DB.Meta 1.0

import Models 1.0

Row {
    id: espera

    anchors.margins: 10

    Rectangle {
        width: parent.width / 2
        height: parent.height
        anchors.margins: 10

        color: "transparent"
        border.color: "black"
        border.width: 2

        ListView {
            anchors.fill: parent

            model: MainHandler.queue
            delegate: Rectangle {
                color: "grey"
                width: 150
                height: 70
                Text {
                    anchors.fill: parent
                    color: "white"
                    text: " - "+destino+" - "+origen
                }
            }
        }
    }

    Rectangle {
        width: parent.width / 2
        height: parent.height
        anchors.margins: 10

        color: "transparent"
        border.color: "black"
        border.width: 2

        ListView {
            anchors.fill: parent

            model: MainHandler.espera
            delegate: Rectangle {
                color: "grey"
                width: 150
                height: 50
                Text {
                    anchors.fill: parent
                    color: "white"
                    text: cliente.nombre+" - "+origen
                }
            }
        }
    }

    Behavior on x { NumberAnimation { } }
    Behavior on width { NumberAnimation { } }
}
