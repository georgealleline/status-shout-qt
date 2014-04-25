/**
 * Copyright (c) 2012-2014 Microsoft Mobile.
 */

import QtQuick 1.1
import com.nokia.symbian 1.1

Item {
    id: imageButton

    property alias source: imageButtonImg.source
    property alias text: imageButtonText.text
    property alias fontSize: imageButtonText.font.pixelSize

    signal clicked

    width: container.width + 10
    height: container.height + 10

    BorderImage {
        id: highlight
        border { left: 20; top: 20; right: 20; bottom: 20 }
        opacity: 0
        anchors.fill: parent
        source: privateStyle.imagePath("qtg_fr_pushbutton_pressed", true)
    }

    Item {
        id: container

        anchors.centerIn: parent
        width: imageButtonImg.width
        height: childrenRect.height
        Image {
            id: imageButtonImg

            anchors.top: parent.top
            smooth: true
        }

        Text {
            id: imageButtonText

            anchors {
                horizontalCenter: parent.horizontalCenter
                top: imageButtonImg.bottom
                topMargin: 5
            }
            horizontalAlignment: Text.AlignHCenter
            color: platformStyle.colorNormalLight
            font.pixelSize: platformStyle.fontSizeLarge
            font.family: "Impact"
            smooth: true
        }
    }

    MouseArea  {
        id: ma

        anchors.fill: parent
        onClicked: imageButton.clicked()
    }

    states: State {
        name: "pressed"
        when: ma.pressed
        PropertyChanges { target: highlight; opacity: 0.80 }
        PropertyChanges { target: container; scale: 0.95 }
    }

    transitions: Transition {
        reversible: true

        ParallelAnimation {
            id: clickedEffect

            PropertyAnimation {
                target: container
                property: "scale"
                easing.type: Easing.Linear
                duration: 50
            }
            PropertyAnimation {
                target: highlight
                property: "opacity"
                easing.type: Easing.Linear
                duration: 100
            }
            ScriptAction {
                script: privateStyle.play(Symbian.BasicButton)
            }
        }
    }
}
