import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.0

import qmlremis.DB 1.0
import qmlremis.Basic 1.0
import qmlremis.Style 1.0 as S
import Models 1.0

Rectangle {
    id: window
    width: 1024; height: 768
    color: "#f3f3f3"
    focus: true

    Action { shortcut: "pgUp"; onTriggered: paradas.next() }
    Action { shortcut: "pgDown"; onTriggered: paradas.back() }
    //Action { shortcut: "F4"; onTriggered: console.log("F4") }


    Action { id: a2; text: "Alquiler"; onTriggered: pluginLoad("../plugins/alquiler/main.qml") }
    Action { id: a3; text: "Clientes"; onTriggered: pluginLoad("../plugins/clientes/main.qml") }
    Action { id: a1; text: "Moviles";  onTriggered: pluginLoad( "../plugins/moviles/main.qml") }
    Action { id: a4; text: "Paradas";  onTriggered: pluginLoad( "../plugins/paradas/main.qml") }


    property alias paradasModel: paradas
    ColaModel {
        id: paradas
    }

    function pluginLoad(source) {
        if (source === "") loader.sourceComponent = null
        else loader.source = source
    }

    Component.onCompleted: {
        MainHandler.user = user

        menu.addAction(a1)
        menu.addAction(a2)
        menu.addAction(a3)
        if (user.user === "admin") menu.addAction(a4)
        a1.trigger()
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

            Caller {
                id: caller
                width: 320

                anchors.top: parent.top
                anchors.bottom: parent.bottom
            }

            Column {
                anchors.top: parent.top; anchors.topMargin: 5
                anchors.bottom: parent.bottom
                spacing: 2

                S.Button {
                    text: "Contestar";
                    enabled: caller.llstate == 1
                    property color color: "green"
                    width: parent.width

                    onClicked: MainHandler.contestar()
                }
                S.Button {
                    text: "Cortar";
                    enabled: caller.llstate == 2
                    property color color: "red"
                    width: parent.width

                    onClicked: MainHandler.colgar()
                }

                Rectangle { color: "#d9d9d9"; width: parent.width; height: 1 }

                S.Button {
                    text: "Agregar";
                    enabled: MainHandler.alquiler? true : false
                    property color color: "#ff8a05"
                    width: 100

                    onClicked: MainHandler.pushCurrentAlquiler(paradasModel.parada)
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
            anchors.margins: 10

            Centro {
                id: centro
                Layout.fillHeight: true

                Behavior on x { NumberAnimation { } }
                Behavior on width { NumberAnimation { } }
            }

            Loader {
                id: loader
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.minimumWidth: 400
            }

            RemisMap {
                id: map
                visible: false
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.minimumWidth: 200
            }
        }
    }
    states: [
        State {
            name: "map_centro"
            when: showMap

            PropertyChanges {
                target: loader
                //width: 0
                visible: false
            }

            PropertyChanges {
                target: map
                visible: true
            }
        },
        State {
            name: "map_plug"
            //PropertyChanges { target: loader; anchors.rightMargin: 37 }

            PropertyChanges {
                target: centro
                //width: 0
                visible: false
            }

            PropertyChanges {
                target: map
                visible: true
            }
        }
    ] //*/

}
