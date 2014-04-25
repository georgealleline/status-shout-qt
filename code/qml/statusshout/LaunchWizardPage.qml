/**
 * Copyright (c) 2012-2014 Microsoft Mobile.
 */

import QtQuick 1.1
import com.nokia.symbian 1.1
import SocialConnect 1.0

Page {
    id: launchWizardPage

    property PageStack pageStack

    property FacebookConnection facebook
    property TwitterConnection twitter
    property WebInterface webIf

    Label {
        id: titleText

        anchors {
            top: parent.top
            topMargin: cp_isE6 ? 15 : 30
            horizontalCenter: parent.horizontalCenter
        }
        width: parent.width * 0.8
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: platformStyle.fontSizeLarge
        font.family: "Impact"
        text: qsTr("Status Shout!")
    }

    Label {
        id: descriptionText

        anchors {
            top: titleText.bottom
            topMargin: 30
            horizontalCenter: parent.horizontalCenter
        }
        width: parent.width * 0.8
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
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
            busyIndicatorLoader.loading = true;
            // TODO! Check the authenticate return value!
            facebook.authenticate();
        }
    }

    SocialMediaItem {
        id: facebookConnected

        anchors {
            top: descriptionText.bottom
            topMargin: 20
            horizontalCenter: parent.horizontalCenter
        }
        visible: false  // Shown only, if connected.
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
            busyIndicatorLoader.loading = true;
            // TODO! Check the authenticate return value!
            twitter.authenticate();
        }
    }

    SocialMediaItem {
        id: twitterConnected

        anchors {
            top: facebookButton.bottom
            topMargin: 20
            horizontalCenter: parent.horizontalCenter
        }
        visible: false  // Shown only, if connected.
        userName: twitter.name
        imageSource: "gfx/t_logo.png"
    }

    Loader {
        id: busyIndicatorLoader

        property bool loading: false

        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: 50
        }
        sourceComponent: loading ? busyIndicator : undefined

        Component {
            id: busyIndicator

            BusyIndicator {
                running: true
                width: 100
                height: 100
            }
        }
    }

    WebViewLoader {
        id: webViewLoader

        webIf: launchWizardPage.webIf
        anchors.fill: parent
    }

    Connections {
        target: twitter

        onAuthenticateCompleted: {
            busyIndicatorLoader.loading = false;

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
            busyIndicatorLoader.loading = false;

            if (success) {
                facebook.storeCredentials();
                facebookButton.visible = false;
                facebookConnected.visible = true;
                continueButton.enabled = true;
            }
        }
    }

    tools: ToolBarLayout {
        ToolButton {
            iconSource: "toolbar-back"

            onClicked: {
                if (webViewLoader.active) {
                    busyIndicatorLoader.loading = false;
                    twitter.cancel();
                    facebook.cancel();
                } else {
                    Qt.quit()
                }
            }
        }

        ToolButton {
            id: continueButton

            enabled: false
            text: qsTr("Continue")

            onClicked: {
                pageStack.replace(Qt.resolvedUrl("ShoutPage.qml"),
                                 {pageStack: pageStack,
                                  webIf: webInterface,
                                  twitter: twitterConnection,
                                  facebook: facebookConnection});
            }
        }
    }
}
