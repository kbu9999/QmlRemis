import QtQuick 2.0
import QtQuick.Controls 1.1
import QtLocation 5.0

import common.Style 1.0 as S

Item {
    property string title
    property bool inserted: false
    property ListModel tabs: ListModel { }
    property Item contentItem: undefined
    property alias data: tab.data
    property RemisMap map: window.map
    property bool split: false
    property bool inBar: true
    clip: true

    Accessible.name: "View"

    Component {
        id: tabStyle
        S.TabViewStyle { }
    }

    property TabView tabview: TabView {
        id: tab
        style: tabStyle

        onCurrentIndexChanged: {
            getTab(currentIndex).item.forceActiveFocus()
        }

        KeyNavigation.tab: contentItem
    }
}
