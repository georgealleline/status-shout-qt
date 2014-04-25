/**
 * Copyright (c) 2012-2014 Microsoft Mobile.
 */

#include <QtGui/QApplication>
#include <QDeclarativeContext>
#include <QTimer>
#include "qmlapplicationviewer.h"
#include "loadhelper.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));
    QmlApplicationViewer viewer;

#if defined(Q_OS_SYMBIAN)
    // Set this attribute in order to avoid drawing the system background unnecessarily.
    viewer.setAttribute(Qt::WA_NoSystemBackground);
    // Workaround for an issue with Symbian: "X.Y.Z" -> X.Y.Z
    static const QString VERSION_NUMBER(QString("%1").arg(VER).mid(1, QString(VER).length()-2));
#else
    static const QString VERSION_NUMBER(QString("%1").arg(VER)); // X.Y.Z by itself
#endif

    // Set the application version number as a context property (for the AboutView
    // to show, if needed) and set the quick loading Splash QML file.
    app->setApplicationVersion(VERSION_NUMBER);
    viewer.rootContext()->setContextProperty(QString("cp_versionNumber"), VERSION_NUMBER);
    viewer.setMainQmlFile(QLatin1String("qml/statusshout/Splash.qml"));

    // Then trigger loading the *real* main.qml file, which can take longer to load.
    QScopedPointer<LoadHelper> loadHelper(LoadHelper::create(&viewer));
    QTimer::singleShot(1, loadHelper.data(), SLOT(loadMainQML()));

    viewer.showExpanded();
    return app->exec();
}
