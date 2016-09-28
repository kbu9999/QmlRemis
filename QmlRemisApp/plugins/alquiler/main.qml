import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.0
import OrmQuick 1.0

import qmlremis.Basic 1.0
import qmlremis.Style 1.0
import com.kbu9999.Columns 1.0
import qmlremis.DB 1.0
import qmlremis.DB.Meta 1.0
import "../../Models"

Item {
    id: malq
    width: 300
    height: 600

    property date current: new Date()
    property date zero: new Date(new Date().setHours(0, 0, 0, 0))

    function calc(dt) {
        return new Date(zero.setMilliseconds(current - dt))
    }

    Timer {
        interval: 500
        repeat: true
        running: true
        onTriggered: malq.current = new Date()
    }

    Rectangle {
        id: header
        width: parent.width
        height: 50
        color: "#ededed"
        radius: 2

        border.color: "#d9d9d9"

        TextStyled {
            x: 20;
            anchors.verticalCenter: parent.verticalCenter
            text: "Espera"
            color: "#505050"
            font.pointSize: 11
        }

        TextStyled {
            x: parent.width / 2;
            anchors.verticalCenter: parent.verticalCenter
            text: "Aceptados"
            color: "#505050"
            font.pointSize: 11
        }
    }

    Component {
        id: esperaStick
        Rectangle {
            id: rectangle1
            color: "#ff8a05"
            radius: 10
            width: 220; height: 90

            TextStyled {
                x: 10; y: 0
                text: cliente.nombre
                font.pointSize: 13
                font.bold: true
            }

            TextStyled {
                x: 10; y: 21
                text: cliente.telefono
                font.italic: true
            }

            TextStyled {
                x: 10; y: 37
                text: origen
            }
            TextStyled {
                x: 10; y: 53
                text: cliente.descripcion
            }

            Button {
                text: ">"
                anchors.right: parent.right
                height: parent.height
                width: 35
                onClicked: MainHandler.asignMovil(index)
            }

            TextStyled {
                x: 10; y: 68
                text: parada.parada
                anchors.rightMargin: 18
                anchors.right: parent.right
                selected: true
            }

            TextStyled {
                x: 10; y: 68
                text: malq.calc(fecha).toTimeString()
                selected: true
            }
        }
    }


    Component {
        id: atendidoStick
        Rectangle {
            id: rectangle1
            color: "#ba18a1"
            radius: 10
            width: 220; height: 70

            TextStyled {
                x: 10; y: 0
                text: cliente.nombre
                font.pointSize: 13
                font.bold: true
                style: Text.Normal
            }

            TextStyled {
                x: 10; y: 21
                text: cliente.telefono
                font.italic: true
                style: Text.Normal
            }

            TextStyled {
                x: 10; y: 38
                text: malq.calc(fechaAtencion).toTimeString()
                style: Text.Normal
            }

            TextStyled {
                x: 10; y: 53
                text: movil? movil.idMovil : "00"
                style: Text.Normal
            }

            TextStyled {
                x: 10; y: 69
                selected: true
            }

            Button {
                text: "X"
                anchors.right: parent.right
                height: parent.height
                width: 35
                onClicked: MainHandler.atendidos.removeRows(index, 1)
            }

        }
    }


    RowLayout  {
        //width: parent.width
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        spacing: 5

        ListView {
            Layout.fillHeight: true
            Layout.fillWidth: true
            model: MainHandler.queue
            //model: queue

            spacing: 5
            delegate: esperaStick
        }

        Rectangle {
            width: 2
            height: parent.height
            color: "#d9d9d9"
        }

        ListView {
            Layout.fillHeight: true
            Layout.fillWidth: true
            model: MainHandler.atendidos
            //model: queue

            spacing: 5
            delegate: atendidoStick
        }

    }
}

