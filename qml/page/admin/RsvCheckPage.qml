import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import FluentUI
import meeting_room_rsv

FluContentPage {
    id: rsvCheck_page
    title: "预约记录"
    property var activeTableView // 新增属性，用于存储当前激活的 FluTableView
    property int currentRowIndex: -1
    Component.onCompleted: {
        load_data_agree();
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
                        //var obj = activeTableView.dataSource[rsvCheck_page.currentRowIndex];
                        currentRowIndex = row;
                        var obj = activeTableView.dataSource[currentRowIndex];
                        console.log("传递的数据：", JSON.stringify(obj));
                        console.log("查看详情", obj.ReservationID);
                        FluApp.navigate("/rsv_detail", {
                                rsvData: obj
                            });
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

    FluComboBox {
        id: rsvCheck_CB
        model: ListModel {
            id: model_1
            ListElement {
                text: "通过"
            }
            ListElement {
                text: "驳回"
            }
            ListElement {
                text: "未审批"
            }
            ListElement {
                text: "已取消"
            }
        }
        onCurrentIndexChanged: {
            Qt.callLater(function () {
                    if (rsvCheck_CB.currentText === "通过") {
                        activeTableView = tbl_view_agree;
                        tbl_view_agree.visible = true;
                        tbl_view_reject.visible = false;
                        tbl_view_unapproved.visible = false;
                        tbl_view_canceled.visible = false;
                        load_data_agree();
                    } else if (rsvCheck_CB.currentText === "驳回") {
                        activeTableView = tbl_view_reject;
                        tbl_view_agree.visible = false;
                        tbl_view_reject.visible = true;
                        tbl_view_unapproved.visible = false;
                        tbl_view_canceled.visible = false;
                        load_data_reject();
                    } else if (rsvCheck_CB.currentText === "未审批") {
                        activeTableView = tbl_view_unapproved;
                        tbl_view_agree.visible = false;
                        tbl_view_reject.visible = false;
                        tbl_view_unapproved.visible = true;
                        tbl_view_canceled.visible = false;
                        load_data_unapproved();
                    } else if (rsvCheck_CB.currentText === "已取消") {
                        activeTableView = tbl_view_canceled;
                        tbl_view_agree.visible = false;
                        tbl_view_reject.visible = false;
                        tbl_view_unapproved.visible = false;
                        tbl_view_canceled.visible = true;
                        load_data_canceled();
                    }
                });
        }
    }

    FluTableView {
        id: tbl_view_agree
        dataSource: []
        visible: true
        anchors {
            top: rsvCheck_CB.bottom
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

    FluTableView {
        id: tbl_view_reject
        dataSource: []
        visible: false
        anchors {
            top: rsvCheck_CB.bottom
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

    FluTableView {
        id: tbl_view_unapproved
        dataSource: []
        visible: false
        anchors {
            top: rsvCheck_CB.bottom
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

    FluTableView {
        id: tbl_view_canceled
        dataSource: []
        visible: false
        anchors {
            top: rsvCheck_CB.bottom
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

    function load_data_agree() {
        var dataSource = db_mng.getApprovedReservationsData("agree");
        for (var i = 0; i < dataSource.length; ++i) {
            dataSource[i].operation = tbl_view_agree.customItem(operation);
            //console.log("Reservations：", i, JSON.stringify(dataSource[i]));
        }
        tbl_view_agree.dataSource = dataSource;
    }
    function load_data_reject() {
        var dataSource = db_mng.getApprovedReservationsData("reject");
        for (var i = 0; i < dataSource.length; ++i) {
            dataSource[i].operation = tbl_view_reject.customItem(operation);
            //console.log("Reservations：", i, JSON.stringify(dataSource[i]));
        }
        tbl_view_reject.dataSource = dataSource;
    }
    function load_data_unapproved() {
        var dataSource = db_mng.getApprovedReservationsData("unapproved");
        for (var i = 0; i < dataSource.length; ++i) {
            dataSource[i].operation = tbl_view_unapproved.customItem(operation);
            //console.log("Reservations：", i, JSON.stringify(dataSource[i]));
        }
        tbl_view_unapproved.dataSource = dataSource;
    }
    function load_data_canceled() {
        var dataSource = db_mng.getApprovedReservationsData("canceled");
        for (var i = 0; i < dataSource.length; ++i) {
            dataSource[i].operation = tbl_view_canceled.customItem(operation);
            //console.log("Reservations：", i, JSON.stringify(dataSource[i]));
        }
        tbl_view_canceled.dataSource = dataSource;
    }
}
