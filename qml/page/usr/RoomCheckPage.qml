import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import FluentUI
import meeting_room_rsv
FluContentPage {
    id: root_page
    title: "会议室情况"
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
                        var obj = tbl_view.dataSource[currentRowIndex]
                        console.log("传递的数据：", JSON.stringify(obj))
                        console.log("查看详情", obj.RoomID)
                        FluApp.navigate("/room_detail", {roomData: obj});
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
        id: room_srch
        anchors {
            left: parent.left
            top: parent.top
            margins: 20
        }
        placeholderText: "输入房号或名称搜索"
    }
    FluFilledButton {
        id: srch_btn
        anchors {
            left: room_srch.right
            top: parent.top
            margins: 20
        }
        text: "搜索"
        onClicked: {
            var searchText = room_srch.text;
            var searchResult = db_mng.searchRooms(searchText);
            updateTableData(searchResult);
        }
    }

    FluTableView {
        id: tbl_view
        dataSource: []
        anchors {
            left: parent.left
            right: parent.right
            top: srch_btn.bottom
            bottom: parent.bottom
        }

        anchors.topMargin: 20
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
        Component.onCompleted: {
        }
    }
    function load_data() {
        var dataSource = db_mng.get_tbl_data("MeetingRooms");
        for (var i = 0; i < dataSource.length; ++i) {
            dataSource[i].operation = tbl_view.customItem(operation);
        }
        tbl_view.dataSource = dataSource;
    }
    function updateTableData(data) {
        for (var i = 0; i < data.length; ++i) {
            data[i].operation = tbl_view.customItem(operation);
        }
        tbl_view.dataSource = data;
    }
}
