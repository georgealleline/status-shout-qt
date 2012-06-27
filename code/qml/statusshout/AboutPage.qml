/**
 * Copyright (c) 2012 Nokia Corporation.
 */

import QtQuick 1.1
import com.nokia.symbian 1.1

Page {
    id: aboutPage

    property variant pageStack

    // Label for the application.
    Text {
        id: titleText

        anchors {
            top: parent.top
            topMargin: 10
            left: parent.left
            leftMargin: 4
        }

        font {
            bold: true
            pixelSize: platformStyle.fontSizeLarge
        }
        width: parent.width
        color: platformStyle.colorNormalLight
        horizontalAlignment: Text.AlignLeft
        text: qsTr("Status Shout!")
    }

    // Some about text & application information.
    Text {
        id: aboutText

        anchors {
            margins: 4
            left: parent.left
            right: parent.right
            top: titleText.bottom
        }
        color: platformStyle.colorNormalLight
        font.pixelSize: platformStyle.fontSizeMedium
        textFormat: Text.RichText
        wrapMode: Text.WordWrap
        text: qsTr("<p>Version: " + cp_versionNumber + "</p>" +
                   "<p>Status Shout! application is a Nokia Developer example " +
                   "demonstrating the use of the " +
                   "<a href=\"http://projects.developer.nokia.com/socialconnect/wiki\">" +
                   "Social Connect</a> QML Plugin. " +
                   "Currently supported social medias are Facebook and Twitter. " +
                   "<p>Developed and published by Nokia. All rights reserved.</p>" +
                   "<p>Learn more at " +
                   "<a href=\"http://projects.developer.nokia.com/statusshout\">" +
                   "developer.nokia.com</a>.</p>")

        onLinkActivated: Qt.openUrlExternally(link);
    }

    // ToolBarLayout for AboutPage
    tools: ToolBarLayout {
        id: aboutTools

        ToolButton {
            flat: true
            iconSource: "toolbar-back"
            onClicked: aboutPage.pageStack.pop()
        }
    }
}
