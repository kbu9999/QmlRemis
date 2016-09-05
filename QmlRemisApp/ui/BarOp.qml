import QtQuick 2.0
import QtQuick.Controls 1.1

import qmlremis.Style 1.0 as S

Rectangle {
    id: root

    color: "#211d1b"
    radius: 4
    clip: true

    //default property alias data: tabs.data
    property TabView tabview: tabs

    Component {
        id: tabStyle
        S.TabViewStyle { }
    }

    Item {
        id: contentItem
        y: 50
        width: root.width
        height: 510

        TabView {
            id: tabs
            anchors.fill: parent

            style: tabStyle

            onCurrentIndexChanged: {
                getTab(currentIndex).item.focus = true
            }
        }
    }

    onTabviewChanged: {
        tabview.parent = contentItem
        tabview.anchors.fill = contentItem
        tabview.style = tabStyle
    }
}
