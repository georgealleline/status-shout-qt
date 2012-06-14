/**
 * Copyright (c) 2012 Nokia Corporation.
 */

import QtQuick 1.1
import com.nokia.symbian 1.1
import SocialConnect 0.1

Page {
    id: launchWizardPage

    property PageStack pageStack
    property WebInterface webIf
    property TwitterConnection twitter
    property FacebookConnection facebook

    Text {
        id: titleText

        color: platformStyle.colorNormalLight
        width: parent.width * 2/3
        anchors {
            top: parent.top
            topMargin: 30
            horizontalCenter: parent.horizontalCenter
        }
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: platformStyle.fontSizeLarge
        font.family: "Impact"
        text: qsTr("Status Shout!")
    }

    Text {
        id: descriptionText

        color: platformStyle.colorNormalLight
        width: parent.width * 2/3
        anchors {
            top: titleText.bottom
            topMargin: 50
            horizontalCenter: parent.horizontalCenter
        }
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        font.pixelSize: platformStyle.fontSizeMedium
        text: qsTr("Hi! Looks like this is your first time here.\n\n"
                   + "To continue, please log in to Facebook, Twitter or both!")
    }

    Button {
        id: facebookButton

        anchors {
            top: descriptionText.bottom
            topMargin: 20
            horizontalCenter: parent.horizontalCenter
        }
        text: qsTr("Connect to Facebook")
        onClicked: {
            // TODO! Check the authenticate return value!
            facebook.authenticate();
        }
    }

    SocialMediaItem {
        id: facebookConnected

        visible: false  // Shown only, if connected.
        anchors {
            top: descriptionText.bottom
            topMargin: 20
            horizontalCenter: parent.horizontalCenter
        }
        userName: facebook.name
        imageSource: "gfx/f_logo.png"
    }

    Button {
        id: twitterButton

        anchors {
            top: facebookButton.bottom
            topMargin: 20
            horizontalCenter: parent.horizontalCenter
        }
        text: qsTr("Connect to Twitter")
        onClicked: {
            // TODO! Check the authenticate return value!
            twitter.authenticate();
        }
    }

    SocialMediaItem {
        id: twitterConnected

        visible: false  // Shown only, if connected.
        anchors {
            top: facebookButton.bottom
            topMargin: 20
            horizontalCenter: parent.horizontalCenter
        }
        userName: twitter.name
        imageSource: "gfx/t_logo.png"
    }

    Connections {
        target: twitter
        onAuthenticateCompleted: {
            if (success) {
                // Save the access token etc.
                twitter.storeCredentials();
                // Let the user continue!
                twitterButton.visible = false;
                twitterConnected.visible = true;
                continueButton.enabled = true;
            }
        }
    }

    Connections {
        target: facebook
        onAuthenticateCompleted: {
            if (success) {
                facebook.storeCredentials();
                facebookButton.visible = false;
                facebookConnected.visible = true;
                continueButton.enabled = true;
            }
        }
    }

    WebViewLoader {
        id: webViewLoader

        webIf: launchWizardPage.webIf
        anchors.fill: parent
    }

    tools: ToolBarLayout {
        ToolButton {
            iconSource: "toolbar-back"
            onClicked: Qt.quit()
        }

        ToolButton {
            id: continueButton
            enabled: false
            text: qsTr("Continue")
            onClicked: launchWizardPage.pageStack.pop()
        }
    }
}
