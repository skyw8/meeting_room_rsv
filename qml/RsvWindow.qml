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
    launchMode: FluWindowType.SingleTask
    appBar: FluAppBar {
        id: app_bar
        title: "预约"
        width: room_add.width
        height: 30
        showMinimize: false
        showMaximize: false
        showDark: false
        z: 7
    }
    Component.onCompleted: {
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
                var userID = argument.rsvData.userID;
                var roomID = argument.rsvData.roomID;
                var date = argument.rsvData.date;
                var startTime = argument.rsvData.startTime;
                var endTime = argument.rsvData.endTime;
                var attendance = parseInt(argument.rsvData.attendance);
                var meetingTheme = room_id_box.text;
                var result = db_mng.addRsv(userID, roomID, date, startTime, endTime, attendance, meetingTheme);
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
