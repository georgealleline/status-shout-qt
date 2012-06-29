/**
 * Copyright (c) 2012 Nokia Corporation.
 */

import QtQuick 1.1
import com.nokia.symbian 1.1
import SocialConnect 1.0

Page {
    id: accountsPage

    property PageStack pageStack

    property FacebookConnection facebook
    property TwitterConnection twitter
    property WebInterface webIf

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
    WebViewLoader {
        id: webViewLoader

        webIf: accountsPage.webIf
        anchors.fill: parent
    }

    Connections {
        target: twitter

        onAuthenticateCompleted: {
            console.debug("AccountsPage - Twitter Login success: " + success);

            if (success) {
                twitter.storeCredentials();
            }
        }
    }

    Connections {
        target: facebook

        onAuthenticateCompleted: {
            console.debug("AccountsPage - Facebook Login success: " + success);

            if (success) {
                facebook.storeCredentials();
            }
        }
    }

    Component {
        id: listDelegate

        SocialMediaListItem {
            width: accountsList.width

            onClicked: {
                if (__authenticated) {
                    __service.cancel();
                    __service.deauthenticate();
                    __service.removeCredentials();
                } else {
                    webViewLoader.setBusy();
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
                if (webViewLoader.active) {
                    // Make sure before backing, that all possible ongoing
                    // (authentication) requests are being cancelled.
                    accountsPage.twitter.cancel();
                    accountsPage.facebook.cancel();
                    webViewLoader.unload();
                } else {
                    accountsPage.pageStack.pop();
                }
            }
        }
    }
}
