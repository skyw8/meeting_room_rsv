import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Dialogs
import FluentUI
FluWindow {
    id: room_add
    title: "添加"
    width: 400
    height: 600
    minimumWidth: 400
    maximumWidth: 400
    minimumHeight: 600
    maximumHeight: 600
    fixSize: true
    launchMode: FluWindowType.SingleTask
    appBar: undefined
    Component.onCompleted: {
    }
    FluAppBar {
        id: app_bar
        title: "添加"
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
    ColumnLayout {
        anchors {
            fill: parent
            centerIn: parent
            leftMargin: 30
            topMargin:20
        }
        spacing: 3
        RowLayout {
            FluText {
                text: "房号"
                font: FluTextStyle.BodyStrong
            }
            FluTextBox {
                id: room_id_box
                placeholderText: "请输入房号"
                Layout.preferredWidth: 150
            }
        }

        RowLayout {
            FluText {
                text: "名称"
                font: FluTextStyle.BodyStrong
            }
            FluTextBox {
                id: room_name_box
                placeholderText: "请输入名称"
                Layout.preferredWidth: 150
            }
        }

        RowLayout {
            FluText {
                text: "人数容量"
                font: FluTextStyle.BodyStrong
            }
            FluTextBox {
                id: capacity_box
                placeholderText: "请输入人数容量"
                Layout.preferredWidth: 150
            }
        }

        RowLayout {
            FluText {
                text: "面积"
                font: FluTextStyle.BodyStrong
            }
            FluTextBox {
                id: room_area_box
                placeholderText: "请输入面积"
                Layout.preferredWidth: 150
            }
        }

        RowLayout {
            FluText {
                text: "描述"
                font: FluTextStyle.BodyStrong
            }
            FluMultilineTextBox {
                id: description_box
                placeholderText: "请输入描述"
                Layout.preferredWidth: 300
            }
        }

        RowLayout {
            FluFilledButton {
                text: "选择图片"
                onClicked: fileDialog.open()  // 打开文件对话框
            }

            FileDialog {
                id: fileDialog
                title: "选择图片"
                fileMode: FileDialog.OpenFile
                nameFilters: ["Image files (*.jpeg *.jpg *.png)"]  // 设置文件过滤器
                onAccepted: {
                    imagePreview.source = selectedFile;
                    
                }
            }
        }

        Image {
            id: imagePreview
            width: parent.width // 图像宽度与父组件宽度相同
            height: 80 // 固定高度，可根据需求调整
            sourceSize.width: parent.width // 限制加载的图像宽度
            sourceSize.height: 80
        }
        FluFilledButton {
            text: "保存"
            Layout.alignment: Qt.AlignHCenter
            onClicked:
            // 验证数据并保存
            {
                var roomID = room_id_box.text;
                var roomName = room_name_box.text;
                var capacity = parseInt(capacity_box.text);
                var roomArea = parseFloat(room_area_box.text);
                var description = description_box.text;
                var photoPath = imagePreview.source.toString().substring(8);

                // TODO: 进行数据验证

                // 添加到数据库
                var success = db_mng.addRoom(roomID, roomName, capacity, roomArea, description, photoPath);
                if (success) {
                    showSuccess("数据保存成功")
                    onResult({msg:"添加保存成功"})
                    room_add.close()
                } else {
                    showError("数据保存失败")
                }
            }
        }
    }
}
