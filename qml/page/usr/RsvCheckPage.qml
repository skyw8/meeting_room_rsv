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
    Component.onCompleted: {
        load_data();
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
                        var obj = tbl_view.dataSource[currentRowIndex];
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

    FluComboBox {
        id : rsvCheck_CB
        model: ListModel {
            id: model_1
            ListElement {
                text: "agree"
            }
            ListElement {
                text: "Apple"
            }
            ListElement {
                text: "Coconut"
            }
        }
    }

    FluTableView {
        id: tbl_view_agree
        dataSource: []
        visible : true
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
                title: "test",
                dataIndex: 'ReservationStatus',
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
        visible : false
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
                title: "test",
                dataIndex: 'ReservationStatus',
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
        visible : false
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
                title: "test",
                dataIndex: 'ReservationStatus',
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
        visible : false
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
                title: "test",
                dataIndex: 'ReservationStatus',
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
            dataSource[i].operation = tbl_view.customItem(operation);
            //console.log("Reservations：", i, JSON.stringify(dataSource[i]));
        }
        tbl_view.dataSource = dataSource;
    }
    function load_data_reject() {
        var dataSource = db_mng.getApprovedReservationsData("reject");
        for (var i = 0; i < dataSource.length; ++i) {
            dataSource[i].operation = tbl_view.customItem(operation);
            //console.log("Reservations：", i, JSON.stringify(dataSource[i]));
        }
        tbl_view.dataSource = dataSource;
    }
    function load_data_unapproved() {
        var dataSource = db_mng.getApprovedReservationsData("unapproved");
        for (var i = 0; i < dataSource.length; ++i) {
            dataSource[i].operation = tbl_view.customItem(operation);
            //console.log("Reservations：", i, JSON.stringify(dataSource[i]));
        }
        tbl_view.dataSource = dataSource;
    }
    function load_data_canceled() {
        var dataSource = db_mng.getApprovedReservationsData("canceled");
        for (var i = 0; i < dataSource.length; ++i) {
            dataSource[i].operation = tbl_view.customItem(operation);
            //console.log("Reservations：", i, JSON.stringify(dataSource[i]));
        }
        tbl_view.dataSource = dataSource;
    }


}
