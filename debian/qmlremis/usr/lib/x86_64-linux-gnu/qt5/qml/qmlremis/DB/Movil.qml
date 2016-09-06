import QtQuick 2.0
import OrmQuick 1.0

import "Meta"

OrmObject {
    id: main
    metaTable: MetaMovil
    
    property int idMovil
    property Parada parada
    property string modelo: ""
    property string ultimaPos
    property int estado //0: out; 1: disponible; 2: ocupado; 3: multado
    property date added
    property date endMulta

    property date restante
    property bool __loaded: false
    signal finMulta()

    onEstadoChanged: {
        if (!__loaded || estado == 1) return;
        if (parada) {
            parada.removeMovil(main)
        }
        parada = null
    }

    onLoaded: {
        loadForeignKey(MetaParada)
        __loaded = true
    }

    function setParada(npar) {
        if (!npar) return;

        //parada = npar
        npar.appendMovil(this)
        save()
    }

    function libre() {
        estado = 2
        save()
    }

    function off() {
        estado = 0
        save()
    }
}
