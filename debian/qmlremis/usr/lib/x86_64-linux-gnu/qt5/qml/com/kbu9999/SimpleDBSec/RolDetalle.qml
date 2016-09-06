import QtQuick 2.0
import OrmQuick 1.0

import "Meta"

OrmObject {
    id: main
    metaTable: MetaRolDetalle
    
    property int idRolDetalle 
    property OrmObject rol
    property OrmObject splugin
    
    
    //onLoaded: { }
}
