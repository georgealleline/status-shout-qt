/**
 * Copyright (c) 2012 Nokia Corporation.
 */

import QtQuick 1.1
import com.nokia.symbian 1.1
import SocialConnect 0.1

PageStackWindow {
    id: window

    showStatusBar: true
    showToolBar: true
    initialPage: ShoutPage {pageStack: pageStack;
                            twitter: twitterConnection;
                            facebook: facebookConnection}

    Component.onCompleted: {
        pageStack.push(Qt.resolvedUrl("LaunchWizardPage.qml"),
                       {pageStack: pageStack,
                        webIf: webInterface,
                        twitter: twitterConnection,
                        facebook: facebookConnection});
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

        onAuthenticateCompleted: console.log("TWITTER AUTHENTICATED!")
    }

    FacebookConnection {
        id: facebookConnection

        webInterface: webInterface
        permissions: ["publish_stream", "read_stream", "friends_status"]
        clientId: "399096860123557"

        onAuthenticateCompleted: console.log("FB AUTHENTICATED!")
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
