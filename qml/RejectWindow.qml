import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Dialogs
import FluentUI

FluWindow {
    id: reject
    width: 350
    height: 350
    minimumWidth: 350
    maximumWidth: 350
    minimumHeight: 350
    maximumHeight: 350
    fixSize: true
    launchMode: FluWindowType.SingleTask
    appBar: undefined
    Component.onCompleted: {
    }
    FluAppBar {
        id: app_bar
        title: "详情"
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
            topMargin: 20
        }
        FluText {
            text: "驳回原因"
            font: FluTextStyle.BodyStrong
            Layout.alignment: Qt.AlignHCenter
        }
        FluMultilineTextBox {
            id: reject_reason
            placeholderText: "请输入驳回原因"
            Layout.preferredHeight: 100
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 200
        }
        FluFilledButton {
            id: reject_btn
            text: "提交"
            Layout.alignment: Qt.AlignHCenter
            onClicked: {
                var result = db_mng.rejectReservation(argument.logData.reservationID, argument.logData.approverID, reject_reason.text);
                if(result)
                {
                    console.log("操作成功")
                    showError("操作成功")
                    onResult({msg: "驳回成功"})
                    reject.close()
                }
                else
                {
                    console.log("操作失败")
                    showError("操作失败")
                }
                
            }
        }
    }
}
