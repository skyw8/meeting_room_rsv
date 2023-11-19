import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Dialogs
import FluentUI

FluWindow {
    id: room_add
    title: "预约"
    width: 400
    height: 600
    minimumWidth: 400
    maximumWidth: 400
    minimumHeight: 600
    maximumHeight: 600
    fixSize: true
    launchMode: FluWindowType.SingleTask
    appBar: undefined
    Component.onCompleted: {
        console.log("传递的数据:", JSON.stringify(argument.rsvData));
    }
    FluAppBar {
        id: app_bar
        title: "预约"
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
    ColumnLayout {
        anchors {
            fill: parent
            centerIn: parent
            leftMargin: 30
            topMargin: 20
        }
        spacing: 3
        FluText {
            text: "<b>会议室:</b> " + argument.rsvData.roomID
        }
        FluText {
            text: "<b>参会人数:</b> " + argument.rsvData.attendance
        }
        FluText {
            text: "<b>日期:</b> " + argument.rsvData.date
        }
        FluText {
            text: "<b>开始时间:</b> " + argument.rsvData.startTime + " 点"
        }
        FluText {
            text: "<b>结束时间:</b> " + argument.rsvData.endTime + " 点"
        }
        RowLayout {
            FluText {
                text: "<b>会议主题:</b> "
                font: FluTextStyle.BodyStrong
            }
            FluTextBox {
                id: room_id_box
                placeholderText: "请填写会议主题"
                Layout.preferredWidth: 150
            }
        }
        FluFilledButton {
            id: rsv_btn
            text: "预约"
            Layout.alignment: Qt.AlignHCenter
            onClicked: {
                var userID = argument.rsvData.userID; // 获取用户ID
                var roomID = argument.rsvData.roomID;
                var date = argument.rsvData.date; // 假设是 'yyyy-MM-dd' 格式的字符串
                var startTime = argument.rsvData.startTime;
                var endTime = argument.rsvData.endTime;
                var attendance = parseInt(argument.rsvData.attendance);
                var meetingTheme = room_id_box.text;
                var result = db_mng.addReservation(userID, roomID, date, startTime, endTime, attendance, meetingTheme);
                if (result) {
                    onResult({
                            msg: "预约已提交"
                        });
                    room_add.close()
                } else {
                    showError("预约失败");
                }
            }
        }
    }
}
