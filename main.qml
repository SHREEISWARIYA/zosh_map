// main.qml
import QtQuick
import QtQuick.Controls.Universal
import QtQuick.Layouts
import QtLocation
import QtPositioning
ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: "Person Model Example"
    Map{
        id:mapview
        anchors.fill:parent
        plugin: Plugin {
            name: "osm"
            // PluginParameter {
            //     // name: "osm.mapping.custom.host"
            //     // value: "http://localhost:8080/tiles/"
            // }
            PluginParameter { name: "osm.mapping.providersrepository.disabled"; value: false }

        }

        //plugin:osmview

        activeMapType: supportedMapTypes[supportedMapTypes.length - 1]
        center: QtPositioning.coordinate(latitude,longitute)
        minimumZoomLevel: 1
        maximumZoomLevel: 11
        zoomLevel: 5

        ListModel {
                id: shipModel
                ListElement { latitude: 21.3898; longitude: 87.0474 }  // Ship 1
                ListElement { latitude: 14.2411; longitude: 69.738 }  // Ship 2
                ListElement { latitude: 34.8151; longitude: -45.5364 }  // Ship 3
                // Add more ships as needed
        }

        // Use Repeater to create MapQuickItem for each ship
        Repeater {
                model: shipModel
                delegate: MapQuickItem {
                    coordinate: QtPositioning.coordinate(model.latitude, model.longitude)
                    anchorPoint.x: shipImage.width / 2
                    anchorPoint.y: shipImage.height / 2
                    sourceItem: Image {
                        id: shipImage
                        source: "qrc:/ship.png"  // Replace with the path to your ship image
                        width: 20  // Adjust size as needed
                        height: 20
                    }
                }
        }


        // Map Movement =============================================================================================================================

        property geoCoordinate startCentroid
        PinchHandler {
            id: pinch
            target: null
            onActiveChanged: if (active) {
                mapview.startCentroid = mapview.toCoordinate(pinch.centroid.position, false)
            }
            onScaleChanged: (delta) => {
                mapview.zoomLevel += Math.log2(delta)
                mapview.alignCoordinateToPoint(mapview.startCentroid, pinch.centroid.position)
            }
            onRotationChanged: (delta) => {
                mapview.bearing -= delta
                mapview.alignCoordinateToPoint(mapview.startCentroid, pinch.centroid.position)
            }
            grabPermissions: PointerHandler.TakeOverForbidden
        }
        WheelHandler {
            id: wheel
            acceptedDevices: Qt.platform.pluginName === "cocoa" || Qt.platform.pluginName === "wayland"
                             ? PointerDevice.Mouse | PointerDevice.TouchPad
                             : PointerDevice.Mouse
            rotationScale: 1/120
            property: "zoomLevel"
        }
        DragHandler {
            id: drag
            target: null
            onTranslationChanged: (delta) => mapview.pan(-delta.x, -delta.y)
        }
        Shortcut {
            enabled: mapview.zoomLevel < mapview.maximumZoomLevel
            sequence: StandardKey.ZoomIn
            onActivated: mapview.zoomLevel = Math.round(mapview.zoomLevel + 1)
        }
        Shortcut {
            enabled: mapview.zoomLevel > mapview.minimumZoomLevel
            sequence: StandardKey.ZoomOut
            onActivated: mapview.zoomLevel = Math.round(mapview.zoomLevel - 1)
        }

        MouseArea {
            anchors.fill: mapview
            hoverEnabled: true
            property var coordinate: mapview.toCoordinate(Qt.point(mouseX, mouseY))

            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onClicked : function(mouse){
                if(typeDraw == 0){
                    //console.log("nothing")
                }
                else if(typeDraw == 1){
                    pointspace.mapPointMark(mouse)
                }
                else if(typeDraw == 2){
                    //console.log("line")
                    linespace.mapLineMark(mouse)
                }
                else if(typeDraw == 3){
                    //console.log("polyon")
                    polygonspace.polygonMark(mouse)
                }
                else if(typeDraw == 4){
                    //console.log("circle")
                    circlespace.circleMark(mouse)
                }
                else{
                    console.log("invalid type")
                }
            }

            // onPositionChanged: function(mouse){
            //     if(typeDraw == 4){
            //         //console.log("circle")
            //         radiusSelector(mouse)
            //     }
            // }


            Label {
                id: coordLabel
                x: mapview.width - width
                y: mapview.height - height
                text: "lat: %1; lon: %2".arg(parent.coordinate.latitude).arg(parent.coordinate.longitude)
                color: "black"
                font {
                    pixelSize: 12
                }
                background: Rectangle {
                    color: "white"
                    opacity: 0.5
                }
            }
        }
    }

    //SIDEBAR
        Column {
            spacing: 10
            padding: 10
            anchors.top: parent.top
            anchors.topMargin: 40

            Button {
                width: 40
                height: 40
                background: Rectangle {
                    color: "#555"  // Background color
                    radius: 10  // Rounded corners
                    border.color: "#666"  // Subtle border
                    border.width: 1
                }
                contentItem: Image {
                    source: "qrc:/changetheme.png"
                    anchors.centerIn: parent
                    fillMode: Image.PreserveAspectFit
                }
                onClicked: {
                    // Change theme logic

                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        // Change theme logic
                        sidebar.changeValue(1);
                    }
                    onPressedChanged: {
                        if (pressed) {
                            parent.background.color = "#444"  // Darker on press
                        } else {
                            parent.background.color = "#555"  // Original color
                        }
                    }
                }
            }

            Button {
                width: 40
                height: 40
                background: Rectangle {
                    color: "#555"  // Background color
                    radius: 10  // Rounded corners
                    border.color: "#666"  // Subtle border
                    border.width: 1
                }
                contentItem: Image {
                    source: "qrc:/marker.png"
                    anchors.centerIn: parent
                    fillMode: Image.PreserveAspectFit
                }
                onClicked: {
                    // Marker logic

                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        // Marker logic
                        sidebar.changeValue(2);
                    }
                    onPressedChanged: {
                        if (pressed) {
                            parent.background.color = "#444"  // Darker on press
                        } else {
                            parent.background.color = "#555"  // Original color
                        }
                    }
                }
            }

            Button {
                width: 40
                height: 40
                background: Rectangle {
                    color: "#555"  // Background color
                    radius: 10  // Rounded corners
                    border.color: "#666"  // Subtle border
                    border.width: 1
                }
                contentItem: Image {
                    source: "qrc:/route.png"
                    anchors.centerIn: parent
                    fillMode: Image.PreserveAspectFit
                }
                onClicked: {
                    // Route logic

                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        // Route logic
                        sidebar.changeValue(3);
                    }
                    onPressedChanged: {
                        if (pressed) {
                            parent.background.color = "#444"  // Darker on press
                        } else {
                            parent.background.color = "#555"  // Original color
                        }
                    }
                }
            }

            Button {
                width: 40
                height: 40
                background: Rectangle {
                    color: "#555"  // Background color
                    radius: 10  // Rounded corners
                    border.color: "#666"  // Subtle border
                    border.width: 1
                }
                contentItem: Image {
                    source: "qrc:/settings.png"
                    anchors.centerIn: parent
                    fillMode: Image.PreserveAspectFit
                }
                onClicked: {
                    // Settings logic

                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        // Settings logic
                        sidebar.changeValue(4);
                    }
                    onPressedChanged: {
                        if (pressed) {
                            parent.background.color = "#444"  // Darker on press
                        } else {
                            parent.background.color = "#555"  // Original color
                        }
                    }
                }
            }

            Button {
                width: 40
                height: 40
                background: Rectangle {
                    color: "#555"  // Background color
                    radius: 10  // Rounded corners
                    border.color: "#666"  // Subtle border
                    border.width: 1
                }
                contentItem: Image {
                    source: "qrc:/help.png"
                    anchors.centerIn: parent
                    fillMode: Image.PreserveAspectFit
                }
                onClicked: {
                    // Help logic
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        // Help logic
                        sidebar.changeValue(5);
                    }
                    onPressedChanged: {
                        if (pressed) {
                            parent.background.color = "#444"  // Darker on press
                        } else {
                            parent.background.color = "#555"  // Original color
                        }
                    }
                }
            }
        }

        // Main Content Area (e.g., Map)
            Rectangle {
                id: mainContent
                anchors.right: parent.right
                anchors.left: sidebarContainer.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                color: "lightblue"
                // Add your main content here
            }

            // Message Display
            Text {
                id: messageDisplay
                text: ""
                anchors.centerIn: parent
                font.pixelSize: 20
            }

            // Connect C++ signal to QML slot
            Connections {
                target: sidebar
                onValueChanged: {
                    console.log("Value changed signal received:", s);
                    messageDisplay.text = s;
                }
            }


}
