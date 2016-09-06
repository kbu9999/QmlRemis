import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.2

import qmlremis.Style 1.0
import qmlremis.Basic 1.0
import "../Models"// 1.0

Item {
    id: caller

    Action { shortcut: "F5"; onTriggered: bTel.state = "llamada" }

    function parseTel(tel) {
        var t = tel.toString();
        return "("+t.substring(0, 3)+") " + t.substring(3, 6)+ " - " + t.substring(6, t.length)
    }

    FontLoader {
        id: digitalFont
        source: "../assets/digital-7.ttf"
    }

    property string telefono: MainHandler.llamada? MainHandler.llamada.tel : "381 "
    property int llstate: MainHandler.llamada? MainHandler.llamada.estado : 0

    Row {
        id: row
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: tel.height
        anchors.margins: 10
        anchors.bottomMargin: 5

        Text {
            id: tel
            font.family: digitalFont.name
            font.pixelSize: 54

            text: caller.telefono

            ColorAnimation {
                id: anim;
                target: tel;
                property: "color";
                from: "white"
                to: "red";
                loops: Animation.Infinite;
                duration: 400
            }
        }

        Button {
            id: bTel

            property color color: "grey"
            width: 100
            height: 50
            clip: true

            style: ButtonStyle {
                background: Rectangle {
                    color: control.color
                    width: control.width
                    height: control.height
                }
                label: TextStyled {
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    width: control.width
                    height: control.height
                    text: control.text
                    color: "white"
                    font.bold: true
                    font.pointSize: 11
                    style: Text.Normal
                }
            }

            Behavior on color { ColorAnimation { duration: 400 } }
            Behavior on width { NumberAnimation { duration: 200 } }

            onClicked: {
                switch(llstate) {
                //case "espera": state = "llamada"; break;
                case 1: MainHandler.contestar(); break;
                case 2: MainHandler.colgar();break;
                }
            }

            state: "espera"
            states: [
                State {
                    name: "espera"
                    when: llstate == 0 || llstate > 2
                    PropertyChanges { target: bTel; width: 0 }
                },
                State {
                    name: "llamada"
                    when: llstate == 1
                    PropertyChanges { target: bTel; color: "green" }
                    PropertyChanges { target: bTel; text: "Contestar" }
                },
                State {
                    name: "colgar"
                    when: llstate == 2
                    PropertyChanges { target: bTel; color: "red" }
                    PropertyChanges { target: bTel; text: "Colgar" }
                }
            ]

            transitions: [
                Transition {
                    from: "llamada"; to: "colgar"
                    SequentialAnimation {
                        NumberAnimation { target: bTel; property: "width"; to: 0; duration: 300 }
                        NumberAnimation { target: bTel; property: "width"; to: 100; duration: 300 }
                    }
                }
            ]
        }

    }

    DelegateMovil {
        id: movilDeleg
        width: 300; height: 60
        anchors.top: row.bottom

        movil: paradasModel.movil
    }

    Button {
        id: button1
        width: MainHandler.alquiler? 80 : 0
        height: 60
        text: MainHandler.alquiler? "Agregar" : ""
        anchors.top: row.bottom
        anchors.right: row.right

        Behavior on width { NumberAnimation { duration: 300 } }

        onClicked: {
            MainHandler.alquiler.parada = paradasModel.parada
            MainHandler.pushCurrentAlquiler()
        }
    }
}

