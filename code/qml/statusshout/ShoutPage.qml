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

    function __sendMessageCompleted(success) {
        dlgLoader.sourceComponent = msgPostedDlg;
        dlgLoader.item.success = success;
        dlgLoader.item.open();
        if (success) {
            console.log("  Posting message completed!");
            shoutText.text = "";
        } else {
            console.log("  Posting message FAILED!");
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
            facebook.authenticate();
        }

        onConnectTwitter: {
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
                text: qsTr("+ new picture")
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
    WebViewLoader {
        id: webViewLoader

        webIf: shoutPage.webIf
        anchors.fill: parent
    }

    // Success/Failure signal handlers for posting the message to FB/Twitter.
    Connections {
        target: twitter

        onPostMessageCompleted: {
            console.log("Posting message to Twitter completed! Success: " + success);
            __sendMessageCompleted(success);
        }

        onAuthenticateCompleted: {
            if (success) {
                twitter.storeCredentials();
            }
        }
    }

    Connections {
        target: facebook

        onPostMessageCompleted: {
            console.log("Posting message to Facebook completed! Success: " + success);
            __sendMessageCompleted(success);
        }

        onAuthenticateCompleted: {
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

    Loader {
        id: dlgLoader
        anchors.centerIn: parent

        Component {
            id: msgPostedDlg

            QueryDialog {
                property bool success: false

                anchors.centerIn: parent
                titleText: success ? qsTr("Message sent!") : qsTr("Error")
                message: success ? qsTr("Shout message was sent successfully!\n")
                                 : qsTr("An error occured while trying to send "
                                        + "the shout. Please try again.\n")

                acceptButtonText: qsTr("Ok")
                onAccepted: dlgLoader.sourceComponent = undefined
            }
        }

        Component {
            id: exitConfirmationDlg

            QueryDialog {
                titleText: qsTr("You have unshouted messages!")
                message: qsTr("Do you really want to exit Status Shout? "
                              + "(The shout will be lost.)\n")

                acceptButtonText: qsTr("Yes")
                rejectButtonText: qsTr("No")

                onAccepted: Qt.quit()
                onRejected: dlgLoader.sourceComponent = undefined
            }
        }
    }

    tools: ToolBarLayout {
        ToolButton {
            iconSource: "toolbar-back"
            onClicked: {
                if (shoutText.text) {
                    dlgLoader.sourceComponent = exitConfirmationDlg;
                    dlgLoader.item.open();
                } else {
                    Qt.quit();
                }
            }
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
