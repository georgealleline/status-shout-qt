/**
 * Copyright (c) 2012-2014 Microsoft Mobile.
 */

import QtQuick 1.1
import com.nokia.symbian 1.1
import QtMobility.gallery 1.1

Page {
    id: imagePickerPage

    property PageStack pageStack
    signal selected(string url)

    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: 0.9
    }

    GridView {
        id: imageGrid

        width: parent.width
        height: parent.height
        cellWidth: 120
        cellHeight: 120
        clip: true

        model: DocumentGalleryModel {
            id: galleryModel

            rootType: DocumentGallery.Image
            scope: DocumentGallery.Image
            properties: [ "url" ]
            limit: 10
            autoUpdate: false
        }

        delegate: Image {
            source: url

            sourceSize.width: 118
            height: sourceSize.width
            width: sourceSize.width
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            clip: true

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    imagePickerPage.selected(url);
                    imagePickerPage.pageStack.pop();
                }
            }
        }

        ScrollDecorator {
            flickableItem: imageGrid
        }
    }

    tools: ToolBarLayout {
        ToolButton {
            iconSource: "toolbar-back"
            onClicked: imagePickerPage.pageStack.pop();
        }
    }
}
