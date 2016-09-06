pragma Singleton
import QtQuick 2.0
import OrmQuick 1.0

OrmMetaTable {
    table: "sec_RolDetalle"

    attributes:  [ 
        OrmMetaAttribute { property: 'idRolDetalle'; attribute: 'idRolDetalle';  index: 0  }, 
        OrmMetaForeignKey{ property: 'rol'; attribute: 'idRol'; foreignTable: "sec_Rol"; index: 1  },
        OrmMetaForeignKey{ property: 'plugin'; attribute: 'idPlugin'; foreignTable: "sec_Plugin"; index: 2  }
    ]
    
    url: "../RolDetalle.qml"
}
