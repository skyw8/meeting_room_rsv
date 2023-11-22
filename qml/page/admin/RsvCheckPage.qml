import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import FluentUI
import meeting_room_rsv

FluContentPage {
    id: rsv_chk_page
    title: "预约记录"
    property int currentRowIndex: -1
    Component.onCompleted: {
        loadData(tbl_view,"agree")
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
        id: rsv_chk_cbox
        model: ListModel {
            id: model_1
            ListElement {
                text: "已通过"
            }
            ListElement {
                text: "已驳回"
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
                    if (rsv_chk_cbox.currentText === "已通过") {
                        loadData(tbl_view,"agree")
                    } else if (rsv_chk_cbox.currentText === "已驳回") {
                        loadData(tbl_view,"reject")
                    } else if (rsv_chk_cbox.currentText === "未审批") {
                        loadData(tbl_view,"unapproved")
                    } else if (rsv_chk_cbox.currentText === "已取消") {
                        loadData(tbl_view,"canceled")
                    }
                });
        }
    }

    FluTableView {
        id: tbl_view
        dataSource: []
        anchors {
            top: rsv_chk_cbox.bottom
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
    function loadData(table, status) {
        var data_src = db_mng.getApprovedRsv(status);
        for (var i = 0; i < data_src.length; ++i) {
            data_src[i].operation = table.customItem(operation);
        }
        table.dataSource = data_src;
    }

}
