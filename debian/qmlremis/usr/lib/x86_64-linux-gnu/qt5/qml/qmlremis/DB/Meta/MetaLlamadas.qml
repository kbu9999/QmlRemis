pragma Singleton
import QtQuick 2.0
import OrmQuick 1.0

OrmMetaTable {
    table: "Llamadas"
    //database: "DBName"
    attributes:  [ 
        OrmMetaAttribute { property: 'idLlamadas'; attribute: 'idLlamadas';  index: 0  }, 
        OrmMetaForeignKey{ property: 'usuario'; attribute: 'idUsuario'; foreignTable: "sec_Usuario"; index: 1  },
        OrmMetaAttribute { property: 'fecha'; attribute: 'fecha';   }, 
        OrmMetaAttribute { property: 'telefono'; attribute: 'telefono';   }, 
        OrmMetaAttribute { property: 'duracion'; attribute: 'duracion';   }, 
        OrmMetaAttribute { property: 'estado'; attribute: 'estado';   }, 
        OrmMetaAttribute { property: 'grabacion'; attribute: 'grabacion';   } 
    ]

    url: "../Llamadas.qml"
}
