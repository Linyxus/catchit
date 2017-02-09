import QtQuick 2.7
import QtQuick.Window 2.2

Window {
    id: wd
    visible: true
    width: 640
    height: 480
    maximumHeight: height
    maximumWidth: width
    minimumHeight: height
    minimumWidth: width
    title: qsTr("Catch It!")

    Rectangle {
        id: root

        anchors.fill: parent

        SequentialAnimation {
            id: startAnimation

            PauseAnimation {
                duration: 850
            }

            ScriptAction {
                script: {
                    startBtn.visible = false
                    startView.opacity = 0.0
                    startAnimator.x = 310; startAnimator.y = 230
                    startAnimator.visible = true
                }
            }

            ParallelAnimation {
                NumberAnimation {
                    target: startAnimator
                    property: "x"
                    duration: 100
                    to: 305
                    easing.type: Easing.InCirc
                }

                NumberAnimation {
                    target: startAnimator
                    property: "y"
                    duration: 100
                    to: 225
                    easing.type: Easing.InCirc
                }
            }

            ScriptAction {
                script: {
                    startAnimator.visible = false
                    it.visible = true
                    manager.setItPos(it.row, it.col)
                    startView.visible = false
                    gameView.addable = true
                }
            }
        }

        Rectangle {
            id: gameView

            anchors.centerIn: parent
            width: 470; height: 470
            property int cols: 11
            property bool addable: false

            Grid {
                columns: gameView.cols
                spacing: -1
                Repeater {
                    model: gameView.cols * gameView.cols
                    Rectangle {
                        width: gameView.width / gameView.cols
                        height: gameView.height / gameView.cols
                        color: "transparent"
                        border.width: 1
                        border.color: "#6897d9"
                        clip: true

                        Circle {
                            id: addAnimator

                            color: "#4e62c4"
                            d: 0

                            Behavior on d {
                                NumberAnimation {
                                    duration: 300
                                    easing.type: Easing.InCirc
                                }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                var r = Math.floor(index / 11)
                                var c = index % 11
                                if (!gameView.addable) return
                                if (!manager.check(r, c)) return
                                manager.add(r, c)
                                addAnimator.centerX = mouse.x
                                addAnimator.centerY = mouse.y
                                addAnimator.d = 120

                                r = manager.getNextRow()
                                c = manager.getNextCol()
                                console.log(r, c)
                                if (r == -1) { //win
                                    endLabel.text = "You win!"
                                    endAnimation.start()
                                } else if (r == -2) { //lose
                                    endLabel.text = "Sorry, you lose!"
                                    endAnimation.start()
                                } else {
                                    it.row = r
                                    it.col = c
                                }
                            }
                        }
                    }
                }
            }

            Rectangle {
                id: it

                color: "#204a93"
                width: 20; height: width
                property int row: 5
                property int col: 5
                y: (row + 0.5) * gameView.width / gameView.cols - it.width / 2 - row
                x: (col + 0.5) * gameView.width / gameView.cols - it.height / 2 - col
                visible: false

                Behavior on x {
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.OutCirc
                    }
                }

                Behavior on y {
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.OutCirc
                    }
                }
            }
        }

        Rectangle {
            id: startView

            anchors.fill: parent
            opacity: 1.0

            Behavior on opacity {
                NumberAnimation {
                    duration: 300
                    easing.type: Easing.OutCirc
                }
            }

            StartButton {
                id: startBtn

                anchors.centerIn: parent
                onClicked: {
                    startAnimation.start()
                }
            }
        }
    }

    Rectangle {
        id: startAnimator
        //305, 225
        //310, 230

        color: "#204a93"
        width: 20; height: width
        x: 310; y: 230
        visible: false
    }

    Circle {
        id: endView

        SequentialAnimation {
            id: endAnimation

            ScriptAction {
                script: {
                    var dx = Math.abs(endView.x - root.width / 2) + root.width / 2
                    var dy = Math.abs(endView.y - root.height / 2) + root.height / 2
                    endView.d = Math.sqrt(dx * dx + dy * dy) * 2
                }
            }

            PauseAnimation {
                duration: 500
            }

            ScriptAction {
                script: {
                    //anc.visible = true
                }
            }
        }
        clip: true

        centerX: gameView.x + it.x + it.width / 2
        centerY: gameView.y + it.y + it.height / 2
        color: "white"
        opacity: 0.8
        d: 0

        Behavior on d {
            NumberAnimation {
                duration: 600
                easing.type: Easing.InQuad
            }
        }

        Rectangle {
            id: anc
            x: -endView.x
            y: -endView.y - 50
            width: wd.width
            height: wd.height
            color: "transparent"
            visible: true
//            Behavior on y {
//                NumberAnimation {
//                    duration: 200
//                    easing.type: Easing.OutCirc
//                }
//            }

            Text {
                id: endLabel

                anchors.centerIn: parent
                font.pointSize: 25
                Behavior on y {
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.OutCirc
                    }
                }
            }

            RestartButton {
                id: restartBtn
                anchors.top: endLabel.bottom
                anchors.horizontalCenter: endLabel.horizontalCenter
                anchors.margins: 30
                Behavior on y {
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.OutCirc
                    }
                }

                onClicked: {
                    manager.reload(gameView.cols)
                    wd.close()
                }
            }
        }
    }
}
