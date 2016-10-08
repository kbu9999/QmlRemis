import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtPositioning 5.2
import QtLocation 5.2

import qmlremis.Basic 1.0
import qmlremis.Style 1.0 as S
import com.kbu9999.FieldPanel 1.0

import Models 1.0

Panel {
    id: edAlq

    editIcon: "../assets/icons/document-edit.png"
    ormObject: MainHandler.alquiler

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

    FieldGeoBox {
        title: "Origen"
        role: "origen"
        gpsRole: "origen_gps"
        //model: map.geoModel
        mapIcon: "../assets/icons/go-home.png"
        animLoading: "../assets/loading.gif"

        onSearched: {
            map.geoModel = gmodel
        }

        onGpsSelected: {
            map.geoModel = 0
            if (!ormObject) return;

            ormObject[role] = dir
            ormObject[gpsRole] = coordinate

            map.fitViewPortAlquiler()
            //console.log(gpsRole, ormObject[gpsRole])
        }
    }

    FieldGeoBox {
        title: "Destino"
        role: "destino"
        gpsRole: "destino_gps"
        //model: map.geoModel
        mapIcon: "../assets/icons/go-home.png"
        animLoading: "../assets/loading.gif"

        onSearched: {
            map.geoModel = gmodel
        }

        onGpsSelected: {
            map.geoModel = 0
            if (!ormObject) return;

            ormObject[role] = dir
            ormObject[gpsRole] = coordinate

            map.fitViewPortAlquiler()
            //console.log(gpsRole, ormObject[gpsRole])
        }
    }

    Field {
        title: "Tiempo"
    }
    Field {
        title: "Distancia"
    }
}
