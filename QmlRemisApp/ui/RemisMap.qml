import QtQuick 2.4
import QtPositioning 5.3
import QtLocation 5.3
import QtQuick.Controls 1.1

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
}
