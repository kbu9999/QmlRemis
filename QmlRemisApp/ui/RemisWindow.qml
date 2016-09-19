import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.0

import qmlremis.Basic 1.0
import qmlremis.Style 1.0 as S
import "../Models" // 1.0

Rectangle {
    id: window
    width: 1024; height: 768
    color: "#f3f3f3"

    property alias paradasModel: paradas

    focus: true

    Action { shortcut: "pgUp"; onTriggered: paradas.next() }
    Action { shortcut: "pgDown"; onTriggered: paradas.back() }
    //Action { shortcut: "F4"; onTriggered: console.log("F4") }

    ColaModel {
        id: paradas
    }

    function pluginLoad(source) {
        if (source === "") loader.sourceComponent = null
        else loader.source = source
    }

    Rectangle {
        id: tools
        height: 100
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: parent.top

        color: "transparent"
        border.color: "#363636"
        border.width: 1
        radius: 5
        anchors.rightMargin: 20
        anchors.leftMargin: 20
        anchors.topMargin: 6
        anchors.bottomMargin: 6

        RowLayout {
            id: rowC
            anchors.fill: parent
            anchors.margins: 5
            spacing: 20

            /*Caller {
                id: caller
                width: 320

                anchors.top: parent.top
                anchors.bottom: parent.bottom
            } //*/

            Item {
                id: caller
                width: 320

                FontLoader { id: digitalFont; source: "../assets/digital-7.ttf" }

                property int llstate: MainHandler.llamada? MainHandler.llamada.estado : 0
                property string telefono: MainHandler.llamada? MainHandler.llamada.tel : "381 "

                Text {
                    id: tel
                    x: 5
                    font.family: digitalFont.name
                    font.pixelSize: 54

                    text: caller.telefono

                    ColorAnimation {
                        target: tel;
                        property: "color";
                        from: "white"; to: "red";
                        loops: Animation.Infinite;
                        duration: 400
                        running: caller.llstate == 1
                    }
                }

                DelegateMovil {
                    id: movilDeleg
                    anchors.bottom: parent.bottom

                    movil: paradasModel.movil
                }

                anchors.top: parent.top
                anchors.bottom: parent.bottom
            }

            Column {
                anchors.top: parent.top; anchors.topMargin: 5
                anchors.bottom: parent.bottom
                spacing: 2

                Button {
                    text: "Contestar";
                    enabled: caller.llstate == 1
                    onClicked: MainHandler.contestar()
                    property color color: "green"
                    width: parent.width
                    style: S.ButtonStyle { }
                }
                Button {
                    text: "Cortar";
                    enabled: caller.llstate == 2
                    onClicked: MainHandler.colgar()
                    property color color: "red"
                    width: parent.width
                    style: S.ButtonStyle { }
                }

                Rectangle { color: "#d9d9d9"; width: parent.width; height: 1 }

                Button {
                    text: "Agregar";
                    enabled: MainHandler.alquiler? true : false
                    property color color: "#ff8a05"
                    width: 100
                    style: S.ButtonStyle { }
                    onClicked: {
                        MainHandler.alquiler.parada = paradasModel.parada
                        MainHandler.pushCurrentAlquiler()
                    }
                }
            }

            EditCliente {
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 0; anchors.bottomMargin: 3
                width: 330
            }

            EditAlquiler {
                id: editAlq
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 0; anchors.bottomMargin: 3
                width: 330
            }

            Item {
                height: parent.height
                Layout.fillWidth: true
            }
        }
    }//*/

    Rectangle {
        id: rectangle2

        anchors.top: tools.bottom
        anchors.bottom: parent.bottom

        border.color: "#d9d9d9"
        border.width: 1

        color: "white"
        radius: 5
        anchors.bottomMargin: 5
        anchors.rightMargin: 20
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.topMargin: 10

        RowLayout {
            anchors.fill: parent

            Centro {
                id: centro

                //width: parent.width / 2
                anchors.leftMargin: 10
                anchors.bottomMargin: 10
                anchors.topMargin: 10
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.top: parent.top

                Behavior on x { NumberAnimation { } }
                Behavior on width { NumberAnimation { } }
            }

            Loader {
                id: loader
                //width: parent.width / 2 - 30
                //anchors.right: map.left
                Layout.fillWidth: true

                anchors.bottom: parent.bottom
                anchors.top: parent.top
                anchors.left: centro.right
                anchors.margins: 10

                Behavior on x { NumberAnimation { } }
                Behavior on width { NumberAnimation { } }
            }

            RemisMap {
                id: map

                anchors.bottom: parent.bottom
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.left: loader.right

                anchors.margins: 10
                visible: false

                Behavior on x { NumberAnimation { } }
                Behavior on width { NumberAnimation { } }
            }
        }
    }
    states: [
        State {
            name: "map_centro"
            when: showMap

            PropertyChanges {
                target: loader
                width: 0
                visible: false
            }

            PropertyChanges {
                target: map
                visible: true
            }
        },
        State {
            name: "map_plug"
            PropertyChanges {
                target: loader
                anchors.rightMargin: 37
            }

            PropertyChanges {
                target: centro
                width: 0
            }

            PropertyChanges {
                target: map
                visible: true
            }
        }
    ] //*/

}
