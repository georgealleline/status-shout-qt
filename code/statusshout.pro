# Copyright (c) 2012 Nokia Corporation.

# Basic Qt configuration
QT += declarative
CONFIG += qt qt-components
TARGET = StatusShout
# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
#MOBILITY += multimedia

HEADERS += loadhelper.h
SOURCES += loadhelper.cpp main.cpp

# Version number & version string definition (for using it inside the app)
VERSION = 0.2.0
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
    TARGET.CAPABILITY += NetworkServices ReadUserData
    TARGET.UID3 = 0xE0C9633A

    # Include the Social Connect QML Plugin into the package.
    socialconnect_deployment.pkg_prerules = "@\"socialconnect.sis\", (0xED6AB47E)"
    DEPLOYMENT += socialconnect_deployment
}
contains(MEEGO_EDITION,harmattan) {
    # Add these, if MeeGo support required.
    # Speed up launching on MeeGo/Harmattan when using applauncherd daemon
    #CONFIG += qdeclarative-boostable
}

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()
