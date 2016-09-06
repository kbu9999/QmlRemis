import QtQuick 2.0
import OrmQuick 1.0

import "Meta"

OrmObject {
    id: main
    metaTable: MetaUsuario
    
    property int idUsuario 
    property Rol rol
    property string user 
    property string pass 
    property string nombre 
    property string apellido 
    property string direccion 
    property string telefono 
    
    property list<Plugin> plugins

    function loadPlugins() {
        if (plugins.lenght > 0) return;

        loadRelation(MetaPlugin)
    }

    //onLoaded: { }
}
