import QtQuick 2.0
import OrmQuick 1.0

import "Meta"
//import Models 1.0

OrmObject {
    id: main
    metaTable: MetaParada
    
    property int idParada 
    property string parada 
    property string gps
     
    property list<OrmObject> moviles
    property bool __loaded: false
      
    function appendMovil(add) {
        if (!add) return;

        add.added = new Date()
        add.estado = 1
        add.ultimaPos = gps
        add.parada = this

        append(MetaMovil, add);
    }

    function removeMovil(movil) {
        for(var i in moviles) {
            if (moviles[i] === movil) {
                remove(MetaMovil, i)
                movil.added = new Date(undefined)
                return;
            }
        }
    }

    onMovilesChanged: {
        if (!__loaded) return
        //Service.paradaChanged(idParada)
    }

    function loadMovil() {
        if (__loaded) return;
        loadRelation(MetaMovil)
        __loaded = true
    }  
    
    onLoaded: {
        loadMovil()
    }
}
