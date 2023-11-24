import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import FluentUI

FluContentPage {
    title: "会议室"
    property var time_range: [7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22]
    Component.onCompleted: {
    }
    property var rsv_win_register: registerForWindowResult("/rsv")
    Connections {
        target: rsv_win_register
        function onResult(result) {
            //TODO 没有提示
            showSuccess(result.msg);
            tbl_view.dataSource = [];
        }
    }
    ColumnLayout {
        id: time_picker
        spacing: 10
        anchors {
            top: parent.top
            left: parent.left
        }
        FluText {
            text: "选择日期"
        }

        FluDatePicker {
            id: date_picker
        }
        FluText {
            text: "选择开始和结束时间"
        }
        RowLayout {
            id: time_row
            FluComboBox {
                id: start_time
                model: time_range
                onCurrentIndexChanged: {
                    end_time.model = time_range.slice(start_time.currentIndex + 1);
                }
                Component.onCompleted: {
                    start_time.currentIndex = time_range[0];
                }
            }
            FluComboBox {
                id: end_time
                model: []
                Component.onCompleted: {
                    start_time.currentIndex = time_range[1];
                }
            }
        }
    }
    ColumnLayout {
        spacing: 10
        anchors {
            top: parent.top
            left: time_picker.right
            leftMargin: 20
        }
        FluText {
            text: "参会人数"
        }
        FluTextBox {
            id: attendance_box
            placeholderText: "请输入参会人数"
        }
        Item {
            height: 10
        }
        FluFilledButton {
            id: fliter_btn
            text: "筛选"
            Layout.alignment: Qt.AlignHCenter
            onClicked: {
                var capacity = parseInt(attendance_box.text);
                var selectedStartTime = start_time.currentText;
                var selectedEndTime = end_time.currentText;
                var selectedDate = date_picker.current;
                var filteredRooms = db_mng.filterRooms(capacity, selectedDate, selectedStartTime, selectedEndTime);
                loadData(filteredRooms);
            }
        }
    }

    Component {
        id: edit_box
        Item {
        }
    }
    Component {
        id: operation
        Item {
            RowLayout {
                anchors.centerIn: parent
                FluButton {
                    id: detail_btn
                    text: "详情"
                    onClicked: {
                        var obj = tbl_view.dataSource[row];
                        FluApp.navigate("/room_detail", {
                                roomData: obj
                            });
                    }
                }
                FluFilledButton {
                    id: rsv_btn
                    text: "预约"
                    onClicked: {
                        var obj = tbl_view.dataSource[row];
                        var reservation = {
                            roomID: obj.RoomID,
                            attendance: parseInt(attendance_box.text),
                            date: date_picker.current.toLocaleDateString(Qt.locale("zh-CN"), "yyyy-MM-dd"),
                            startTime: start_time.currentText,
                            endTime: end_time.currentText,
                            userID: argument.UsrInfo.UserID
                        };
                        rsv_win_register.launch({
                                rsvData: reservation
                            });
                    }
                }
            }
        }
    }
    FluTableView {
        id: tbl_view
        dataSource: []
        anchors {
            top: time_picker.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            topMargin: 10
        }
        columnSource: [{
                title: "房号",
                dataIndex: "RoomID",
                width: 80,
                minimumWidth: 120,
                maximumWidth: 120,
                //禁用编辑
                editDelegate: edit_box
            }, {
                title: "名称",
                dataIndex: "RoomName",
                width: 200,
                minimumWidth: 200,
                maximumWidth: 300,
                editDelegate: edit_box
            }, {
                title: "人数容量",
                dataIndex: 'Capacity',
                width: 80,
                minimumWidth: 120,
                maximumWidth: 120,
                editDelegate: edit_box
            }, {
                title: "面积",
                dataIndex: 'RoomArea',
                width: 80,
                minimumWidth: 120,
                maximumWidth: 120,
                editDelegate: edit_box
            }, {
                title: '操作',
                dataIndex: 'operation',
                width: 160,
                minimumWidth: 160,
                maximumWidth: 160,
                delegate: operation,
                editDelegate: edit_box
            }]
    }
    function loadData(data) {
        for (var i = 0; i < data.length; ++i) {
            data[i].operation = tbl_view.customItem(operation);
        }
        tbl_view.dataSource = data;
    }
}
