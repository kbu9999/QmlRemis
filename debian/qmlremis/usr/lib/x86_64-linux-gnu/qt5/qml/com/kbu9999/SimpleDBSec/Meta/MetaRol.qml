pragma Singleton
import QtQuick 2.0
import OrmQuick 1.0

OrmMetaTable {
    table: "sec_Rol"

    attributes:  [ 
        OrmMetaAttribute { property: 'idRol'; attribute: 'idRol';  index: 0  }, 
        OrmMetaAttribute { property: 'rol'; attribute: 'Rol';   } 
    ]
    relations: [
        OrmMetaRelation { relationTableName: "Sec_RolDetalle"; property: "roldetalle" }
    ] 
    
    url: "../Rol.qml"
}
