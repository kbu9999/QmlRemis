pragma Singleton
import QtQuick 2.0
import OrmQuick 1.0

OrmMetaTable {
    table: "sec_Usuario"

    attributes:  [ 
        OrmMetaAttribute { property: 'idUsuario'; attribute: 'idUsuario';  index: 0  }, 
        OrmMetaForeignKey{ property: 'rol'; attribute: 'idRol'; foreignTable: "sec_Rol"; index: 1  },
        OrmMetaAttribute { property: 'user'; attribute: 'user';   }, 
        OrmMetaAttribute { property: 'pass'; attribute: 'pass';   }, 
        OrmMetaAttribute { property: 'nombre'; attribute: 'Nombre';   }, 
        OrmMetaAttribute { property: 'apellido'; attribute: 'Apellido';   }, 
        OrmMetaAttribute { property: 'direccion'; attribute: 'Direccion';   }, 
        OrmMetaAttribute { property: 'telefono'; attribute: 'Telefono';   } 
    ]

    relations: [
        OrmMetaRelation  {
            property: 'plugins'; relationTableName: 'sec_Plugin'
            query: 'SELECT * FROM sec_RolDetalle NATURAL JOIN sec_Plugin WHERE idRol = :idRol'
        }
    ]

    sqlInsert: "INSERT INTO sec_RolDetalle (rol, user, pass, nombre, apellido, direccion, telefono)
                VALUE (:idRol, :user, md5(:pass), :nombre, :apellido, :direccion, :telefono);"
    
    url: "../Usuario.qml"
}
