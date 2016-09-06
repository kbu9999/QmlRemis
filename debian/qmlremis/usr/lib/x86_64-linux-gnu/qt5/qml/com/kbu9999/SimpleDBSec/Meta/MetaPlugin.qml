pragma Singleton
import QtQuick 2.0
import OrmQuick 1.0

OrmMetaTable {
    table: "sec_Plugin"
    attributes:  [ 
        OrmMetaAttribute { property: 'idPlugin'; attribute: 'idPlugin';  index: 0  }, 
        OrmMetaAttribute { property: 'plugin'; attribute: 'Plugin';   }, 
        OrmMetaAttribute { property: 'autor'; attribute: 'autor';   }, 
        OrmMetaAttribute { property: 'email'; attribute: 'email';   }, 
        OrmMetaAttribute { property: 'key'; attribute: 'key';   } 
    ]
    relations: [
        OrmMetaRelation { relationTableName: "Sec_RolDetalle"; property: "roldetalle" }
    ] 
    
    url: "../Plugin.qml"
}
