import QtQuick 2.0
import OrmQuick 1.0
import QtPositioning 5.0

import "Meta"

OrmObject {
    id: main
    metaTable: MetaCliente
    
    property int idCliente 
    property double telefono 
    property string nombre 
    property string direccion 
    property string descripcion 
    property string gps
    property var coordinate: QtPositioning.coordinate()

    function setGps(coord) {
        gps = coord.latitude.toFixed(6) + ", " + coord.longitude.toFixed(6)
    }

    onGpsChanged: {
        var l = gps.split(',')
        if (l.length < 2) {
            coordinate = QtPositioning.coordinate()
            return;
        }

        coordinate = QtPositioning.coordinate(l[0], l[1])
    }
    
    //onLoaded: { }
}
