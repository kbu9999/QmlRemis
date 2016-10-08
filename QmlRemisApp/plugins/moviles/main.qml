import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import OrmQuick 1.0
import QtPositioning 5.2
import QtLocation 5.2

import qmlremis.Basic 1.0
import qmlremis.Style 1.0 as S
import qmlremis.DB 1.0
import qmlremis.DB.Meta 1.0
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

        property Movil movil

        function multar(mins) {
            if (movil) MultasManager.addMovil(movil, mins)
            //tbView.updateModel()
        }

        border.color: "#d9d9d9"

        S.TextStyled {
            x: 20
            y: 15
            text: "Administracion de Moviles"
            color: "#505050"
            font.pointSize: 11
        }

        Row {
            id: row1
            x: 20
            y: 46
            width: 100
            height: 40
            spacing: 4

            Button {
                anchors.verticalCenter: parent.verticalCenter
                tooltip: "Guardar"
                iconSource: "../../assets/icons/document-save.png"
                style: S.ButtonEditStyle { }
                visible: header.movil? header.movil.dirt || !header.movil.saved : false

                onClicked: if (header.movil) header.movil.save()
            }

            Button {
                anchors.verticalCenter: parent.verticalCenter
                tooltip: "Libre"
                iconSource: "../../assets/icons/flag-red.png"
                style: S.ButtonEditStyle { }
                visible: header.movil && header.movil.estado !== 2

                onClicked: header.movil.libre()
            }

            Button {
                anchors.verticalCenter: parent.verticalCenter
                tooltip: "Libre"
                iconSource: "../../assets/icons/flag.png"
                style: S.ButtonEditStyle { }
                visible: header.movil && header.movil.estado !== 0

                onClicked: header.movil.off()
            }

            Button {
                anchors.verticalCenter: parent.verticalCenter
                tooltip: "Encolar"
                iconSource: "../../assets/icons/flag-blue.png"
                style: S.ButtonEditStyle { }
                visible: header.movil && header.movil.estado !== 1

                menu: Menu {
                    id: parMenu
                    Instantiator  {
                        model: window.paradasModel

                        MenuItem {
                            text: parada
                            onTriggered: header.movil.setParada(window.paradasModel.at(index))
                        }

                        onObjectAdded: parMenu.insertItem(count - 1, object)
                        onObjectRemoved: parMenu.removeItem(object)
                    }
                }
            }

            Button {
                anchors.verticalCenter: parent.verticalCenter
                tooltip: "Multar"
                iconSource: "../../assets/icons/download-later.png"
                style: S.ButtonEditStyle { }

                menu: Menu {
                    MenuItem {
                        text: "1 Hora"
                        onTriggered: header.multar(60)
                    }
                    MenuItem {
                        text: "3 Horas"
                        onTriggered: header.multar(60*3)
                    }
                }
            }

            Button {
                anchors.verticalCenter: parent.verticalCenter
                tooltip: "Agregar"
                iconSource: "../../assets/icons/contact-new.png"
                style: S.ButtonEditStyle { }
                visible: user.user === "admin"

                onClicked: tbView.addMovil()
            }
        }
    }

    ViewMoviles {
        id: tbView
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        
        onMovilChanged: header.movil = movil

        enableDrag: true

        //role: "estado"; filter: "2"

        onDoubleClicked: {
           var parada = window.paradasModel.parada
           if (!parada) return;

           parada.appendMovil(movil);
           //service.updateParada(parada.idParada)
       }
    }

    function ubicar(row) {
        map.clearMapItems()
        map.addMapItem(showMap.createObject(map, { movil: MovilPlugin.at(row) } ))
    }

    Component {
        id: showMap
        MapQuickItem {
            id: mqi

            property Movil movil

            anchorPoint.x: img.width/2
            anchorPoint.y: img.height
            coordinate: movil.coordValid? movil.coordinate : map.center
            sourceItem:  Image {
                id: img
                source: {
                    switch (movil.estado) {
                    case 1: return "../../assets/icons/im-user.png";
                    case 2: return "../../assets/icons/im-user-away.png";
                    default: return "../../assets/icons/im-user-offline.png";
                    }
                }
                opacity: ma.drag.active? 0.6 : 1

                Text {
                    y: img.height / 2 - 1
                    x: img.width / 4 + 2
                    text: movil.idMovil
                    font.family: "Arial Black"
                    font.bold: true
                    font.pixelSize: 14
                }

                MouseArea {
                    id: ma
                    anchors.fill: parent
                    drag.target: mqi

                    onPressed: map.gesture.enabled = false
                    onReleased: {
                        map.gesture.enabled = true;
                        if (movil)
                            movil.coordinate = mqi.coordinate
                    }
                }
            }
        }
    }
}
