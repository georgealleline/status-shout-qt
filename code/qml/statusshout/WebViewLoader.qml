/**
 * Copyright (c) 2012 Nokia Corporation.
 */

import QtQuick 1.1
import com.nokia.symbian 1.1
import SocialConnect 0.1
import QtWebKit 1.0

// Loader for the Web view to show the OAuth login. The loader will handle
// creating / deleting the WebView automatically based on the WebInterface's
// demand (i.e. onActiveChanged).
Loader {
    id: webViewLoader

    // The WebInterface's url has to be bound to the web view's url
    // property for the SocialConnection client to work properly.
    // This property _MUST_ be set!
    property WebInterface webIf
    property bool active: false

    function load() {
        webViewLoader.active = true;
        webViewLoader.sourceComponent = webView;
    }

    function unload() {
        webViewLoader.sourceComponent = undefined;
        webViewLoader.active = false;
    }

    Connections {
        target: webIf

        onUrlChanged: {
            if (webViewLoader.item) {
                webViewLoader.item.url = url;
            }
        }

        onActiveChanged: {
            if (active) {
                webViewLoader.active = true;
                webViewLoader.sourceComponent = webView;
            } else {
                webViewLoader.sourceComponent = undefined;
                webViewLoader.active = false;
            }
        }
    }

    // The WebView is wrapped inside a Component, so that it wouldn't waste
    // memory all the time, and is created only when needed (and deleted when
    // there's no more need to show the login page).
    Component {
        id: webView

        Item {
            property alias url: web.url

            // Fading Rectangle.
            Rectangle {
                anchors.fill: parent
                color: "black"
                opacity: 0.7

                // Just to capture the clicks.
                MouseArea {
                    anchors.fill: parent
                }
            }

            // Wrap the WebView inside a Flickable to be able to scroll the view.
            Flickable {
                id: webFlickable

                anchors.centerIn: parent
                width: parent.width * 9/10
                height: parent.height * 9/10
                contentHeight: web.height
                contentWidth: web.width
                flickableDirection: Flickable.VerticalFlick
                boundsBehavior: Flickable.StopAtBounds
                clip: true

                WebView {
                    id: web

                    preferredWidth: webFlickable.width
                    preferredHeight: webFlickable.height
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
}
