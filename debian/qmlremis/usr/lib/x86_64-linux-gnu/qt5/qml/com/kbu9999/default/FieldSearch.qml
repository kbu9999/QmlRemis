import QtQuick 2.0
import QtQuick.Controls 1.1

Item {
    id: main
    property var value: ""
    property var model
    property var role: ""

    signal selected(var object)

    function editMode() {
        clId.visible = !clId.visible
        if (!clId.visible) {
            clField.selectAll()
            clField.focus = true
            if (clField.text.length == 0) clField.showall();
        }
    }

    width: clId.visible ? clId.width : clField.width
    height: clId.visible ? clId.height : clField.height

    Text {
        id: clId;
        text: main.value
        //anchors.verticalCenter: parent.verticalCenter
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
    }

    TextField {
        id: clField
        text: main.value
        //anchors.verticalCenter: parent.verticalCenter
        visible: !clId.visible

        ListModel {
            id: showModel
        }

        Keys.onEscapePressed: {
            if (list.height == 0) clId.visible = true;
            else list.height = 0
        }

        Keys.onReturnPressed: select(menu.currentIndex)

        Rectangle {
            id: list
            y: parent.height
            color: "white"
            width: parent.width
            height: parent.visible ? 80 : 0
            z: 1
            border.color: "#3eafea"
            border.width: 1
            radius: 5

            ListView {
                id: menu
                anchors.fill: parent
                anchors.margins: 5
                model: showModel

                delegate: Item {
                    //anchors.fill: txt

                    Rectangle {
                        id: rect
                        color: parent.ListView.isCurrentItem ? "#3eafea" : "transparent"
                        //color: "transparent"
                        anchors.fill: txt
                    }

                    Text {
                        id: txt
                        width: menu.width
                        text: texto
                        font.italic: true
                    }

                    MouseArea {
                        anchors.fill: txt
                        hoverEnabled: true

                        onExited: rect.color = "transparent"
                        onEntered: rect.color = "#3eafea"
                        onClicked: clField.select(index)
                    }
                }
            }

            Behavior on height { NumberAnimation { duration: 300 } }
        }

        function select(index) {
            var i = showModel.get(index).pos
            var o = main.model.at(i);
            if (!o) return;

            main.value = o[main.role];
            main.selected(o)
            clId.visible = true
        }

        function search(buscar) {
            showModel.clear()
            var regexp = new RegExp(buscar, "i")
            for(var i = 0; i < model.count(); i++)
            {
                var o = model.at(i);
                var dt = o[role];
                if (dt.match(regexp))
                    showModel.append({texto: dt, pos: i})
            }
        }

        function showall() {
            showModel.clear()
            for(var i = 0; i < model.count(); i++)
            {
                var o = model.at(i);
                var dt = o[role];
                showModel.append({texto: dt, pos: i})
            }
        }

        onTextChanged: {
            if (!visible) return;

            if (list.height == 0) list.height = 80;

            if (clField.text.length == 0) clField.showall();
            else search(clField.text)
        }
    }
}
