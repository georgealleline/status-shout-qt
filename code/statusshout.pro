# Copyright (c) 2012 Nokia Corporation.

# Basic Qt configuration
QT += declarative
CONFIG += qt qt-components
# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
#MOBILITY += multimedia

SOURCES += loadhelper.cpp main.cpp
HEADERS += loadhelper.h

# Version number & version string definition (for using it inside the app)
VERSION = 0.0.1
VERSTR = '\\"$${VERSION}\\"'
DEFINES += VER=\"$${VERSTR}\"

# Add more folders to ship with the application, here
qml_sources.source = qml/statusshout
qml_sources.target = qml
DEPLOYMENTFOLDERS = qml_sources

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

# Platform specific files and configuration
symbian {
    # Allow network access on Symbian
    TARGET.CAPABILITY += NetworkServices
    TARGET.UID3 = 0xE0C9633A
}
contains(MEEGO_EDITION,harmattan) {
    # Add these, if MeeGo support required.
    # Speed up launching on MeeGo/Harmattan when using applauncherd daemon
    #CONFIG += qdeclarative-boostable
}

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()
