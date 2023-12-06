import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import FluentUI

FluWindow {
    id: room_detail
    title: "详情"
    width: 400
    height: 500
    launchMode: FluWindowType.SingleTask
    appBar: FluAppBar {
        id: app_bar
        title: "详情"
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        showMinimize: false
        showMaximize: false
        showDark: false
        z: 7
    }
    Component.onCompleted: {
    }
    

    Flickable {
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            margins: 10
        }
        contentWidth: width
        contentHeight: column.height
        ColumnLayout {
            spacing: 10
            width: parent.width
            id: column
            Image {
                id: photo
                source: db_mng.getRoomPhoto(argument.roomData.RoomID)
                sourceSize.width: parent.width
                sourceSize.height: 250
                visible: photo.status === Image.Ready
                Layout.alignment: Qt.AlignHCenter
            }

            FluText {
                text: "<b>房号:</b> " + argument.roomData.RoomID
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }
            FluText {
                text: "<b>名称:</b> " + argument.roomData.RoomName
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }
            FluText {
                text: "<b>人数容量:</b> " + argument.roomData.Capacity
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }
            FluText {
                text: "<b>面积:</b> " + argument.roomData.RoomArea
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }
            FluText {
                text: "<b>描述:</b> " + argument.roomData.Description
                //TODO自动换行问题
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }
        }
    }
}