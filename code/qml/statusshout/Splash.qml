/**
 * Copyright (c) 2012 Nokia Corporation.
 */

import QtQuick 1.1

Item {
    id: splash

    property bool __portrait: height > width
    property bool isE6: height == 480

    anchors.fill: parent
    Image {
        anchors.fill: parent
        source: __portrait ? "gfx/splash_portrait.png"
                           : isE6 ? "gfx/splash_landscape_e6.png"
                                  : "gfx/splash_landscape.png"
    }
}
