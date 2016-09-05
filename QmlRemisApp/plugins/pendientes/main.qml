import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

import QtPositioning 5.2
import QtLocation 5.2

import qmlremis.Basic 1.0
import com.kbu9999.Columnas 1.0
import qmlremis.Style 1.0 as S

import Models 1.0

Item {
    id: ci

    width: 400
    height: 300

    Rectangle {
        id: header
        width: parent.width
        height: 90
        color: "#ededed"
        radius: 2

        border.color: "#d9d9d9"

        S.TextStyled {
            x: 20
            y: 15
            text: "Clientes en Espera"
            color: "#505050"
            font.pointSize: 16
        }

    }

    TableView {
        id: pendView

        width: parent.width
        anchors.top: header.bottom
        anchors.bottom: parent.bottom

        style: S.TableViewStyle { }

        model: MainHandler? MainHandler.queue : []

        FKColumn {
            title: "Familia"
            role: "cliente"
            fkrole: "nombre"
        }

        FKColumn {
            title: "Telefono"
            role: "cliente"
            fkrole: "telefono"
        }

        TableViewColumn {
            title: "Origen"
            role: "origen"
        }

        FKColumn {
            title: "Descripcion"
            role: "cliente"
            fkrole: "descripcion"
        }

        TableViewColumn {
            title: "Destino"
            role: "destino"
        }
    }
}
