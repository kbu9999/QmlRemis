pragma Singleton
import QtQuick 2.0
import OrmQuick 1.0

OrmMetaTable {
    table: "Movil"
    //database: "DBName"
    attributes:  [ 
        OrmMetaAttribute { property: 'idMovil'; attribute: 'idMovil';  index: 0  }, 
        OrmMetaForeignKey{ property: 'parada'; attribute: 'idParada'; foreignTable: "Parada"; index: 1  }, 
        OrmMetaAttribute { property: 'modelo'; attribute: 'modelo';   }, 
        OrmMetaAttribute { property: 'ultimaPos'; attribute: 'ultimaPos';   }, 
        OrmMetaAttribute { property: 'estado'; attribute: 'estado';   }, 
        OrmMetaAttribute { property: 'added'; attribute: 'added';   } 
    ]
    
    url: "../Movil.qml"
}
