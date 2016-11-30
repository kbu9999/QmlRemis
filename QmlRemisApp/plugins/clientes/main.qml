import QtQuick 2.0
import OrmQuick 1.0
import QtLocation 5.2
import QtQuick.Controls 2.0

import qmlremis.Basic 1.0
import com.kbu9999.Columns 1.0
import qmlremis.Style 1.0 as S
import qmlremis.DB 1.0
import qmlremis.DB.Meta 1.0

Item {
    id: ci

    Rectangle {
        id: header
        width: parent.width
        height: 60
        color: "#ededed"
        radius: 2

        border.color: "#d9d9d9"

        S.TextStyled {
            x: 15
            anchors.verticalCenter: parent.verticalCenter
            text: "Administracion de Clientes"
            color: "#505050"
            font.pointSize: 11
        }

        TextField {
            x: 260
            width: 120
            height: 30
            anchors.verticalCenterOffset: 1
            anchors.verticalCenter: parent.verticalCenter
            onTextChanged: filter.setFilterFixedString(text)
            Keys.onEscapePressed: text = ""

            background: Rectangle {
              implicitWidth: 120
              implicitHeight: 36
              color: parent.enabled ? "white" : "#353637"
              border.color: parent.enabled ? "#5c5c5c" : "transparent"
          }
        }

        /*ButtonGroup { id: exl }

        RadioButton {
            x: 395
            y: 8
            text: qsTr("Familia")
            ButtonGroup.group: exl
            onClicked: filter.filterProperty = "nombre"
        }

        RadioButton {
            x: 395
            y: 31
            text: qsTr("Direccion")
            ButtonGroup.group: exl
            onClicked: filter.filterProperty = "direccion"
        } //*/

        S.ButtonMap {
            x: 400;
            anchors.verticalCenter: parent.verticalCenter
            setstate: 1
            onLocate: {
                map.clearMapItems()
                map.geoItem = showMap
                map.geoModel = filter
            }
        }

        S.ButtonEdit {
            x: 445;
            anchors.verticalCenter: parent.verticalCenter
            iconSource: "../../assets/icons/document-save.png"
            onClicked: ld.commit()
        }

    }

    OrmFilterModel {
        id: filter
        sourceModel: OrmModel {
            id: ld
            metaTable: MetaCliente
            loader.loadForeignKeys: true
        }
        filterCaseSensitivity: Qt.CaseInsensitive
        filterProperty: "nombre"
    }

    Component.onCompleted: ld.load()

    S.TableView {
        id: tbView
        width: parent.width
        anchors.top: header.bottom
        anchors.bottom: parent.bottom

        model: filter

        ButtomColumn { source: "../../assets/icons/user-group-properties.png" }

        S.TableViewColumn {
            title: "Telefono"
            role: "telefono"
            width: 80
        }

        TextFieldColumn {
            title: "Familia"
            role: "nombre"
            width: 150

            onTextChanged: {
                var cl = filter.at(row)
                if (!cl) return;

                cl.nombre = text
            }
        }

        TextFieldColumn {
            title: "Direccion"
            role: "direccion"
            width: 150

            onTextChanged: {
                var cl = filter.at(row)
                if (!cl) return;

                cl.direccion = text
            }
        }

        TextFieldColumn {
            title: "Descripcion"
            role: "descripcion"
            width: 200

            onTextChanged: {
                var cl = filter.at(row)
                if (!cl) return;

                cl.descripcion = text
            }
        }

        //TableViewColumn { id: cgps; role: "gps" }
        S.TableViewColumn { role: "lat"; width: 80 }
        S.TableViewColumn { role: "lon"; width: 80 }

        onClicked: currentRow = row
    }

    Component {
        id: showMap
        MapQuickItem {
            id: mqi

            property Cliente cliente: filter.at(index)

            anchorPoint.x: img.width/2
            anchorPoint.y: img.height/2
            coordinate: cliente.coordValid? cliente.coordinate : map.center

            sourceItem:  Image {
                id: img
                source: "../../assets/icons/go-home.png"
                opacity: ma.drag.active? 0.5 : 1

                MouseArea {
                    id: ma
                    anchors.fill: parent
                    drag.target: mqi

                    onPressed: map.gesture.enabled = false
                    onReleased: {
                        map.gesture.enabled = true;
                        mqi.cliente.coordinate = mqi.coordinate
                    }
                }
            }
        }
    }
}
