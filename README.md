Status Shout! v1.0
==================

The Status Shout! example application demonstrates the use of social media (in this case,
Twitter & Facebook), OAuth authentication, and posting status update messages
with images.

The Status Shout! application uses the Social Connect QML plug-in, which handles
authentication of the application to different social media and can be easily
utilised in other applications. The application also uses the
official Qt Quick Components for navigation and UI.

The Social Connect QML plug-in used in the Status Shout! example application is
available at http://projects.developer.nokia.com/socialconnect

The Status Shout! uses Qt Quick Components in numerous places. For
example, when navigating deeper into the application, the PageStack is used.
The StatusBar and ToolBar (with all the ToolButtons etc.) are also used.

This example application demonstrates:
- Using the Social Connect QML plug-in:
  - Authentication with OAuth (versions 1.0 & 2.0).
  - Posting a message to social media services.
- Using Qt Quick Components in an application that supports multiple
  resolutions and both touch UI and keypad.
- Smart startup of the application (content and application UI loaded during
  splash screen.

This example application is hosted in Nokia Developer Projects:
- http://projects.developer.nokia.com/statusshout

For more information on the implementation, visit the wiki page:
- http://projects.developer.nokia.com/statusshout/wiki


1. Usage
-------------------------------------------------------------------------------

The customised Social Connect QML plug-in can be taken into use 
either by linking it statically into the application, or by using it "as is"
by merely adding the socialconnect.sis file into the .pro file (as has been
done in the Status Shout! example application).

Follow the step-by-step guide from the Social Connect plug-in wiki for more details:
- http://projects.developer.nokia.com/socialconnect/wiki/GettingStarted


2. Prerequisites
-------------------------------------------------------------------------------

 - Qt basics
 - Qt Quick basics
 - Qt Quick Components basics


3. Project structure and implementation
-------------------------------------------------------------------------------

3.1 Folders
-----------

 |                   The root folder contains the licence information and
 |                   this file (release notes).
 |
 |- design           Contains UX design files.
 |
 |- screenshots      Contains screenshots taken from the application.
 |
 |- code             Root folder for project, gfx, QML, and Javascript files.
 |

3.2 Important files and classes
-------------------------------

| Class                   | Description                                       |
|-------------------------|---------------------------------------------------|
| LoadHelper              | Helper class that is used to load the main QML    |
|                         | file right after showing the splash screen.       |
|-------------------------|---------------------------------------------------|

3.3 Used APIs/QML elements/Qt Quick Components
----------------------------------------------

The following APIs, QML elements, and Qt Quick Components have been used. 

Standard QML elements:
- Connections
- Flickable
- ListView
- Loader
- Text
- TextEdit
- WebView

- Behavior
- ParallelAnimation
- State
- Transition

QML elements from Qt Quick Components:
- BusyIndicator
- Label
- ListItem
- Switch
- ScrollDecorator
- QueryDialog

QML elements from the Social Connect QML plug-in:
- FacebookConnection
- TwitterConnection
- WebInterface


4. Compatibility
-------------------------------------------------------------------------------

Compatible with:
 - Symbian devices with Qt 4.7.4 or higher.

Tested on:
 - Nokia E7-00
 - Nokia 808

Developed with:
 - Qt SDK 1.2

4.1 Required capabilities
-------------------------

NetworkServices and ReadUserData. Required for the Social Connect QML plug-in
to work correctly with network. The application can be self signed on Symbian.

4.2 Known issues and design limitations
---------------------------------------

Camera button not working properly:
- Functionality for taking a picture with the camera has not yet been implemented.

Gallery button not working properly:
- Functionality for selecting a picture from the device's gallery has not yet been
  implemented.


5. Building, installing, and running the application
-------------------------------------------------------------------------------

5.1 Preparations
----------------

Check that you have the latest Qt SDK installed in the development environment
and the latest Qt version on the device.

Qt Quick Components 1.1 or higher is required.

5.2 Using the Qt SDK
--------------------

You can install and run the application on the device by using the Qt SDK.
Open the project in the SDK, set up the correct target (depending on the device
platform), and click the Run button. For more details about this approach,
visit the Qt Getting Started section at Nokia Developer
(http://www.developer.nokia.com/Develop/Qt/Getting_started/).

5.3 Symbian device
------------------

Make sure your device is connected to your computer. Locate the .sis
installation file and open it with Nokia Suite. Accept all requests from Nokia
Suite and the device. Note that you can also install the application by copying
the installation file onto your device and opening it with the Symbian File
Manager application.

After the application is installed, locate the application icon from the
application menu and launch the application by tapping the icon.


6. Licence
-------------------------------------------------------------------------------

See the licence text file delivered with this project. The licence file is also
available online at
http://projects.developer.nokia.com/statusshout/browser/Licence.txt


7. Related documentation
-------------------------------------------------------------------------------
Qt Quick Components
- http://doc.qt.nokia.com/qt-components-symbian/index.html


8. Version history
-------------------------------------------------------------------------------

1.0 Initial release.
