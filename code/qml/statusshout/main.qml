/**
 * Copyright (c) 2012 Nokia Corporation.
 */

import QtQuick 1.1
import com.nokia.symbian 1.1
import SocialConnect 0.1

Window {
    id: window

    // Define one "context property", to be used for checking
    // the current screen orientation.
    property bool cp_inPortrait: window.inPortrait

    Component.onCompleted: {
        // Try to restore the saved credentials
        twitterConnection.restoreCredentials();
        facebookConnection.restoreCredentials();

        // If none of the supported SoMe services proves to be authenticated,
        // present the LaunchWizardPage to the user.
        if (!facebookConnection.authenticated && !twitterConnection.authenticated) {
            pageStack.push(Qt.resolvedUrl("LaunchWizardPage.qml"),
                          {pageStack: pageStack,
                           facebook: facebookConnection,
                           twitter: twitterConnection,
                           webIf: webInterface});
        } else {
            pageStack.push(Qt.resolvedUrl("ShoutPage.qml"),
                          {pageStack: pageStack,
                           facebook: facebookConnection,
                           twitter: twitterConnection,
                           webIf: webInterface});
        }
    }

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
        source: cp_inPortrait ? "gfx/background.png" : "gfx/background_landscape.png"
    }

    PageStack {
        id: pageStack

        anchors {
            top: statusbar.bottom
            bottom: toolbar.top
            left: parent.left
            right: parent.right
        }
        toolBar: toolbar
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

        onAuthenticateCompleted: console.debug("TWITTER onAuthenticateCompleted! Success: " + success)
    }

    FacebookConnection {
        id: facebookConnection

        webInterface: webInterface
        permissions: ["publish_stream", "read_stream", "friends_status"]
        clientId: "399096860123557"

        onAuthenticateCompleted: console.debug("FACEBOOK onAuthenticateCompleted! Success: " + success)
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
