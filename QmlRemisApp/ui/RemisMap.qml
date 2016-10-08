import QtQuick 2.4
import QtPositioning 5.3
import QtLocation 5.3

import Models 1.0

Map {
    id: mapView
    property alias geoModel: gModel.model
    property alias geoItem: gModel.delegate

    center: QtPositioning.coordinate(-26.841, -65.163)
    zoomLevel: 13

    plugin: Plugin  {
        id: osm
        name: "mapbox"

        PluginParameter {
            name: "mapbox.access_token";
            value: "pk.eyJ1Ijoia2J1OTk5OSIsImEiOiJod0x1bnFrIn0.hzVSMJFGGDVnRI-PaRMO3w"
        }
        PluginParameter { name: "mapbox.map_id"; value: "kbu9999.i6gi9klm" }
        PluginParameter { name: "mapbox.format"; value: "jpg70" }
    }

    Instantiator {
        id: gModel
        model: 0

        /*MapCircle {
            color: "red"
            center: QtPositioning.coordinate(lat, lon)
            radius: 100
        }//*/

        onObjectAdded:   mapView.addMapItem(object)
        onObjectRemoved: mapView.removeMapItem(object)
    }

    function fitViewPortAlquiler() {
        var obj = MainHandler.alquiler
        if (!obj) return;

        if (obj.destino_gps != "" && obj.origen_gps != "")
            map.fitViewportToMapItems()
    }


    MapQuickItem {
        id: mqo

        anchorPoint.x: sourceItem.width/2
        anchorPoint.y: sourceItem.height
        coordinate: MainHandler.alquiler.origen_gps
        sourceItem:  Image {
            source: "../../assets/icons/flag-blue.png"
            opacity: mao.drag.active? 0.6 : 1

            MouseArea {
                id: mao
                anchors.fill: parent
                drag.target: mqo

                onPressed: map.gesture.enabled = false
                onReleased: {
                    map.gesture.enabled = true;
                    if (MainHandler.alquiler)
                        MainHandler.alquiler.origen_gps = mqo.coordinate
                }
            }
        }

    }

    MapQuickItem {
        id: mqd

        anchorPoint.x: sourceItem.width/2
        anchorPoint.y: sourceItem.height
        coordinate: MainHandler.alquiler.destino_gps
        sourceItem:  Image {
            source: "../../assets/icons/flag-red.png"
            opacity: mad.drag.active? 0.6 : 1

            MouseArea {
                id: mad
                anchors.fill: parent
                drag.target: mqd

                onPressed: map.gesture.enabled = false
                onReleased: {
                    map.gesture.enabled = true;
                    if (MainHandler.alquiler)
                        MainHandler.alquiler.destino_gps = mqd.coordinate
                }
            }
        }

    }
}
