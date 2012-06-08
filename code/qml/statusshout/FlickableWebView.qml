import QtQuick 1.1
import com.nokia.symbian 1.1
import QtWebKit 1.0

Flickable {
    id: webFlickable

    property alias url: web.url

    contentHeight: web.height
    contentWidth: childrenRect.width
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
