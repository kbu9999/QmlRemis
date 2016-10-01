import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.2

import qmlremis.Style 1.0
import qmlremis.Basic 1.0
import Models 1.0

Item {
    id: caller
    width: 320

    FontLoader { id: digitalFont; source: "../assets/digital-7.ttf" }

    property int llstate: MainHandler.llamada? MainHandler.llamada.estado : 0
    property string telefono: MainHandler.llamada? MainHandler.llamada.telstring : "381 "

    Text {
        id: tel
        x: 5
        font.family: digitalFont.name
        font.pixelSize: 54

        text: caller.telefono

        ColorAnimation {
            id: anim
            target: tel;
            property: "color";
            from: "white"; to: "red";
            loops: Animation.Infinite;
            duration: 400
            //running: caller.llstate == 1
        }

        states: [
            State {
                when: caller.llstate == 1
                PropertyChanges { target: anim; running: true }
            },
            State {
                when: caller.llstate != 1
                PropertyChanges { target: tel; color: "black" }
            }
        ]
    }

    DelegateMovil {
        id: movilDeleg
        anchors.bottom: parent.bottom

        movil: paradasModel.movil
    }
}

