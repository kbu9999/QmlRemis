pragma Singleton
import QtQuick 2.0
import OrmQuick 1.0

OrmMetaTable {
    table: "Cliente"
    //database: "DBName"
    attributes:  [ 
        OrmMetaAttribute { property: 'idCliente'; attribute: 'idCliente';  index: 0  }, 
        OrmMetaAttribute { property: 'telefono'; attribute: 'telefono';  index: 1  }, 
        OrmMetaAttribute { property: 'nombre'; attribute: 'nombre';   }, 
        OrmMetaAttribute { property: 'direccion'; attribute: 'direccion';   }, 
        OrmMetaAttribute { property: 'descripcion'; attribute: 'descripcion';   }, 
        OrmMetaAttribute { property: 'gps'; attribute: 'gps_pos';   }
    ]

    url: "../Cliente.qml"
}
