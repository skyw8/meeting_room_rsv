import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import FluentUI

Item {
    id: app

    Connections{
        target: FluTheme
        function onDarkModeChanged(){
            SettingsHelper.saveDarkMode(FluTheme.darkMode)
        }
    }

    Connections{
        target: FluApp
        function onVsyncChanged(){
            SettingsHelper.saveVsync(FluApp.vsync)
        }
    }

    Component.onCompleted: {
        FluApp.init(app)
        FluApp.vsync = SettingsHelper.getVsync()
        FluTheme.darkMode = SettingsHelper.getDarkMode()
        FluTheme.enableAnimation = true
        FluApp.routes = {
            "/login":"qrc:meeting_room_rsv/qml/LoginWindow.qml",
            "/usr":"qrc:meeting_room_rsv/qml/UsrWindow.qml",
            "/page_window":"qrc:meeting_room_rsv/qml/PageWindow.qml",
            "/admin":"qrc:meeting_room_rsv/qml/AdminWindow.qml",
            "/room_detail":"qrc:meeting_room_rsv/qml/RoomDetailWindow.qml",
            "/room_add":"qrc:meeting_room_rsv/qml/RoomAddWindow.qml",
            "/rsv_detail":"qrc:meeting_room_rsv/qml/RsvDetailWindow.qml",
            "/room_edit":"qrc:meeting_room_rsv/qml/RoomEditWindow.qml"
        }
        FluApp.initialRoute = "/login"
        FluApp.run()
    }
    
}
