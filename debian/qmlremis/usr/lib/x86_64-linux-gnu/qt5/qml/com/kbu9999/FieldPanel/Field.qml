import QtQuick 2.0

QtObject {
    property string title
    property url    editIcon
    property url    closeIcon
    property Component editorDelegate
    property Component showDelegate
    property string defaultText
    property int iconWidth: 16
    property int iconHeight: 16

    property string role

    property bool editMode: false
    readonly property bool editable: editorDelegate? true : false

    function hideEditor() { editMode = false }
}
