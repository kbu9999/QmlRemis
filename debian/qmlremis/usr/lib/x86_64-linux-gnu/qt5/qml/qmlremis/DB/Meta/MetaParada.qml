pragma Singleton
import QtQuick 2.0
import OrmQuick 1.0

OrmMetaTable {
    table: "Parada"
    //database: "DBName"
    attributes:  [ 
        OrmMetaAttribute { property: 'idParada'; attribute: 'idParada';  index: 0  }, 
        OrmMetaAttribute { property: 'parada'; attribute: 'Parada';   }, 
        OrmMetaAttribute { property: 'gps'; attribute: 'gps_pos';   }
    ]
    relations: [
        OrmMetaRelation { relationTableName: "Movil"; property: "moviles"
                          query: "SELECT * FROM Movil WHERE idParada = :idParada ORDER BY added"}
    ] 
    
    url: "../Parada.qml"
}
