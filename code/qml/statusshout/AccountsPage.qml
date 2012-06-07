/**
 * Copyright (c) 2012 Nokia Corporation.
 */

import QtQuick 1.1
import com.nokia.symbian 1.1
import SocialConnect 0.1

Page {
    id: accountsPage

    property PageStack pageStack
    property WebInterface webIf
    property TwitterConnection twitter
    property FacebookConnection facebook

    ListView {
        id: accountsList

        anchors.fill: parent
        clip: true
        model: soMeModel
        delegate: listDelegate

        ScrollDecorator {
            flickableItem: accountsList
        }
    }

    ListModel {
        id: soMeModel
        ListElement {
            name: "Facebook"
            userName: "Sakari Östermalm" //facebook.name  Y U NO WORK!?!
            icon: "gfx/f_logo.png"
        }
        ListElement {
            name: "Twitter"
            userName: "FutuTwit" //twitter.name
            icon: "gfx/t_logo.png"
        }
    }

    Component {
        id: listDelegate

        SocialMediaListItem {
            width: accountsList.width
        }
    }

    tools: ToolBarLayout {
        ToolButton {
            iconSource: "toolbar-back"
            onClicked: accountsPage.pageStack.pop();
        }
    }
}
