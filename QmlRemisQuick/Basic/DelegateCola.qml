import QtQuick 2.2
import QtQuick.Controls 1.1

import qmlremis.Style 1.0 as S
import qmlremis.Basic 1.0 as B
import qmlremis.DB 1.0

Rectangle {
    id: main
    height: 300
    implicitWidth: 280

    property Parada parada: null

    Rectangle {
         width: parent.width
         height: 1
         color: "#e2e2e2"
    }

    ListView {
        id: colaView
        anchors.fill: parent
        model: parada? parada.moviles : []

        delegate: Item {
            width: main.width
            height: 50

            DelegateMovil {
                width: parent.width - 40
                showIndex: true
                pos: index + 1

                movil: main.parada? main.parada.moviles[index] : null

                MouseArea {
                    anchors.fill: parent
                    //onClicked: main.parada.popMovil()
                }
            }

        }
    }
}
