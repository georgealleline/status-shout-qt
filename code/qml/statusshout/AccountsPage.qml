/**
 * Copyright (c) 2012 Nokia Corporation.
 */

import QtQuick 1.1
import com.nokia.symbian 1.1
import SocialConnect 0.1

Page {
    id: accountsPage

    property PageStack pageStack
    property WebInterface webIf
    property TwitterConnection twitter
    property FacebookConnection facebook

    // Internal ListModel for the Social Media accounts.
    property list<QtObject> __soMeModel: [
        QtObject {
            property variant service: facebook;
            property bool authenticated: facebook.authenticated;
            property string userName: facebook.name;
            property string serviceName: "Facebook";
            property string icon: "gfx/f_logo.png"; },
        QtObject {
            property variant service: twitter;
            property bool authenticated: twitter.authenticated;
            property string userName: twitter.name;
            property string serviceName: "Twitter";
            property string icon: "gfx/t_logo.png"; }
    ]

    // List the supported Social Medias.
    ListView {
        id: accountsList

        anchors.fill: parent
        clip: true
        model: __soMeModel
        delegate: listDelegate
        interactive: false

        ScrollDecorator {
            flickableItem: accountsList
        }
    }

    // Loader for the Web view to show the OAuth login.
    Loader {
        id: webViewLoader
        anchors.centerIn: parent
        width: parent.width * 4/5
        height: parent.height * 4/5
    }

    // The WebInterface url has to be bound to the web view's url
    // property for the SocialConnection client to work properly.
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
            console.log("AccountsPage - Twitter Login success: " + success);
            if (success) {
                twitter.storeCredentials();
            }
        }
    }

    Connections {
        target: facebook
        onAuthenticateCompleted: {
            webViewLoader.sourceComponent = undefined;
            console.log("AccountsPage - Facebook Login success: " + success);
            if (success) {
                facebook.storeCredentials();
            }
        }
    }

    Component {
        id: webView

        FlickableWebView {
            height: webViewLoader.height
            width: webViewLoader.width
        }
    }

    Component {
        id: listDelegate

        SocialMediaListItem {
            width: accountsList.width

            onClicked: {
                if (__authenticated) {
                    console.log("DE-AUTHENTICATE!");
                    __service.cancel();
                    __service.deauthenticate();
                    __service.removeCredentials();
                    webViewLoader.sourceComponent = undefined;
                } else {
                    console.log("AUTHENTICATE!");
                    webViewLoader.sourceComponent = webView;
                    // TODO! Check the authenticate return value!
                    __service.authenticate();
                }
            }
        }
    }

    tools: ToolBarLayout {
        ToolButton {
            iconSource: "toolbar-back"
            onClicked: {
                // Make sure, that all possible ongoing (authentication) requests
                // are being cancelled, before backing.
                twitter.cancel();
                facebook.cancel();
                // Remove the webview from eating up the scarse memory!
                webViewLoader.sourceComponent = undefined;
                accountsPage.pageStack.pop();
            }
        }
    }
}
