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
    minimumWidth: 400
    maximumWidth: 400
    minimumHeight: 500
    maximumHeight: 500
    fixSize: true
    launchMode: FluWindowType.SingleTask
    appBar: undefined
    Component.onCompleted: {
    }
    FluAppBar {
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

    Flickable {
        anchors {
            top: app_bar.bottom
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
                fillMode: Image.PreserveAspectFit
                width: parent.width // 图像宽度与父组件宽度相同
                height: 250 // 固定高度，可根据需求调整
                sourceSize.width: parent.width // 限制加载的图像宽度
                sourceSize.height: 250 // 限制加载的图像高度
                visible: photo.status === Image.Ready // 图像加载完成后显示
            }

            Text {
                text: "<b>房号:</b> " + argument.roomData.RoomID
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }
            Text {
                text: "<b>名称:</b> " + argument.roomData.RoomName
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }
            Text {
                text: "<b>人数容量:</b> " + argument.roomData.Capacity
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }
            Text {
                text: "<b>面积:</b> " + argument.roomData.RoomArea
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }
            FluText {
                text: "<b>描述:</b> " + argument.roomData.Description
                //TODO自动换行问题
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
                // width: parent.width
            }
        }
    }
    onClosing: {
        //TODO释放资源
    }
}
