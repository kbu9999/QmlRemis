import QtQuick 2.2

import qmlremis.Style 1.0 as S
import qmlremis.DB 1.0

Item {
    id: main
    width: 300
    height: 42

    property Movil movil: null
    property bool showIndex: false
    property int pos: 0

    Rectangle {
        id: r1
        width: showIndex? 36 : 0; height: 36
        color: "#3e5dca"
        anchors.verticalCenter: parent.verticalCenter
        visible: showIndex

        Text {
            anchors.fill: parent

            text: pos
            color: "white"
            font.pointSize: 19
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.family: "BellGothic BT"
        }
    }

    Rectangle {
        id: r2
        width: 36; height: 36
        color: "#eca817"
        anchors.left: r1.right
        anchors.margins: 5
        anchors.verticalCenter: parent.verticalCenter


        Text {
            anchors.fill: parent

            text: movil? movil.idMovil : "00"
            //text: "00"
            color: "white"
            font.pointSize: 19
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.family: "BellGothic BT"
        }
    }

    Column {
        height: 36
        anchors.left: r2.right; anchors.right: parent.right
        anchors.margins: 5
        anchors.verticalCenter: parent.verticalCenter
        spacing: 4

        S.TextStyled {
            text: "Modelo"
            font.bold: true
        }

        S.TextStyled {
            text: movil && movil.modelo? movil.modelo : "S/M"
        }
    }

    /*Grid {
        id: gr1
        anchors.top: parent.top
        anchors.left: rect2.right
        //width: 100
        anchors.right: parent.right

        anchors.margins: 10

        columns: 1
        columnSpacing: 16
        rowSpacing: 8
        verticalItemAlignment: Grid.AlignVCenter



        /*S.TextStyled {
            text: "Parada"
            font.bold: true
        }

        S.TextStyled {
            text: movil && movil.parada? movil.parada.parada : "Sin Parada"
        }

    }*/


}
