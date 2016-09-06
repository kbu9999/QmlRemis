import QtQuick 2.0
import OrmQuick 1.0

import "Meta"

OrmObject {
    id: main
    metaTable: MetaRol
    
    property int idRol 
    property string rol 
     
    property list<OrmObject> roldetalle
      
    function appendRolDetalle(add) {
        append(MetaRolDetalle, add);
    }
    function loadRolDetalle() {
        loadRelation(MetaRolDetalle)
    }  

    
    //onLoaded: { }
}
