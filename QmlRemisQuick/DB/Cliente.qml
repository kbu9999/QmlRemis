import QtQuick 2.0
import OrmQuick 1.0
import QtPositioning 5.0

import "Meta"

OrmObjectMap {
    id: main
    metaTable: MetaCliente
    
    property int idCliente 
    property double telefono 
    property string nombre 
    property string direccion 
    property string descripcion 
}
