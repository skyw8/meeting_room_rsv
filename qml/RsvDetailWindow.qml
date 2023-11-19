import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import FluentUI

FluWindow {
    id: rsv_detail
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
    property var aprvl_detail: db_mng.getApprovalDetail(argument.rsvData.ReservationID)
    Component.onCompleted:
    // console.log("test", JSON.stringify(argument.rsvData))
    {
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
            id: column
            spacing: 10
            width: parent.width

            Text {
                text: "<b>预约编号:</b> " + argument.rsvData.ReservationID
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }
            Text {
                text: "<b>会议室编号:</b> " + argument.rsvData.RoomID
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }
            Text {
                text: "<b>预约日期:</b> " + db_mng.getReservationDate(argument.rsvData.ReservationID)
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }

            Text {
                text: "<b>开始时间:</b> " + argument.rsvData.StartTime
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }
            Text {
                text: "<b>结束时间:</b> " + argument.rsvData.EndTime
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }
            Text {
                text: "<b>参会人数:</b> " + argument.rsvData.Attendance
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }
            Text {
                text: "<b>会议主题:</b> " + argument.rsvData.MeetingTheme
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }
            Text {
                text: "<b>审批情况:</b> " + argument.rsvData.ReservationStatus
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }
            Text {
                text: "<b>审批时间:</b> " + aprvl_detail[0]
                visible: aprvl_detail[0] !== ""
            }

            Text {
                text: "<b>审批人:</b> " + aprvl_detail[1]
                visible: aprvl_detail[1] !== ""
            }

            Text {
                text: "<b>驳回理由:</b> " + aprvl_detail[2]
                visible: aprvl_detail[2] !== ""
            }
        }
    }

    onClosing:
    //TODO释放资源
    {
    }
}
