import QtQuick 2.2
import QtQuick.Controls 1.1


Item {
    id: item1
    width: 300
    height: 400

    Grid {
        width: 300
        height: 300
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        spacing: 20
        columns: 2

        verticalItemAlignment: Grid.AlignVCenter

        Text {
            id: luser
            x: 121
            y: 110
            text: "Usuario"
            font.bold: true
        }

        TextField {
            text: config.user

            onEditingFinished: config.user = text

            KeyNavigation.tab: fpass
        }

        Text {
            id: lpass
            x: 137
            y: 146
            text: "Contraseña"
            font.bold: true
        }

        TextField {
            id: fpass
            text: config.pass
            echoMode: TextInput.Password

            onEditingFinished: config.pass = text

            KeyNavigation.tab: fname
        }

        Text {
            id: lname
            x: 128
            y: 192
            text: "Nombre"
            font.bold: true
        }

        TextField {
            id: fname
            text: config.name

            onEditingFinished: config.name = text

            KeyNavigation.tab: fhost
        }

        Text {
            id: lhost
            x: 121
            y: 251
            text: "Host"
            font.bold: true
        }

        TextField{
            id: fhost
            text: config.host

            onEditingFinished: config.host = text

            KeyNavigation.tab: bcon
        }

        Button {
            id: bcon
            text: "Conectar"

            onClicked: db.connect()
        }

    }

}
