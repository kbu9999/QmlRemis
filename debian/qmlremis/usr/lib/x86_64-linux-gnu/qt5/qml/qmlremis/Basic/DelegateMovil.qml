import QtQuick 2.2

import qmlremis.Style 1.0 as S
import qmlremis.DB 1.0

Item {
    id: main
    implicitWidth: 300
    implicitHeight: 50
    anchors.margins: 0

    property Movil movil: null
    property bool showIndex: false
    property int pos: 0

    Rectangle {
        id: rect1
        width: showIndex ? 40 : -10
        height: 40
        color: "#3e5dca"
        visible: showIndex

        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.top: parent.top
        anchors.topMargin: 10

        Text {
            anchors.fill: parent

            text: pos
            color: "white"
            font.pointSize: 20
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.family: "BellGothic BT"
        }
    }

    Rectangle {
        id: rect2
        width: 40
        height: 40
        color: "#eca817"

        anchors.left: rect1.right
        anchors.leftMargin: 10
        anchors.top: parent.top
        anchors.topMargin: 10

        Text {
            anchors.fill: parent

            text: movil? movil.idMovil : "00"
            color: "white"
            font.pointSize: 20
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.family: "BellGothic BT"
        }
    }

    Grid {
        id: gr1
        anchors.top: parent.top
        anchors.left: rect2.right
        //width: 100
        anchors.right: parent.right

        anchors.margins: 10

        columns: 2
        columnSpacing: 20
        rowSpacing: 10
        verticalItemAlignment: Grid.AlignVCenter

        S.TextStyled {
            text: "Modelo"
            font.bold: true
        }

        S.TextStyled {
            text: movil && movil.modelo? movil.modelo : "S/M"
        }

        S.TextStyled {
            text: "Parada"
            font.bold: true
        }

        S.TextStyled {
            text: movil && movil.parada? movil.parada.parada : "Sin Parada"
        }

    }


}
