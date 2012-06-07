/**
 * Copyright (c) 2012 Nokia Corporation.
 */

import QtQuick 1.1
import com.nokia.symbian 1.1
import SocialConnect 0.1

Page {
    id: shoutPage

    property PageStack pageStack
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
        height: parent.height / 10

        Text {
            id: shoutTitle

            anchors {
                left: parent.left
                leftMargin: 10
                verticalCenter: parent.verticalCenter
            }
            color: platformStyle.colorNormalLight
            font.pixelSize: platformStyle.fontSizeMedium
            text: qsTr("Shouting to")
        }

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

    TextArea {
        id: shoutText

        anchors.top: titleBar.bottom
        height: parent.height / 2
        width: parent.width
    }

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
                onClicked: console.log("Accounts menu item clicked!")
            }

            MenuItem {
                text: "About"
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("AboutPage.qml"), {pageStack: pageStack});
                }
            }
        }
    }

    tools: ToolBarLayout {
        ToolButton {
            iconSource: "toolbar-back"
            onClicked: {
                console.log("EXIT!");
                Qt.quit();
            }
        }

        ToolButton {
            id: shoutButton

            iconSource: "gfx/messaging.svg"
            onClicked: {
                __sendMessage();
            }
        }

        ToolButton {
            iconSource: "toolbar-menu"
            onClicked: {
                console.log("Open Menu!");
                mainMenu.open();
            }
        }
    }
}
