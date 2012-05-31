/**
 * Copyright (c) 2012 Nokia Corporation.
 */

import QtQuick 1.1

Item {
    id: splash

    property bool __portrait: height > width
    anchors.fill: parent
    Image {
        anchors.fill: parent
        source: __portrait ? "gfx/splash_portrait.png" : "gfx/splash_landscape.png"
    }
}
