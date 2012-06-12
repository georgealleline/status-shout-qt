/**
 * Copyright (c) 2012 Nokia Corporation.
 */

import QtQuick 1.1
import com.nokia.symbian 1.1
import SocialConnect 0.1

Page {
    id: shoutPage

    property PageStack pageStack
    property WebInterface webIf
    property TwitterConnection twitter
    property FacebookConnection facebook

    // Private functions
    function __sendMessage() {
        var message = shoutText.text;
        console.log("SEND, message: " + message);

        if (titleBar.sendToTwitter) {
            twitter.postMessage({"text": message});
        }
        if (titleBar.sendToFacebook) {
            facebook.postMessage({"text": message});
        }
    }

    // Shout titlebar. Shows Switches to enable / disable sending status
    // update to different services.
    ShoutTitleBar {
        id: titleBar

        width: parent.width
        facebook: shoutPage.facebook
        twitter: shoutPage.twitter

        onConnectFacebook: {
            webViewLoader.sourceComponent = webView;
            facebook.authenticate();
        }

        onConnectTwitter: {
            webViewLoader.sourceComponent = webView;
            twitter.authenticate();
        }
    }

    // The status input text component. Wrapped inside a background image.
    Image {
        anchors {
            top: titleBar.bottom
            bottom: bottomBanner.top
        }
        width: parent.width
        source: "gfx/text_box_pattern.png"

        TextEdit {
            id: shoutText

            anchors.fill: parent
            anchors.margins: 10
            width: parent.width
            wrapMode: Text.WordWrap
            font.pixelSize: platformStyle.fontSizeLarge
            color: "black"
        }
    }

    // Alternative multiline text input field, from QCC.
//    TextArea {
//        id: shoutText
//
//        anchors.top: titleBar.bottom
//        anchors.bottom: bottomBanner.top
//        width: parent.width
//    }

    Image {
        id: bottomBanner

        anchors {
            bottom: parent.bottom
            left: parent.left
        }
        source: "gfx/bottom_banner_bg.png"

        Item {
            anchors {
                verticalCenter: parent.verticalCenter
                left: parent.left
            }
            width: parent.width / 2

            ImageButton {
                id: cameraButton

                anchors.centerIn: parent
                source: "gfx/camera.png"
                text: qsTr("take a picture")
                onClicked: console.log("TAKE A PICTURE!")
            }
        }

        Item {
            anchors {
                verticalCenter: parent.verticalCenter
                right: parent.right
            }
            width: parent.width / 2

            ImageButton {
                id: galleryButton

                anchors.centerIn: parent
                source: "gfx/gallery.png"
                text: qsTr("+ from gallery")
                onClicked: console.log("SELECT FROM GALLERY!")
            }
        }
    }

    // Loader for the Web view to show the OAuth login.
    Loader {
        id: webViewLoader
        anchors.centerIn: parent
        width: parent.width * 4/5
        height: parent.height * 4/5

        Component {
            id: webView

            FlickableWebView {
                height: webViewLoader.height
                width: webViewLoader.width
                onUrlChanged: webIf.url = url   // TODO: NEEDED???
            }
        }
    }

    Connections {
        target: webIf

        onUrlChanged: {
            if (webViewLoader.item) {
                webViewLoader.item.url = url;
            }
        }
    }

    // Success/Failure signal handlers for posting the message to FB/Twitter.
    Connections {
        target: twitter

        onPostMessageCompleted: {
            if (success) {
                console.log("Posting message to Twitter completed!");
                shoutText.text = "";
            } else {
                console.log("Posting message to Twitter FAILED!");
            }
        }

        onAuthenticateCompleted: {
            webViewLoader.sourceComponent = undefined;
            if (success) {
                twitter.storeCredentials();
            }
        }
    }

    Connections {
        target: facebook

        onPostMessageCompleted: {
            if (success) {
                console.log("Posting message to Facebook completed!");
                shoutText.text = "";
            } else {
                console.log("Posting message to Facebook FAILED!");
            }
        }

        onAuthenticateCompleted: {
            webViewLoader.sourceComponent = undefined;
            if (success) {
                facebook.storeCredentials();
            }
        }
    }

    Menu {
        id: mainMenu
        // define the items in the menu and corresponding actions
        content: MenuLayout {
            MenuItem {
                text: "Accounts"
                onClicked: pageStack.push(accountsPageComp);
            }

            MenuItem {
                text: "About"
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("AboutPage.qml"), {pageStack: pageStack});
                }
            }
        }
    }

    Component {
        id: accountsPageComp

        AccountsPage {
            pageStack: shoutPage.pageStack
            webIf: shoutPage.webIf
            twitter: shoutPage.twitter
            facebook: shoutPage.facebook
        }
    }

    tools: ToolBarLayout {
        ToolButton {
            iconSource: "toolbar-back"
            onClicked: Qt.quit()
        }

        ToolButton {
            iconSource: "gfx/messaging.svg"
            onClicked: __sendMessage()
        }

        ToolButton {
            iconSource: "toolbar-menu"
            onClicked: mainMenu.open()
        }
    }
}
