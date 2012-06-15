/**
 * Copyright (c) 2012 Nokia Corporation.
 */

import QtQuick 1.1
import com.nokia.symbian 1.1
import SocialConnect 0.1

Window {
    id: window

    StatusBar  {
        id: statusbar
        anchors.top: parent.top
    }

    ToolBar {
        id: toolbar
        anchors.bottom: parent.bottom
    }

    Image {
        anchors.fill: pageStack
        source: "gfx/background.png"
    }

    PageStack {
        id: pageStack

        toolBar: toolbar
        anchors {
            top: statusbar.bottom
            bottom: toolbar.top
            left: parent.left
            right: parent.right
        }
    }

    Component.onCompleted: {
        // Try to restore the saved credentials
        twitterConnection.restoreCredentials();
        facebookConnection.restoreCredentials();

        // If none of the supported SoMe services proves to be authenticated,
        // present the LaunchWizardPage to the user.
        if (!facebookConnection.authenticated && !twitterConnection.authenticated) {
            pageStack.push(Qt.resolvedUrl("LaunchWizardPage.qml"),
                          {pageStack: pageStack,
                           webIf: webInterface,
                           twitter: twitterConnection,
                           facebook: facebookConnection});
        } else {
            pageStack.push(Qt.resolvedUrl("ShoutPage.qml"),
                          {pageStack: pageStack,
                           webIf: webInterface,
                           twitter: twitterConnection,
                           facebook: facebookConnection});
        }
    }

    WebInterface {
        id: webInterface
    }

    TwitterConnection {
        id: twitterConnection

        webInterface: webInterface
        consumerKey: "8X8HXL5PuNIPpuieYICVQ"
        consumerSecret: "GCJgN1mh4rtBjB8ZjDaOEoZ83hqbOyjufJThw50I"
        callbackUrl: "http://projects.developer.nokia.com/statusshout"

        onAuthenticateCompleted: console.log("TWITTER onAuthenticateCompleted! Success: " + success)
    }

    FacebookConnection {
        id: facebookConnection

        webInterface: webInterface
        permissions: ["publish_stream", "read_stream", "friends_status"]
        clientId: "399096860123557"

        onAuthenticateCompleted: console.log("FACEBOOK onAuthenticateCompleted! Success: " + success)
    }

    ToolBarLayout {
        id: toolBarLayout
        ToolButton {
            flat: true
            iconSource: "toolbar-back"
            onClicked: window.pageStack.depth <= 1 ? Qt.quit() : window.pageStack.pop()
        }
    }
}
