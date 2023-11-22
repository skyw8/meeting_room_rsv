import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import FluentUI
import meeting_room_rsv

FluContentPage {
    id: rsv_chk_page
    title: "预约记录"
    property int current_idx: -1
    property var reject_win_register: registerForWindowResult("/reject")
    Connections{
        target: reject_win_register
        function onResult(result){
            showSuccess(result.msg)
            loadData()
        }
    }
    Component.onCompleted: {
        loadData()
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
                        current_idx = row;
                        var obj = tbl_view.dataSource[current_idx];
                        FluApp.navigate("/rsv_detail", {
                                rsvData: obj
                            });
                    }
                }
                FluFilledButton {
                    id: btn_agree
                    text: "同意"
                    onClicked: {
                        current_idx = row;
                        var obj = tbl_view.dataSource[current_idx];
                        var success = db_mng.agreeRsv(obj.ReservationID,argument.UsrInfo.UserID);
                        if (success) {
                            showSuccess("操作成功");
                            loadData();
                        } else {
                            showError("操作失败");
                        }
                    }
                }
                FluFilledButton {
                    id: btn_reject
                    text: "驳回"
                    onClicked: {
                        current_idx = row;
                        var obj = tbl_view.dataSource[current_idx];
                        var log_data={
                            reservationID: obj.ReservationID,
                            approverID: argument.UsrInfo.UserID
                        }
                        reject_win_register.launch({logData:log_data})
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
        id: tbl_view
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

    function loadData() {
        var data_src = db_mng.getApprovedRsv("unapproved");
        for (var i = 0; i < data_src.length; ++i) {
            data_src[i].operation = tbl_view.customItem(operation);
        }
        tbl_view.dataSource = data_src;
    }

}
