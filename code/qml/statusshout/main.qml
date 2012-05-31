import QtQuick 1.1
import com.nokia.symbian 1.1
import SocialConnect 0.1

PageStackWindow {
    id: window

    initialPage: MainPage {tools: toolBarLayout}
    showStatusBar: true
    showToolBar: true

    Component.onCompleted: {
        pageStack.push(Qt.resolvedUrl("LaunchWizardPage.qml"), {pageStack: pageStack});
    }

    TwitterConnection {
        id: twitterConnection

        webInterface: webInterface
        consumerKey: "8X8HXL5PuNIPpuieYICVQ"
        consumerSecret: "GCJgN1mh4rtBjB8ZjDaOEoZ83hqbOyjufJThw50I"
        callbackUrl: "http://projects.developer.nokia.com/socialconnect"

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
