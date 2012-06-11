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

        if (twitterSwitch.checked) {
            twitter.postMessage({"text": message});
        }
        if (fbSwitch.checked) {
            facebook.postMessage({"text": message});
        }
    }

    // Shout titlebar. Shows Switches to enable / disable sending status
    // update to different services.
    Item {
        id: titleBar

        width: parent.width
        height: topBannerImg.height

        Image {
            id: topBannerImg

            width: parent.width
            source: "gfx/top_banner_bg.png"
        }

        Image {
            id: shoutToImg

            anchors {
                left: parent.left
                leftMargin: 10
                verticalCenter: parent.verticalCenter
            }
            source: "gfx/shout_logo.png"
        }

//        Text {
//            id: shoutTitle
//
//            anchors {
//                left: parent.left
//                leftMargin: 10
//                verticalCenter: parent.verticalCenter
//            }
//            color: platformStyle.colorNormalLight
//            font.pixelSize: platformStyle.fontSizeMedium
//            text: qsTr("Shouting to")
//        }

        Image {
            id: fbImg

            anchors {
                right: fbSwitch.left
                verticalCenter: parent.verticalCenter
            }
            width: 32
            height: 32
            opacity: fbSwitch.checked ? 1 : 0.5
            source: "gfx/f_logo.png"
        }

        Switch {
            id: fbSwitch

            anchors {
                right: twitterImg.left
                rightMargin: 10
                verticalCenter: parent.verticalCenter
            }
            checked: true
        }

        Image {
            id: twitterImg

            anchors {
                right: twitterSwitch.left
                verticalCenter: parent.verticalCenter
            }
            width: 32
            height: 32
            opacity: twitterSwitch.checked ? 1 : 0.5
            source: "gfx/t_logo.png"
        }

        Switch {
            id: twitterSwitch

            anchors {
                right: parent.right
                rightMargin: 10
                verticalCenter: parent.verticalCenter
            }
            checked: true
        }
    }

    // The status input text component. Wrapped inside a white rectangle.
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

            Image {
                id: cameraImg

                anchors.centerIn: parent
                source: "gfx/camera.png"
            }

            Text {
                anchors {
                    left: cameraImg.left
                    top: cameraImg.bottom
                }
                color: platformStyle.colorNormalLight
                font.pixelSize: platformStyle.fontSizeMedium
                font.family: "Impact"
                text: qsTr("take a picture")
            }
        }

        Item {
            anchors {
                verticalCenter: parent.verticalCenter
                right: parent.right
            }
            width: parent.width / 2

            Image {
                id: galleryImg

                anchors.centerIn: parent
                source: "gfx/Gallery.png"
            }

            Text {
                anchors {
                    left: galleryImg.left
                    top: galleryImg.bottom
                }
                color: platformStyle.colorNormalLight
                font.pixelSize: platformStyle.fontSizeMedium
                font.family: "Impact"
                text: qsTr("+ from gallery")
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
