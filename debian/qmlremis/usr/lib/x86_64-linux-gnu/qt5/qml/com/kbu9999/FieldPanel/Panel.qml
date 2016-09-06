import QtQuick 2.2
import QtQuick.Layouts 1.1

FocusScope {
    id: root

    property list<Field> __fields

    default property alias data : root.__fields
    property alias rowSpacing: grid.rowSpacing
    property alias columnSpacing: grid.columnSpacing
    property alias columns: grid.columns
    property int spacing: 5
    
    property QtObject ormObject: null
    property Component showDelegate: valDeleg
    property Component titleDelegate: txtDeleg
    property Component iconDelegate: icoDeleg

    property url editIcon
    property url closeIcon

    onEditIconChanged: {
        if (!closeIcon) closeIcon = editIcon
    }

    onActiveFocusChanged: {
        if(activeFocus)
            repEdit.itemAt(0).focus = true
    }

    Component {
        id: valDeleg
        Text {
            text: styleData.value? styleData.value : ""
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
            opacity: styleData.isCurrentIndex? 0.6 : 1.0
        }
    }

    Component {
        id: txtDeleg
        Text {
            text: styleData.title
            font.bold: true
            opacity: styleData.isCurrentIndex? 0.6 : 1.0
            verticalAlignment: Text.AlignVCenter
        }
    }
    
    Component {
        id: icoDeleg
        Image {
            source: styleData.editMode? styleData.closeIcon : styleData.editIcon
            sourceSize.width: styleData.iconWidth
            sourceSize.height: styleData.iconHeight
            visible: styleData.editable


            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (styleData.editMode) hideEditor()
                    else showEditor()
                }
            }
        }
    }

    GridLayout {
        id: grid

        columns: 1
        columnSpacing: 10
        anchors.fill: parent
        
        property int __cwtit: 0
        property int __cwed: 0

        Repeater {
            id: repEdit
            model: __fields
            
            delegate: FocusScope { 
                id: fsc
                activeFocusOnTab: true
                //Layout.fillWidth: true
                Layout.preferredWidth: 200
                
                onFocusChanged:  {
                    editMode = focus
                    if (focus && rowl.editor)
                        rowl.editor.forceActiveFocus()
                }
                Keys.onEscapePressed: editMode = false
                //Keys.onReturnPressed: editMode != editMode
                
                RowLayout {
                    id: rowl
                    spacing: root.spacing
                    readonly property alias editor: ldEdit.item 
                    anchors.fill: parent
                    
                    Loader {
                        id: ldTit
                        property QtObject styleData: QtObject {
                            property int row: index
                            readonly property alias isCurrentIndex: fsc.focus
                            readonly property string title: __fields[row].title
                        }
                        
                        sourceComponent: root.titleDelegate
                        
                        onItemChanged: {
                            grid.__cwtit = Math.max(grid.__cwtit, item.width)
                            binTit.target = item
                        }
                        
                        Binding {
                            id: binTit
                            property: "width"
                            value: grid.__cwtit
                        }
                    }
                    
                    Loader {
                        id: ldShow 
                        visible: !ldEdit.visible
                        property QtObject styleData: QtObject {
                            property int row: index
                            readonly property alias isCurrentIndex: fsc.focus
                            readonly property Field field: __fields[row]
                            readonly property var value: root.ormObject? root.ormObject[role] : undefined
                        }
                        
                        sourceComponent: showDelegate? showDelegate : root.showDelegate
                        
                        onItemChanged: {
                            grid.__cwed = Math.max(grid.__cwed, item.width)
                            binSh.target = item
                        }
                        
                        Binding {
                            id: binSh
                            property: "width"
                            value: grid.__cwed
                        }
                    }
                    
                    Loader {
                        id: ldEdit
                        visible: editMode && editorDelegate
                        
                        function hideEditor() {
                            editMode = false
                            repEdit.itemAt(index).forceActiveFocus()
                        }
                        function setValue(value){
                            if (!root.ormObject) return;
                            
                            root.ormObject[role] = value
                        }
                        
                        property QtObject styleData: QtObject {
                            property int row: index
                            readonly property Field field: __fields[row]
                            readonly property alias isCurrentIndex: fsc.focus
                            readonly property var value: root.ormObject? root.ormObject[role] : undefined
                            readonly property alias item: ldShow.item
                        }
                        
                        sourceComponent: editorDelegate
                        
                        onItemChanged: {
                            grid.__cwed = Math.max(grid.__cwed, item.width)
                            binEd.target = item
                        }
                        
                        Binding {
                            id: binEd
                            property: "width"
                            value: grid.__cwed
                        }
                    }
                    
                    Loader {
                        property QtObject styleData: QtObject {
                            property int row: index
                            readonly property alias isCurrentIndex: fsc.focus
                            readonly property bool editMode: __fields[row].editMode
                            readonly property bool editable: __fields[row].editable
                            readonly property int iconWidth: __fields[row].iconWidth
                            readonly property int iconHeight: __fields[row].iconHeight
                            readonly property url editIcon: __fields[row].editIcon === ""? __fields[row].editIcon : root.editIcon
                            readonly property url closeIcon: __fields[row].closeIcon === ""? __fields[row].closeIcon :
                                                                 (root.closeIcon? root.closeIcon : editIcon)
                        }

                        function hideEditor() {
                            editMode = false
                        }
                        function showEditor() {
                            editMode = true
                            repEdit.itemAt(index).focus = true
                        }

                        sourceComponent: root.iconDelegate
                    }


                }  
            }
        }

        //Item { Layout.fillHeight: true }
    }
}
