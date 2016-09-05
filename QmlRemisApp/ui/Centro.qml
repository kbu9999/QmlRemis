import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtPositioning 5.2
import QtLocation 5.2
import OrmQuick 1.0

import qmlremis.Basic 1.0
import qmlremis.Style 1.0 as S
import qmlremis.DB 1.0
import qmlremis.DB.Meta 1.0

ListView {
    id: paradasView
    width: parent.width
    height: 300
    orientation: ListView.Horizontal
    flickableDirection: Flickable.HorizontalFlick
    anchors.top: parent.top
    clip: true

    model: window.paradasModel

    delegate: Item {
        id: rootDeleg
        width: 280
        height: paradasView.height

        property Parada par: paradas.at(index)

        Rectangle {
            anchors.fill: parent
            color: paradasView.model.currentIndex === index? "red" : "white"
            opacity: 0.4
        }

        S.TextStyled {
            id: nPar
            width: parent.width
            height: 50

            font.bold: true
            font.pointSize: 13
            horizontalAlignment: Text.AlignHCenter

            text: parada
        }

        DelegateCola {
            anchors.top: nPar.bottom
            anchors.bottom: parent.bottom
            width: parent.width
            parada: rootDeleg.par
            clip: true
        }

        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.color: "grey"
            border.width: 1
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                paradasView.model.currentIndex = index;
            }
        }

        DropArea {
            anchors.fill: parent
            property alias parada: rootDeleg.par
        }
    }
}

