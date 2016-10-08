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
        coordinate = QtPositioning.coordinate(lat, lon)
    }

    onCoordinateChanged: {
        lat = coordinate.latitude
        lon = coordinate.longitude
    }
}
