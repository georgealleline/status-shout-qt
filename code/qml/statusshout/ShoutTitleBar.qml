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

    property bool sendToTwitter: twitterSwitch.checked
    property bool sendToFacebook: fbSwitch.checked

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
            right: fbSwitch.left
            verticalCenter: parent.verticalCenter
        }
        width: 32
        height: 32
        visible: facebook.authenticated
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
            rightMargin: 10
            verticalCenter: parent.verticalCenter
        }

        font {
            family: "Impact"
            pixelSize: platformStyle.fontSizeSmall
        }

        visible: !facebook.authenticated
        iconSource: fbImg.source
        text: qsTr("Connect")
        onClicked: connectFacebook()
    }

    // Twitter related images & switches / buttons.
    Image {
        id: twitterImg

        anchors {
            right: twitterSwitch.left
            verticalCenter: parent.verticalCenter
        }
        width: 32
        height: 32
        visible: twitter.authenticated
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
            rightMargin: 10
            verticalCenter: parent.verticalCenter
        }

        font {
            family: "Impact"
            pixelSize: platformStyle.fontSizeSmall
        }

        visible: !twitter.authenticated
        iconSource: twitterImg.source
        text: qsTr("Connect")
        onClicked: connectTwitter()
    }
}
