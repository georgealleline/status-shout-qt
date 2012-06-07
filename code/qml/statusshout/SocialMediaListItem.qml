/**
 * Copyright (c) 2012 Nokia Corporation.
 */

import QtQuick 1.1
import com.nokia.symbian 1.1

ListItem {
    id: socialMediaItem

    property bool isConnected: false
//    property alias imageSource: socialMediaIcon.source
//    property string userName: ""

    width: childrenRect.width

    Image {
        id: socialMediaIcon

        sourceSize.width: paddingItem.height
        sourceSize.height: paddingItem.height
        anchors {
            top: paddingItem.top
            left: paddingItem.left
        }
        source: model.icon
    }

    Column {
        anchors {
            left: socialMediaIcon.right
            leftMargin: 15
            top: paddingItem.top
            bottom: paddingItem.bottom
        }

        ListItemText {
            id: titleText

            role: "Title"
            color: platformStyle.colorNormalLight
            text: isConnected ? qsTr("Connect to " + model.name)
                              : qsTr("Disconnect from " + model.name)
        }

        ListItemText {
            id: subtitleText

            role: "SubTitle"
            color: platformStyle.colorNormalLight
//            font.pixelSize: platformStyle.fontSizeSmall
            text: qsTr("Connected as " + model.userName)
        }
    }
}
