/**
 * Copyright (c) 2012 Nokia Corporation.
 */

import QtQuick 1.1
import com.nokia.symbian 1.1

Item {
    id: imageButton

    property alias source: imageButtonImg.source
    property alias text: imageButtonText.text

    signal clicked

    width: container.width + 8
    height: container.height + 8

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
        }

        Text {
            id: imageButtonText

            anchors {
                left: imageButtonImg.left
                top: imageButtonImg.bottom
            }
            color: platformStyle.colorNormalLight
            font.pixelSize: platformStyle.fontSizeMedium
            font.family: "Impact"
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
