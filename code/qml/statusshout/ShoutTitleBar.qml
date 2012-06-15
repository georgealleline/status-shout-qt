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

    height: topBannerImg.height

    Image {
        id: topBannerImg

        width: parent.width
        source: "gfx/top_banner_bg.png"
    }

    Image {
        id: shoutToImg

        anchors {
            left: parent.left
            leftMargin: 10
            verticalCenter: parent.verticalCenter
        }
        source: "gfx/shout_logo.png"
    }

    // Facebook related images & switches / buttons.
    Image {
        id: fbImg

        anchors {
            right: facebook.authenticated ? fbSwitch.left : fbButton.left
            rightMargin: facebook.authenticated ? 0 : 5
            verticalCenter: parent.verticalCenter
        }
        width: 32
        height: 32
        opacity: fbSwitch.checked ? 1 : 0.5
        source: "gfx/f_logo.png"
    }

    Switch {
        id: fbSwitch

        anchors {
            right: twitterImg.left
            rightMargin: 10
            verticalCenter: parent.verticalCenter
        }
        visible: facebook.authenticated
        checked: true
    }

    Button {
        id: fbButton

        anchors {
            right: twitterImg.left
            rightMargin: 5
            verticalCenter: parent.verticalCenter
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
            right: twitter.authenticated ? twitterSwitch.left : twitterButton.left
            rightMargin: twitter.authenticated ? 0 : 5
            verticalCenter: parent.verticalCenter
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
            right: parent.right
            rightMargin: 10
            verticalCenter: parent.verticalCenter
        }
        checked: true
    }

    Button {
        id: twitterButton

        anchors {
            right: parent.right
            rightMargin: 5
            verticalCenter: parent.verticalCenter
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
