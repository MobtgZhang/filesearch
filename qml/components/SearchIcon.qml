import QtQuick 2.15

Item {
    id: root
    implicitWidth: 22
    implicitHeight: 22

    property color color: "#4af0b4"

    property string _svgSource: {
        var c = color.toString()
        var svg = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="' + c + '" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>'
        return "data:image/svg+xml;utf8," + encodeURIComponent(svg)
    }

    Image {
        id: icon
        anchors.fill: parent
        source: root._svgSource
        sourceSize.width: width * 2
        sourceSize.height: height * 2
        fillMode: Image.PreserveAspectFit
        smooth: true
        mipmap: true
    }
}
