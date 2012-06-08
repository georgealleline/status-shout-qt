/**
 * Copyright (c) 2012 Nokia Corporation.
 */

import QtQuick 1.1
import com.nokia.symbian 1.1

ListItem {
    id: socialMediaItem

    width: childrenRect.width

    property bool __authenticated: model.modelData.authenticated
    property string __serviceName: model.modelData.serviceName
    property string __userName: model.modelData.userName
    property string __iconUrl: model.modelData.icon
    property variant __service: model.modelData.service

    Image {
        id: socialMediaIcon

        sourceSize.width: paddingItem.height
        sourceSize.height: paddingItem.height
        anchors {
            top: paddingItem.top
            left: paddingItem.left
        }
        source: __iconUrl
    }

    ListItemText {
        id: titleText

        anchors {
            left: socialMediaIcon.right
            leftMargin: 15
            top: __authenticated ? paddingItem.top : undefined
            verticalCenter: __authenticated ? undefined : parent.verticalCenter
        }
        role: "Title"
        color: platformStyle.colorNormalLight
        text:  __authenticated
               ? qsTr("Disconnect from ") + __serviceName
               : qsTr("Connect to ") + __serviceName
    }

    ListItemText {
        id: subtitleText

        visible: __authenticated
        anchors {
            left: socialMediaIcon.right
            leftMargin: 15
            bottom: paddingItem.bottom
        }
        role: "SubTitle"
        color: platformStyle.colorNormalLight
        text: qsTr("Connected as ") + __userName
    }
}
