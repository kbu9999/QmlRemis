import QtQuick 2.0
import OrmQuick 1.0

import "Meta"

OrmObject {
    id: main
    metaTable: MetaLlamadas
    
    property int idLlamadas 
    property OrmObject usuario
    property date fecha 
    property double telefono 
    property date duracion 
    property int estado //0 invalid, 1 llamando,2 contest, 3 finalizada, 4 error
    property string grabacion 

    readonly property string telstring: __parseTel(telefono)

    function llamando() {
        if (estado === 0 || estado === 4) estado = 1;
        else estado = 4
    }

    function contestar() {
        if (estado === 1) estado = 2;
        else estado = 4
    }

    function colgar() {
        if (estado === 2) estado = 3;
        else estado = 4
    }


    function __parseTel(tl) {
        var t = tl.toString();
        return "("+t.substring(0, 3)+") " + t.substring(3, 6)+ " - " + t.substring(6, t.length)
    }

    //onLoaded: { }
}
