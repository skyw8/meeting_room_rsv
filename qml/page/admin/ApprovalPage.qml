import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import FluentUI
import meeting_room_rsv

FluContentPage {
    id: rsvCheck_page
    title: "预约记录"
    property int currentRowIndex: -1
    property var rejectWindowRegister: registerForWindowResult("/reject")
    Connections{
        target: rejectWindowRegister
        function onResult(result){
            console.log(result.msg)
            showSuccess(result.msg)
            load_data_unapproved()
        }
    }
    Component.onCompleted: {
        load_data_unapproved();
    }
    Component {
        id: operation
        Item {
            RowLayout {
                anchors.centerIn: parent
                FluButton {
                    id: btn_detail
                    text: "详情"
                    onClicked: {
                        currentRowIndex = row;
                        var obj = tbl_view_unapproved.dataSource[currentRowIndex];
                        console.log("传递的数据：", JSON.stringify(obj));
                        console.log("查看详情", obj.ReservationID);
                        FluApp.navigate("/rsv_detail", {
                                rsvData: obj
                            });
                    }
                }
                FluFilledButton {
                    id: btn_agree
                    text: "同意"
                    onClicked: {
                        currentRowIndex = row;
                        var obj = tbl_view_unapproved.dataSource[currentRowIndex];
                        var success = db_mng.agreeReservation(obj.ReservationID,argument.UsrInfo.UserID);
                        if (success) {
                            showSuccess("操作成功");
                            load_data_unapproved();
                        } else {
                            showError("操作失败");
                        }
                    }
                }
                FluFilledButton {
                    id: btn_reject
                    text: "驳回"
                    onClicked: {
                        currentRowIndex = row;
                        var obj = tbl_view_unapproved.dataSource[currentRowIndex];
                        var log_data={
                            reservationID: obj.ReservationID,
                            approverID: argument.UsrInfo.UserID
                        }
                        rejectWindowRegister.launch({logData:log_data})
                    }
                }
            }
        }

    

    }

    Component {
        id: edit_box
        Item {
        }
    }

    FluTableView {
        id: tbl_view_unapproved
        dataSource: []
        visible: true
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        anchors.topMargin: 20
        columnSource: [{
                title: "申请编号",
                dataIndex: "ReservationID",
                width: 80,
                minimumWidth: 120,
                maximumWidth: 120,
                //禁用编辑
                editDelegate: edit_box
            }, {
                title: "会议室号",
                dataIndex: "RoomID",
                width: 80,
                minimumWidth: 120,
                maximumWidth: 120,
                editDelegate: edit_box
            }, {
                title: "会议主题",
                dataIndex: 'MeetingTheme',
                width: 200,
                minimumWidth: 200,
                maximumWidth: 200,
                editDelegate: edit_box
            }, {
                title: "参会人数",
                dataIndex: 'Attendance',
                width: 80,
                minimumWidth: 120,
                maximumWidth: 120,
                editDelegate: edit_box
            }, {
                title: "操作",
                dataIndex: 'operation',
                width: 160,
                minimumWidth: 160,
                maximumWidth: 160,
                delegate: operation,
                editDelegate: edit_box
            }]
        Component.onCompleted: {
        }
    }

    function load_data_unapproved() {
        var dataSource = db_mng.getApprovedReservationsData("unapproved");
        for (var i = 0; i < dataSource.length; ++i) {
            dataSource[i].operation = tbl_view_unapproved.customItem(operation);
            //console.log("Reservations：", i, JSON.stringify(dataSource[i]));
        }
        tbl_view_unapproved.dataSource = dataSource;
    }

}
