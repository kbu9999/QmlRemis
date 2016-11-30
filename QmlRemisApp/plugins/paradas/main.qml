import QtQuick 2.0
import QtQuick.Controls 2.0
import QtLocation 5.2
import OrmQuick 1.0

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

        Row {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 10

            S.TextStyled {
                anchors.verticalCenter: parent.verticalCenter
                text: "Administracion de Paradas"
                color: "#505050"
                font.pointSize: 11
            }

            S.ButtonMap {
                //width: 36; height: 36
                setstate: 1
                anchors.verticalCenter: parent.verticalCenter
                onLocate: {
                    map.clearMapItems()
                    map.geoItem = showMap
                    map.geoModel = paradas
                }
            }

            S.ButtonEdit {
                //width: 36; height: 36
                anchors.verticalCenter: parent.verticalCenter
                iconSource: "../../assets/icons/document-save.png"
                onClicked: paradas.commit()
            }

            S.ButtonEdit {
                //width: 36; height: 36
                anchors.verticalCenter: parent.verticalCenter
                iconSource: "../../assets/icons/contact-new.png"
                onClicked: paradas.insertRows(paradas.count - 1, 1)
            }
        }

    }

    //Component.onCompleted: ld.load()

    S.TableView {
        id: tbView
        width: parent.width
        anchors.top: header.bottom
        anchors.bottom: parent.bottom

        /*model: OrmModel {
            id: ld
            metaTable: MetaParada
            loader.loadForeignKeys: false
        }//*/

        model: paradas

        ButtomColumn { source: "qrc:/assets/icons/user-group-properties.png" }

        ButtomColumn {
            source: "qrc:/assets/icons/kick-user.png"
            onClicked: paradas.deleteRows(row, 1)
        }

        S.TableViewColumn {
            title: "ID"
            role: "idParada"
            width: 80
        }

        TextFieldColumn {
            title: "Parada"
            role: "parada"
            width: 150

            onTextChanged: {
                var cl = paradas.at(row)
                if (!cl) return;

                cl.parada = text
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

            property Parada parada: paradas.at(index)

            anchorPoint.x: img.width/2
            anchorPoint.y: img.height/2
            coordinate: parada.coordValid? parada.coordinate : map.center

            sourceItem:  Rectangle {
                id: img
                color: "#663daee9"
                opacity: ma.drag.active? 0.5 : 1
                width: 200; height: 200
                radius: 100

                Rectangle {
                    anchors.centerIn: parent
                    width: 6; height: 6; radius: 3
                    color: "blue"
                }

                Text {
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: -20
                    text: parada.parada
                }

                MouseArea {
                    id: ma
                    anchors.fill: parent
                    drag.target: mqi

                    onPressed: map.gesture.enabled = false
                    onReleased: {
                        parada.coordinate = mqi.coordinate
                        map.gesture.enabled = true;
                    }
                }
            }
        }
    }
}
