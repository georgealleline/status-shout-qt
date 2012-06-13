/**
 * Copyright (c) 2012 Nokia Corporation.
 */

import QtQuick 1.1
import com.nokia.symbian 1.1
import SocialConnect 0.1
import QtWebKit 1.0

// Loader for the Web view to show the OAuth login. This QML Element should
// used through the load() & unload() functions, whenever the WebView should be
// available / discarded.
Loader {
    id: webViewLoader

    // The WebInterface's url has to be bound to the web view's url
    // property for the SocialConnection client to work properly.
    // This property _MUST_ be set!
    property WebInterface webIf

    function load() {
        webViewLoader.sourceComponent = webView;
    }

    function unload() {
        webViewLoader.sourceComponent = undefined;
    }

    Connections {
        target: webIf

        onUrlChanged: {
            if (webViewLoader.item) {
                webViewLoader.item.url = url;
            }
        }
    }

    // The WebView is wrapped inside a Component, so that it wouldn't waste
    // memory all the time, and is created only when needed (and deleted when
    // there's no more need to show the login page).
    Component {
        id: webView

        Flickable {
            id: webFlickable

            property alias url: web.url

            contentHeight: web.height
            contentWidth: web.width
            flickableDirection: Flickable.VerticalFlick
            boundsBehavior: Flickable.StopAtBounds
            clip: true

            WebView {
                id: web

                preferredWidth: webViewLoader.width
                preferredHeight: webViewLoader.height
                onUrlChanged: webIf.url = url;

                Component.onDestruction: {
                    console.log("Deleting WebView");
                }
            }

            ScrollDecorator {
                flickableItem: webFlickable
            }
        }
    }
}
