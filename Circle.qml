import QtQuick 2.0

Rectangle {
    id: root

    property int d: 20
    property int centerX
    property int centerY
    x: centerX - d / 2
    y: centerY - d / 2
    width: d
    height: d
    radius: d / 2
}
