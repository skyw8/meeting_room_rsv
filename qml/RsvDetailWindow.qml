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
    fixSize: true
    launchMode: FluWindowType.SingleTask
    appBar: FluAppBar {
        id: app_bar
        title: "详情"
        width: rsv_detail.width
        height: 30
        showMinimize: false
        showMaximize: false
        showDark: false
        z: 7
    }
    property var aprvl_detail: db_mng.getLogs(argument.rsvData.ReservationID)
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
            id: column
            spacing: 10
            width: parent.width

            FluText {
                text: "<b>预约编号:</b> " + argument.rsvData.ReservationID
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }
            FluText {
                text: "<b>会议室编号:</b> " + argument.rsvData.RoomID
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }
            FluText {
                text: "<b>预约日期:</b> " + db_mng.getRsvDate(argument.rsvData.ReservationID)
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }

            FluText {
                text: "<b>开始时间:</b> " + argument.rsvData.StartTime
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }
            FluText {
                text: "<b>结束时间:</b> " + argument.rsvData.EndTime
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }
            FluText {
                text: "<b>参会人数:</b> " + argument.rsvData.Attendance
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }
            FluText {
                text: "<b>会议主题:</b> " + argument.rsvData.MeetingTheme
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }
            FluText {
                text: {
                    switch (argument.rsvData.ReservationStatus) {
                    case 'agree':
                        return "<b>审批情况:</b> 已通过";
                    case 'reject':
                        return "<b>审批情况:</b> 已驳回";
                    case 'unapproved':
                        return "<b>审批情况:</b> 未审批";
                    case 'canceled':
                        return "<b>审批情况:</b> 已取消";
                    default:
                        return "<b>审批情况:</b> 未知状态";
                    }
                }
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }
            FluText {
                text: "<b>审批时间:</b> " + aprvl_detail[0]
                visible: aprvl_detail[0] !== ""
            }

            FluText {
                text: "<b>审批人:</b> " + aprvl_detail[1]
                visible: aprvl_detail[1] !== ""
            }

            FluText {
                text: "<b>驳回理由:</b> " + aprvl_detail[2]
                visible: aprvl_detail[2] !== ""
            }
        }
    }
}
