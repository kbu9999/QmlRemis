import QtQuick 2.0
import QtQuick.Controls 1.3

TableViewColumn {
    id: tvc
    property Component editor

    delegate: Item {
        width: 60
        height: 30

        Text {
            id: tt1
            anchors.fill: parent
            //text: tvc.text
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            color: styleData.selected? "white" : "black"
            elide: Text.ElideRight
        }

        Loader {
            id: tf1
            anchors.fill: parent
            visible: !tt1.visible
            sourceComponent: tvc.editor

            property var styleData: parent.parent? parent.parent.styleData : undefined
            property alias showText: tt1.text

            function hideEditor() {
                tt1.visible = true
                if (tf1.item)
                    tf1.item.focus = false
            }
        }



        MouseArea {
            anchors.fill: parent
            onClicked: {
                __view.selection.clear();
                __view.selection.select(styleData.row)
            }
            onDoubleClicked: {
                tt1.visible = false
                tf1.item.forceActiveFocus()
            }
        }
    }

    Component.onDestruction: {
        editor = null
    }
}
