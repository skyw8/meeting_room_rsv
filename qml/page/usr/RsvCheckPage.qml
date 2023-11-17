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
    Component {
        id: edit_box
        Item {
        }
    }
    FluTextBox {
        id: rsvCheck_srch
        anchors {
            left: parent.left
            top: parent.top
            margins: 20
        }
        placeholderText: "输入用户ID或预约ID搜索"
    }
    FluFilledButton {
        id: srch_btn
        anchors {
            left: rsvCheck_srch.right
            top: parent.top
            margins: 20
        }
        text: "搜索"
    }

    FluTableView {
        id: tbl_view
        dataSource: []
        anchors {
            top: rsvCheck_srch.bottom
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
    function load_data() {
        var dataSource = db_mng.get_tbl_data("Reservations");
        for (var i = 0; i < dataSource.length; ++i) {
            dataSource[i].operation = tbl_view.customItem(operation);
            console.log("Reservations：", i, JSON.stringify(dataSource[i]));
        }
        tbl_view.dataSource = dataSource;
    }
}
