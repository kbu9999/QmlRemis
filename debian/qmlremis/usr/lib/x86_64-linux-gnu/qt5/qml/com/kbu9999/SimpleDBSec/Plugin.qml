import QtQuick 2.0
import OrmQuick 1.0

import "Meta"

OrmObject {
    id: main
    metaTable: MetaPlugin
    
    property int idPlugin 
    property string plugin 
    property string autor 
    property string email 
    property string key 
     
    property list<OrmObject> roldetalle
    
      
    function appendRolDetalle(add) {
        append(MetaRolDetalle, add);
    }
    function loadSec_RolDetalle() {
        loadRelation(MetaRolDetalle)
    }  
    
    //onLoaded: { }
}
