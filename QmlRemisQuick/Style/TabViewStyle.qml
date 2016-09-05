import QtQuick 2.0
import QtQuick.Controls.Styles 1.1

TabViewStyle {
    tabsAlignment: Qt.AlignHCenter

    frame: null
    tabBar: Rectangle {
        color: "#1c1817"
        implicitWidth: 100

        Rectangle {
            width: parent.width
            height: 2
            color: "#131010"
        }

        Rectangle {
            width: parent.width
            height: 2
            anchors.bottom: parent.bottom
            anchors.bottomMargin: -height

            color: "#262221"
        }
    }

    tab: Item {
        implicitWidth: 50
        implicitHeight: 50

        TextStyled {
            text: styleData.title
            anchors.fill: parent
            color: "white"
            horizontalAlignment: Text.AlignHCenter
        }

        Rectangle {
            color: "#dd4814"
            visible: styleData.selected
            height: 2
            width: parent.width
            y: 48
        }
    }
}
