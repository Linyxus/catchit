import QtQuick 2.7

Rectangle {
    id: root

    border.color: "#4885aa"
    color: "transparent"
    width: 150
    height: 50
    signal clicked

    Behavior on color {
        ColorAnimation {
            duration: 200
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            root.clicked()
        }
        onEntered: {
            root.color = "#4885aa"
            label.color = "white"
        }
        onExited: {
            root.color = "transparent"
            label.color = "#4885aa"
        }
    }

    Text {
        id: label
        text: "Restart"
        anchors.centerIn: parent
        font.pointSize: 15
        color: "#4885aa"
        Behavior on color {
            ColorAnimation {
                duration: 200
            }
        }
    }
}
