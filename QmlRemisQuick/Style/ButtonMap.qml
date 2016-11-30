import QtQuick 2.0
import QtQuick.Controls 2.0

ButtonEdit {
    iconSource: "qrc:/assets/icons/world.png"

    property string  __oldstate
    property int setstate: 0
    property var __wstates: ["map_centro", "map_plug"]

    signal locate()

    onClicked: {
        if (window.state !== __wstates[setstate]) {
            __oldstate = window.state
            window.state = __wstates[setstate]
            locate()
        }
        else {
            window.state = __oldstate
            __oldstate = ""
        }
    }
}
