import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtLocation 5.2
import OrmQuick 1.0

import qmlremis.Basic 1.0
import com.kbu9999.Columns 1.0
import qmlremis.Style 1.0
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

        TextStyled {
            x: 15
            anchors.verticalCenter: parent.verticalCenter
            text: "Administracion de Paradas"
            color: "#505050"
            font.pointSize: 11
        }

        Button {
            x: 490; y: 18
            //width: 36; height: 36
            style: ButtonEditStyle { }
            iconSource: "../../assets/icons/world.png"
            onClicked: {
                if (window.state === "map_plug" ) {
                    window.state = "";
                    return;
                }

                window.state = "map_plug"
                map.clearMapItems()
                map.geoItem = showMap
                map.geoModel = ld
            }
        }

        Button {
            x: 530; y: 18
            //width: 36; height: 36
            style: ButtonEditStyle { }
            iconSource: "../../assets/icons/document-save.png"
            onClicked: ld.commit()
        }

    }

    Component.onCompleted: ld.load()

    TableView {
        id: tbView
        width: parent.width
        anchors.top: header.bottom
        anchors.bottom: parent.bottom

        model: OrmModel {
            id: ld
            metaTable: MetaParada
            loader.loadForeignKeys: false
        }

        style: TableViewStyle { }

        ButtomColumn { source: "qrc:/assets/icons/user-group-properties.png" }

        TableViewColumn {
            title: "ID"
            role: "idParada"
            width: 80
        }

        TextFieldColumn {
            title: "Parada"
            role: "parada"
            width: 150

            onTextChanged: {
                var cl = ld.at(row)
                if (!cl) return;

                cl.nombre = text
            }
        }

        TableViewColumn { id: cgps; role: "gps" }

        onClicked: currentRow = row
    }

    Component {
        id: showMap
        MapCircle {
            id: mqi
            property Parada parada: ld.at(index)

            color: "#663daee9"
            radius: 2000
            center: parada.gps == ""? map.center : parada.coordinates
            opacity: ma.drag.active? 0.5 : 1

            MouseArea {
                id: ma
                anchors.fill: parent
                drag.target: mqi

                onPressed: map.gesture.enabled = false
                onReleased: {
                    map.gesture.enabled = true;
                    mqi.parada.setGps(mqi.center)
                }
            }
        }
    }
}
