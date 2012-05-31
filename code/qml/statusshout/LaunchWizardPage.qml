import QtQuick 1.1
import com.nokia.symbian 1.1

Page {
    id: launchWizardPage

    property PageStack pageStack

    Text {
        id: titleText

        color: platformStyle.colorNormalLight
        width: parent.width * 2/3
        anchors {
            top: parent.top
            topMargin: 30
            horizontalCenter: parent.horizontalCenter
        }
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: platformStyle.fontSizeLarge
        text: qsTr("Status Shout!")
    }

    Text {
        id: descriptionText

        color: platformStyle.colorNormalLight
        width: parent.width * 2/3
        anchors {
            top: titleText.bottom
            topMargin: 50
            horizontalCenter: parent.horizontalCenter
        }
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        font.pixelSize: platformStyle.fontSizeMedium
        text: qsTr("Hi! Looks like this is your first time here.\n\n"
                   + "To continue, please log in to Facebook, Twitter or both!")
    }

//    Button {
//        id: facebookButton

//        anchors {
//            top: descriptionText.bottom
//            topMargin: 20
//            horizontalCenter: parent.horizontalCenter
//        }
//        text: qsTr("Connect to Facebook")
//        onClicked: console.log("Connecting to Facebook...")
//    }

    SocialMediaItem {
        id: facebookButton

        anchors {
            top: descriptionText.bottom
            topMargin: 20
            horizontalCenter: parent.horizontalCenter
        }
        userName: "Heikki Hämäläinen"
        imageSource: "gfx/f_logo.png"
    }

    Button {
        id: twitterButton

        anchors {
            top: facebookButton.bottom
            topMargin: 20
            horizontalCenter: parent.horizontalCenter
        }
        text: qsTr("Connect to Twitter")
        onClicked: console.log("Connecting to Twitter...")
    }

    tools: ToolBarLayout {
        ToolButton {
            iconSource: "toolbar-back"
            onClicked: {
                console.log("Backing off Wizard.");
                launchWizardPage.pageStack.pop();
            }
        }

        ToolButton {
//            visible: isConnectedToSomething
            text: qsTr("Continue")
            onClicked: console.log("Continuing!")
        }
    }
}
