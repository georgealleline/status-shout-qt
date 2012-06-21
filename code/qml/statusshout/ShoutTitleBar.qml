/**
 * Copyright (c) 2012 Nokia Corporation.
 */

import QtQuick 1.1
import com.nokia.symbian 1.1
import SocialConnect 0.1

Item {
    id: titleBar

    property FacebookConnection facebook
    property TwitterConnection twitter

    property bool sendToTwitter: twitter.authenticated && twitterSwitch.checked
    property bool sendToFacebook: facebook.authenticated && fbSwitch.checked

    signal connectTwitter;
    signal connectFacebook;

    height: cp_inPortrait ? 120 : 56

    Image {
        id: shoutToImg

        anchors {
            left: parent.left
            leftMargin: 28
            top: parent.top
            topMargin: cp_inPortrait ? 15 : 12
        }
        source: "gfx/shout_logo.png"
    }

    // Facebook related images & switches / buttons.
    Image {
        id: fbImg

        anchors {
            left: cp_inPortrait ? parent.left : shoutToImg.right
            leftMargin: 13
            top: cp_inPortrait ? shoutToImg.bottom : parent.top
            topMargin: cp_inPortrait ? 15 : 12
        }
        width: 32
        height: 32
        opacity: fbSwitch.checked ? 1 : 0.5
        source: "gfx/f_logo.png"
    }

    Switch {
        id: fbSwitch

        anchors {
            left: fbImg.right
            leftMargin: 10
            verticalCenter: fbImg.verticalCenter
        }
        visible: facebook.authenticated
        checked: true
    }

    Button {
        id: fbButton

        anchors {
            left: fbImg.right
            leftMargin: 10
            verticalCenter: fbImg.verticalCenter
        }

        font {
            family: "Impact"
            pixelSize: platformStyle.fontSizeSmall
        }

        visible: !facebook.authenticated
        text: qsTr("Connect")
        onClicked: connectFacebook()
    }

    // Twitter related images & switches / buttons.
    Image {
        id: twitterImg

        anchors {
            left: fbSwitch.visible ? fbSwitch.right : fbButton.right
            leftMargin: 15
            verticalCenter: fbImg.verticalCenter
        }
        width: 32
        height: 32
        opacity: twitterSwitch.checked ? 1 : 0.5
        source: "gfx/t_logo.png"
    }

    Switch {
        id: twitterSwitch

        visible: twitter.authenticated
        anchors {
            left: twitterImg.right
            leftMargin: 10
            verticalCenter: fbImg.verticalCenter
        }
        checked: true
    }

    Button {
        id: twitterButton

        anchors {
            left: twitterImg.right
            leftMargin: 10
            verticalCenter: fbImg.verticalCenter
        }

        font {
            family: "Impact"
            pixelSize: platformStyle.fontSizeSmall
        }

        visible: !twitter.authenticated
        text: qsTr("Connect")
        onClicked: connectTwitter()
    }
}
