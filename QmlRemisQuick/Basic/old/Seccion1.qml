import QtQuick 2.0

Rectangle {
    id: rectangle1
    width: 100
    height: 100

    color: "#221e1c"

    Rectangle {
         width: parent.width
         height: 1
         color: "#2c2826"
    }

    Rectangle {
         width: parent.width
         height: 1
         anchors.bottom: parent.bottom

         color: "#171413"
    }
}
