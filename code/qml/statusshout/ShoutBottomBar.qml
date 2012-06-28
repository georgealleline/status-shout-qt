/**
 * Copyright (c) 2012 Nokia Corporation.
 */

import QtQuick 1.1
import com.nokia.symbian 1.1

Loader {
    id: bottomBanner

    property PageStack pageStack
    property string url

    sourceComponent: url != "" ? imagePreview : buttonGroup

    // Component defining "Take Image" & "From Gallery" buttons.
    Component {
        id: buttonGroup

        Item {
            anchors.fill: parent

            Item {
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                }
                width: parent.width / 2

                ImageButton {
                    id: cameraButton

                    anchors.centerIn: parent
                    source: cp_inPortrait ? "gfx/camera.png" : "gfx/camera_landscape.png"
                    text: qsTr("+ new picture")
                    fontSize: cp_inPortrait ? platformStyle.fontSizeLarge
                                            : platformStyle.fontSizeSmall
                    onClicked: {
                        dlgLoader.sourceComponent = errorDlg;
                        dlgLoader.item.open();
                        console.log("TAKE A PICTURE! NOT IMPLEMENTED YET!");
                    }
                }
            }

            Item {
                anchors {
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                }
                width: parent.width / 2

                ImageButton {
                    id: galleryButton

                    anchors.centerIn: parent
                    source: cp_inPortrait ? "gfx/gallery.png" : "gfx/gallery_landscape.png"
                    text: qsTr("+ from gallery")
                    fontSize: cp_inPortrait ? platformStyle.fontSizeLarge
                                            : platformStyle.fontSizeSmall
                    onClicked: {
                        bottomBanner.pageStack.push(imagePickerPageComp);
                    }
                }
            }
        }
    }

    // Component showing a preview of the selected image & a button to discard it.
    Component {
        id: imagePreview

        Item {
            id: previewItem

            anchors.fill: parent

            Rectangle {
                anchors.centerIn: parent

                // Create a nice, white borders around the image with a
                // transparent rectangle.
                width: img.paintedWidth + border.width
                height: img.paintedHeight + border.width
                color: "transparent"
                border.color: "white"
                border.width: 4
            }

            Image {
                id: img

                anchors.centerIn: parent
                width: previewItem.width * 0.9
                height: previewItem.height * 0.9
                fillMode: Image.PreserveAspectFit

                source: bottomBanner.url
            }

            Button {
                anchors {
                    top: parent.top
                    topMargin: 10
                    right: parent.right
                    rightMargin: 10
                }
                text: "X"

                onClicked: {
                    bottomBanner.url = "";
                }
            }
        }
    }

    // ImagePickerPage component. If an image is selected, switch the ShoutBottomBar
    // Loader's sourceComponent to the image preview element.
    Component {
        id: imagePickerPageComp

        ImagePickerPage {
            onSelected: bottomBanner.url = url;
        }
    }

    // TODO! Implement the camera functionality and remove this!
    Loader {
        id: errorDlgLoader

        anchors.centerIn: parent

        Component {
            id: errorDlg

            QueryDialog {
                anchors.centerIn: parent
                titleText: qsTr("Error")
                message: qsTr("Feature not implemented yet!\n")

                acceptButtonText: qsTr(":(")
                onAccepted: errorDlgLoader.sourceComponent = undefined
            }
        }
    }
}
