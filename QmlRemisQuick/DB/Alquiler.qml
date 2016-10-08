import QtQuick 2.0
import OrmQuick 1.0
import QtPositioning 5.0

import "Meta"

OrmObject {
    id: main
    metaTable: MetaAlquiler
    
    property int idAlquiler 
    property OrmObject movil 
    property OrmObject parada 
    property Cliente cliente
    property Llamadas llamadas
    property double telefono
    property date fecha
    property string origen
    property double origen_lat: Number.NaN
    property double origen_lon: Number.NaN
    property string destino
    property double destino_lat: Number.NaN
    property double destino_lon: Number.NaN
    property int km 
    property date fechaAtencion 

    property var origen_gps: QtPositioning.coordinate()
    property var destino_gps: QtPositioning.coordinate()

    onOrigen_gpsChanged: {
        origen_lat = origen_gps.latitude
        origen_lon = origen_gps.longitude
    }

    onDestino_gpsChanged: {
        destino_lat = destino_gps.latitude
        destino_lon = destino_gps.longitude
    }

    onClienteChanged: telefono = cliente.telefono

    onLoaded: {
        origen_gps = QtPositioning.coordinate(origen_lat, origen_lon)
        destino_gps = QtPositioning.coordinate(destino_lat, destino_lon)
    }
}
