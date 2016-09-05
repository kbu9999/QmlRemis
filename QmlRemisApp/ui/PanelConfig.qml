import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import Qt.labs.settings 1.0
import OrmQuick 1.0

import qmlremis.Style 1.0
import qmlremis.Basic 1.0
import qmlremis.DB.Meta 1.0

import com.kbu9999.FieldPanel 1.0
import com.kbu9999.SimpleDBSec.Meta 1.0

Item {
    id: item1
    width: 300
    height: 400

    Rectangle {
        anchors.fill: parent
        color: "#f3f3f3"
        opacity: 0.65
    }

    readonly property alias db: _db

    Component.onCompleted: {
        db.connect()
    }

    OrmDataBase {
        id: _db
        user: conf.db_user
        password: conf.db_pass
        database: conf.db_database
        host: conf.db_host

        tables: [
            MetaAlquiler,
            MetaCliente,
            MetaLlamadas,
            MetaMovil,
            MetaParada,
            MetaPlugin,
            MetaRol,
            MetaRolDetalle,
            MetaUsuario
        ]

        onConnectedChanged: if (connected) loginManager.login("admin", "admin")

        onError: console.log(error)
    }

    Settings {
        id: conf
        property string db_user
        property string db_pass
        property string db_host
        property string db_database
    }

    Component {
        id: tstyle
        TextFieldStyle {
            font.family: "BellGothic BT"
            textColor: "black"
        }
    }

    Panel {
        width: 300
        height: 300

        anchors.centerIn: parent

        ormObject: conf
        spacing: 20
        titleDelegate: TextStyled {
            text: styleData.title
            font.bold: true
        }
        showDelegate: TextStyled {
            text: styleData.value? styleData.value : ""
        }
        editIcon: "../assets/icons/document-edit.png"

        FieldTextEdit {
            title: "Usuario"
            role: "db_user"
            style: tstyle
        }

        FieldTextEdit {
            title: "Contraseña"
            role: "db_pass"
            echoMode: TextInput.Password
            style: tstyle

            showDelegate: TextStyled {
                text: "**********"
            }
        }

        FieldTextEdit {
            title: "Base de Datos"
            role: "db_database"
            style: tstyle
        }

        FieldTextEdit {
            title: "Host"
            role: "db_host"
            style: tstyle
        }

        Field {
            //title: ""
            showDelegate: Button {
                text: "Conectar"
                onClicked: db.connect()
            }
        }
    }

}
