import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtQuick.Layouts 1.1
import QtPositioning 5.2
import QtLocation 5.2

import qmlremis.Basic 1.0
import qmlremis.Style 1.0 as S

import com.kbu9999.FieldPanel 1.0

import Models 1.0

Item {
    id: main
    implicitHeight: 200
    implicitWidth: 300

    Panel {
        id: grid1
        anchors.fill: parent
        anchors.rightMargin: 50

        ormObject: MainHandler.cliente
        editIcon: "../assets/icons/document-edit.png"

        titleDelegate: S.TextStyled {
            text: styleData.title
            selectedColor: "#e0392e"
            selected: styleData.isCurrentIndex
            font.bold: true
        }

        showDelegate: S.TextStyled {
            text: styleData.value? styleData.value : ""
            selectedColor: "#e0392e"
        }

        FieldTextEdit {
            title: "Familia"
            role: "nombre"
        }

        FieldGeoBox {
            id: geofield
            title: "Direccion"
            role: "direccion"
            gpsRole: "gps"
            mapIcon: "../assets/icons/go-home.png"
            animLoading: "../assets/loading.gif"

            onSearched: {
                if (window.state === "" ) window.state = "map_centro";

                map.geoItem = showMap
                map.geoModel = gmodel
            }

            onGpsSelected: {
                //map.addMapItem(showClMap)
                if (window.state === "" ) window.state = "map_centro";

                if (!grid1.ormObject) return
                grid1.ormObject.direccion = dir
                grid1.ormObject.gps = lat+", "+lon

            }
        }

        FieldTextEdit {
            title: "Descripcion"
            role: "descripcion"
        }
        Field {
            title: "Gps"
            role: "gps"
        }
    }

    Column {
        id: row1
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: 10
        anchors.margins: 10
        width: 40
        spacing: 4

        Button {
            tooltip: "Guardar"
            iconSource: "../assets/icons/document-save.png"
            style: S.ButtonEditStyle { }
            visible: grid1.ormObject? grid1.ormObject.dirt : false

            onClicked: if (MainHandler.cliente) MainHandler.cliente.save()
        }

        Button {
            tooltip: "Ubicar"
            iconSource: "../assets/icons/world.png"
            style: S.ButtonEditStyle { }
            onClicked: {
                map.clearMapItems()
                map.addMapItem(showMap.createObject(map, { cliente: main.cliente } ))
                if (window.state == "")
                    window.state = "Stack"
                else
                    window.state = "";
            }
        }
    }

    Component {
        id: showMap
        MapQuickItem {
            id: mqi

            anchorPoint.x: img.width/2
            anchorPoint.y: img.height/2
            coordinate: MainHandler.cliente.coordinate
            sourceItem:  Image {
                id: img
                source: "../assets/icons/go-home.png"
                opacity: ma.drag.active? 0.5 : 1

                MouseArea {
                    id: ma
                    anchors.fill: parent
                    drag.target: mqi

                    onPressed: map.gesture.enabled = false
                    onReleased: {
                        map.gesture.enabled = true;

                        if (MainHandler.cliente)
                            MainHandler.cliente.setGps(mqi.coordinate)
                    }
                }
            }
        }
    }

    Component {
        id: showClMap
        MapQuickItem {
            id: mqi

            anchorPoint.x: img.width/2
            anchorPoint.y: img.height/2
            coordinate: QtPositioning.coordinate(lat, lon)
            sourceItem:  Image {
                id: img
                source: "../assets/icons/go-home.png"
                opacity: ma.drag.active? 0.5 : 1

                MouseArea {
                    id: ma
                    anchors.fill: parent
                    drag.target: mqi

                    onPressed: map.gesture.enabled = false
                    onReleased: map.gesture.enabled = true;
                    onDoubleClicked: {
                        if (MainHandler.cliente) {
                            MainHandler.cliente.setGps(mqi.coordinate)
                            geofield.hideEditor()
                        }
                    }
                }
            }
        }
    }
}
