import QtQuick 2.0
import OrmQuick 1.0

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
    property string origen_gps 
    property string destino 
    property string destino_gps 
    property int km 
    property date fechaAtencion 

    onClienteChanged: telefono = cliente.telefono

    //onLoaded: { }
}
