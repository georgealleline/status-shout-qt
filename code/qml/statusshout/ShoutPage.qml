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
        var tooLong = __checkCharLimit(message)

        if (titleBar.sendToTwitter && tooLong) {
            dlgLoader.sourceComponent = charCountExceededDlg;
            dlgLoader.item.open();
        } else {
            if (titleBar.sendToTwitter) {
                twitter.postMessage({"text": message});
                busyIndicatorLoader.loading = true;
            }

            if (titleBar.sendToFacebook) {
                facebook.postMessage({"text": message});
                busyIndicatorLoader.loading = true;
            }
        }
    }

    function __sendMessageCompleted(success) {
        busyIndicatorLoader.loading = false;
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

    function __checkCharLimit(text) {
        var charLimitExceeded = false;
        var maxCharCount = 140; // TODO: max limit should change, if there's a picture!
        var currentCharCount = maxCharCount - text.length;

        if (text.length > maxCharCount) {
            console.debug(qsTr("ALARM! Over %1 characters!").arg(maxCharCount));
            charCounter.color = "red";
            charLimitExceeded = true;
        } else {
            charCounter.color = "black";
        }

        charCounter.text = currentCharCount;
        return charLimitExceeded;
    }

    // Shout titlebar. Shows Switches to enable / disable sending status
    // update to different services.
    ShoutTitleBar {
        id: titleBar

        width: parent.width
        facebook: shoutPage.facebook
        twitter: shoutPage.twitter

        onConnectFacebook: {
            webViewLoader.setBusy();
            facebook.authenticate();
        }

        onConnectTwitter: {
            webViewLoader.setBusy();
            twitter.authenticate();
        }
    }

    // The status input text component. Wrapped inside a background image.
    Image {
        id: inputBackground

        anchors.top: titleBar.bottom
        width: parent.width
        source: cp_inPortrait ? "gfx/text_box_pattern.png"
                              : "gfx/text_box_pattern_landscape.png"

        TextEdit {
            id: shoutText

            anchors.fill: parent
            anchors.margins: 10
            width: parent.width
            wrapMode: TextEdit.WordWrap
            font.pixelSize: platformStyle.fontSizeLarge
            color: "black"

            onTextChanged: __checkCharLimit(text)
        }
    }

    CharCounter {
        id: charCounter

        anchors{
            right: parent.right
            bottom: titleBar.bottom
            bottomMargin: -(charCounter.height / 4)
        }

        opacity: titleBar.sendToTwitter ? 1 : 0
    }

    // Alternative multiline text input field, from QCC.
//    TextArea {
//        id: shoutText
//
//        anchors.top: titleBar.bottom
//        anchors.bottom: bottomBanner.top
//        width: parent.width
//    }

    Item {
        id: bottomBanner

        anchors {
            top: inputBackground.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

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
            id: charCountExceededDlg

            QueryDialog {
                property bool success: false

                anchors.centerIn: parent
                titleText: qsTr("Message too long!")
                message: qsTr("You are trying to send a message that exceeds "
                         + "Twitter's status update character count.\n\n")
                         + (titleBar.sendToFacebook
                          ? "You can select either to send the message only "
                            + " to Facebook, or return editing the message."
                          : "")

                acceptButtonText: titleBar.sendToFacebook ? qsTr("Send to FB") : undefined
                rejectButtonText: qsTr("Edit message")
                onAccepted: {
                    if (titleBar.sendToFacebook) {
                        facebook.postMessage({"text": shoutText.text});
                        dlgLoader.sourceComponent = undefined;
                        busyIndicatorLoader.loading = true;
                    }
                }
                onRejected: dlgLoader.sourceComponent = undefined;
            }
        }

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

    Loader {
        id: busyIndicatorLoader

        property bool loading: false

        anchors.fill: parent
        sourceComponent: loading ? busyIndicator : undefined

        Component {
            id: busyIndicator

            Rectangle {
                color: "black"
                opacity: 0.7

                BusyIndicator {
                    anchors.centerIn: parent
                    running: true
                    width: 100
                    height: 100
                }

                MouseArea {
                    // Capture all clicks outside.
                    anchors.fill: parent
                }
            }
        }
    }

    tools: ToolBarLayout {
        ToolButton {
            iconSource: "toolbar-back"
            onClicked: {
                if (webViewLoader.active) {
                    shoutPage.twitter.cancel();
                    shoutPage.facebook.cancel();
                    webViewLoader.unload();
                } else if (shoutText.text) {
                    dlgLoader.sourceComponent = exitConfirmationDlg;
                    dlgLoader.item.open();
                } else {
                    Qt.quit();
                }
            }
        }

        ToolButton {
            property bool sendEnabled:
                (titleBar.sendToTwitter || titleBar.sendToFacebook) && shoutText.text

            opacity: sendEnabled ? 1 : 0.3
            enabled: sendEnabled
            iconSource: "gfx/messaging.svg"
            onClicked: __sendMessage()
        }

        ToolButton {
            iconSource: "toolbar-menu"
            onClicked: mainMenu.open()
        }
    }
}
