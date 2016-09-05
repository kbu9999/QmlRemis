import QtQuick 2.2
import QtQuick.Controls 1.2

import qmlremis.Basic 1.0
import Models 1.0

Rectangle {
    id: window
    width: 1200
    height: 800
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
        height: 130
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: parent.top

        color: "transparent"
        border.color: "#363636"
        border.width: 1
        radius: 5
        anchors.rightMargin: 20
        anchors.leftMargin: 20
        anchors.topMargin: 10
        anchors.bottomMargin: 10

        Row {
            id: rowC
            anchors.fill: parent
            anchors.margins: 0

            Caller {
                id: caller
                width: 320

                anchors.top: parent.top
                anchors.bottom: parent.bottom
            }

            EditCliente {
                height: 110
                width: 320
            }

            EditAlquiler {
                id: editAlq
                height: 110
                width: 320
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

        Centro {
            id: centro

            width: parent.width / 2
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
            width: parent.width / 2 - 30
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
