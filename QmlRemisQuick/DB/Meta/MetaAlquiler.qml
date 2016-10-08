pragma Singleton
import QtQuick 2.0
import OrmQuick 1.0

OrmMetaTable {
    table: "Alquiler"
    //database: "DBName"
    attributes:  [ 
        OrmMetaAttribute { property: 'idAlquiler'; attribute: 'idAlquiler';  index: 0  }, 
        OrmMetaForeignKey{ property: 'movil'; attribute: 'idMovil'; foreignTable: "Movil"; index: 1  }, 
        OrmMetaForeignKey{ property: 'parada'; attribute: 'idParada'; foreignTable: "Parada"; index: 2  }, 
        OrmMetaForeignKey{ property: 'cliente'; attribute: 'idCliente'; foreignTable: "Cliente"; index: 3  }, 
        OrmMetaForeignKey{ property: 'llamadas'; attribute: 'idLlamadas'; foreignTable: "Llamadas"; index: 4  }, 
        OrmMetaAttribute { property: 'telefono'; attribute: 'telefono';   },
        OrmMetaAttribute { property: 'fecha'; attribute: 'fecha';   }, 
        OrmMetaAttribute { property: 'origen'; attribute: 'origen';   }, 
        OrmMetaAttribute { property: 'origen_lat'; attribute: 'origen_lat'; },
        OrmMetaAttribute { property: 'origen_lon'; attribute: 'origen_lon'; },
        OrmMetaAttribute { property: 'destino'; attribute: 'destino'; },
        OrmMetaAttribute { property: 'destino_lat'; attribute: 'destino_lat'; },
        OrmMetaAttribute { property: 'destino_lon'; attribute: 'destino_lon'; },
        OrmMetaAttribute { property: 'km'; attribute: 'km';   }, 
        OrmMetaAttribute { property: 'fechaAtencion'; attribute: 'fechaAtencion';   } 
    ]
    
    url: "../Alquiler.qml"
}
