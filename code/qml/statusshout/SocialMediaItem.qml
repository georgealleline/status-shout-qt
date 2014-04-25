/**
 * Copyright (c) 2012-2014 Microsoft Mobile.
 */

import QtQuick 1.1

Item {
    id: socialMediaItem

    property alias imageSource: socialMediaIcon.source
    property string userName: ""

    width: childrenRect.width
    height: 32

    Image {
        id: socialMediaIcon

        sourceSize.width: parent.height
        sourceSize.height: parent.height
        anchors {
            left: parent.left
        }
    }

    Text {
        anchors {
            left: socialMediaIcon.right
            leftMargin: 15
            verticalCenter: socialMediaIcon.verticalCenter
        }
        color: platformStyle.colorNormalLight
        font.pixelSize: platformStyle.fontSizeSmall
        text: qsTr("Connected as ") + socialMediaItem.userName
    }
}
