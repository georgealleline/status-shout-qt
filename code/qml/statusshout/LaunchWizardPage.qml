/**
 * Copyright (c) 2012 Nokia Corporation.
 */

import QtQuick 1.1
import com.nokia.symbian 1.1
import QtWebKit 1.0
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
            webViewLoader.sourceComponent = webView;
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
            webViewLoader.sourceComponent = webView;
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
        target: webIf

        onUrlChanged: {
            console.log("webIf URL changed to: " + url)
            if (webViewLoader.item) {
                webViewLoader.item.url = url;
            }
        }
    }

    Connections {
        target: twitter
        onAuthenticateCompleted: {
            webViewLoader.sourceComponent = undefined;
            if (success) {
                twitterButton.visible = false;
                twitterConnected.visible = true;
                continueButton.enabled = true;
            }
        }
    }

    Connections {
        target: facebook
        onAuthenticateCompleted: {
            webViewLoader.sourceComponent = undefined;
            if (success) {
                facebookButton.visible = false;
                facebookConnected.visible = true;
                continueButton.enabled = true;
            }
        }
    }

    Loader {
        id: webViewLoader
        anchors.centerIn: parent
        width: parent.width * 4/5
        height: parent.height * 4/5
    }

    // WebView to show the OAuth login, if needed.
    Component {
        id: webView

        Flickable {
            id: webFlickable

            property alias url: web.url

            height: webViewLoader.height
            width: webViewLoader.width
            contentHeight: web.height
            contentWidth: childrenRect.width
            flickableDirection: Flickable.VerticalFlick
            boundsBehavior: Flickable.StopAtBounds
            clip: true

            WebView {
                id: web

                preferredWidth: webViewLoader.width
                preferredHeight: webViewLoader.height
                onUrlChanged: webIf.url = url;

                Component.onDestruction: {
                    console.log("QML: Storing credentials, was authenticated: "
                                + twitterConnection.authenticated)
                    twitterConnection.storeCredentials();
                }
            }

            ScrollDecorator {
                flickableItem: webFlickable
            }
        }
    }

    tools: ToolBarLayout {
        ToolButton {
            iconSource: "toolbar-back"
            onClicked: {
                Qt.quit();
            }
        }

        ToolButton {
            id: continueButton
//            visible: isConnectedToSomething ???
            enabled: false
            text: qsTr("Continue")
            onClicked: {
                launchWizardPage.pageStack.pop();
            }
        }
    }
}
