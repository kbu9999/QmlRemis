pragma Singleton
import QtQuick 2.0
import OrmQuick 1.0

OrmMetaTable {
    table: "Multas"
    //database: "DBName"
    attributes:  [
        OrmMetaAttribute { property: 'idMulta'; attribute: 'idMulta';  index: 0  },
        OrmMetaForeignKey{ property: 'idMovil'; attribute: 'idMovil'; foreignTable: "Movil"; index: 1  },
        OrmMetaForeignKey{ property: 'idUsuario'; attribute: 'idUsuario'; foreignTable: "sec_Usuario"; index: 2  },
        OrmMetaAttribute { property: 'inicio'; attribute: 'inicio';   },
        OrmMetaAttribute { property: 'fin'; attribute: 'fin';   }
    ]

    url: "../Movil.qml"
}

