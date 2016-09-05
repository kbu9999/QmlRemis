import QtQuick 2.0

Rectangle {
    id: rectangle1
    width: 100
    height: 100

    color: "#eeeeee"

    Rectangle {
         width: parent.width
         height: 1
         color: "#e2e2e2"
    }

    Rectangle {
         width: parent.width
         height: 1
         anchors.bottom: parent.bottom

         color: "#bebebe"
    }
}
