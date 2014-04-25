/**
 * Copyright (c) 2012-2014 Microsoft Mobile.
 */

// Class header
#include "loadhelper.h"

// Internal includes
#include "qmlapplicationviewer.h"

/*!
  \class LoadHelper
  \brief LoadHelper is a utility class for loading the main.qml file after splash.
*/

/*!
  Factory method for creating a LoadHelper instance.
*/
LoadHelper *LoadHelper::create(QmlApplicationViewer *viewer, QObject *parent)
{
    return new LoadHelper(viewer, parent);
}

/*!
  Constructor.
*/
LoadHelper::LoadHelper(QmlApplicationViewer *viewer, QObject *parent)
    : QObject(parent),
      m_viewer(viewer)
{}

/*!
  Public slot that sets the main QML file. Usually used in conjunction with
  a single shot timer.
*/
void LoadHelper::loadMainQML()
{
    if (m_viewer) {
        m_viewer->setMainQmlFile(QLatin1String("qml/statusshout/main.qml"));
    }
}
