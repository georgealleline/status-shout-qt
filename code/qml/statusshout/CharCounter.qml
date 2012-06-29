/**
 * Copyright (c) 2012 Nokia Corporation.
 */

import QtQuick 1.1
import com.nokia.symbian 1.1

Image {
    property alias text: charCounterText.text
    property alias color: charCounterText.color

    source: "gfx/char_count_background.png"

    Label {
        id: charCounterText

        width: parent.width
        height: parent.height
        anchors {
            top: parent.top
            topMargin: cp_isE6 ? 3 : 10
            horizontalCenter: parent.horizontalCenter
        }

        text: qsTr("140")
        font.pixelSize: platformStyle.fontSizeLarge
        color: "black"
        horizontalAlignment: Text.AlignHCenter
    }

    Behavior on opacity {
        NumberAnimation { duration: 150 }
    }
}
