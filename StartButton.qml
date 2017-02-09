import QtQuick 2.7

Rectangle {
    id: root

    border.color: "#4885aa"
    color: "transparent"
    width: 150
    height: 50
    signal clicked
    clip: true

    SequentialAnimation {
        id: ani

        PauseAnimation {
            duration: 500
        }

        ScriptAction {
            script: {
                var a = 20
                root.width = a
                root.height = a
            }
        }
    }

    Behavior on color {
        ColorAnimation {
            duration: 200
        }
    }

    Behavior on width {
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutCirc
        }
    }

    Behavior on height {
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutCirc
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            root.clicked()
            var dx = Math.abs(mouse.x - root.width / 2) + root.width / 2
            var dy = Math.abs(mouse.y - root.height / 2) + root.height / 2
            console.log(dx, dy)
            var d = Math.sqrt(dx * dx + dy * dy) * 2
            console.log(d)
            animator.centerX = mouse.x
            animator.centerY = mouse.y
            animator.d = d
            ani.start()
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
        text: "Start"
        anchors.centerIn: parent
        font.pointSize: 15
        color: "#4885aa"
        Behavior on color {
            ColorAnimation {
                duration: 200
            }
        }
    }

    Circle {
        id: animator
        visible: true
        d: 0
        color: "#204a93"
        Behavior on d {
            NumberAnimation {
                duration: 400
                easing.type: Easing.InCirc
            }
        }
    }
}
