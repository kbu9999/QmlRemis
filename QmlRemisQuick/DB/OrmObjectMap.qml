import QtQuick 2.0
import OrmQuick 1.0
import QtPositioning 5.0

OrmObject {

    property double lat: Number.NaN
    property double lon: Number.NaN

    //readonly property bool coordValid: lat && lon
    property var coordinate: QtPositioning.coordinate()
    readonly property bool coordValid: coordinate != ""

    onLoaded: {
        if (lon != 0 && lat != 0)
            coordinate = QtPositioning.coordinate(lat, lon)
        //console.log("ccord", coordinate, coordValid)
    }

    onCoordinateChanged: {
        lat = coordinate.latitude
        lon = coordinate.longitude
    }
}
