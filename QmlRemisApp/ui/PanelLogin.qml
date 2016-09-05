import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import OrmQuick 1.0

import com.kbu9999.SimpleDBSec 1.0

import Models 1.0

Item {
    id: root

    property ListModel model

    readonly property alias loginManager: loginman

    LoginManager {
        id: loginman

        onLogged: {
            model.append({"title": "moviles"});
            //model.append({"title": "pendientes"});
            model.append({"title": "alquiler"});
            model.append({"title": "clientes"});

            //window.menu.
            root.visible = false
            root.focus = false
        }

        onLoose: {
            root.visible = true

            fUser.text = "";
            fPass.text  = ""
            fUser.forceActiveFocus();

            model.clear()
        }

        onError:  {
            fUser.text = "";
            fPass.text  = ""
            fUser.forceActiveFocus();
        }
    }

    Component.onCompleted: fUser.forceActiveFocus()

    Rectangle {
        anchors.fill: parent
        color: "#f3f3f3"
        opacity: 0.75
    }

    Rectangle {
        id: rectangle1
        color: "#211d1b"
        radius: 4
        clip: true

        width: 300
        height: 500

        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        Item {
            id: item2
            width: 270
            height: 140
            anchors.verticalCenterOffset: -10
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            TextField {
                id: fUser
                y: 30
                width: 221
                height: 30
                anchors.left: parent.left
                anchors.leftMargin: 40
                placeholderText: qsTr("Operador")

                onEditingFinished: {
                    fPass.focus = true
                    fPass.selectAll()
                }

                style: TextFieldStyle { textColor: "black" }
            }

            TextField {
                id: fPass
                y: 80
                width: 221
                height: 30
                anchors.left: parent.left
                anchors.leftMargin: 40
                placeholderText: qsTr("Contraseña")
                echoMode: TextInput.Password

                Keys.onReturnPressed: loginman.login(fUser.text, fPass.text)

                style: TextFieldStyle { textColor: "black" }
            }

            Image {
                id: image1
                x: 0
                width: 40
                height: 40
                anchors.verticalCenter: fUser.verticalCenter
                source: "../assets/icons/im-user-offline.png"
            }

            Image {
                id: image2
                x: 0
                width: 40
                height: 40
                anchors.verticalCenter: fPass.verticalCenter
                source: "../assets/icons/object-locked.png"
            }
        }
    }
}
