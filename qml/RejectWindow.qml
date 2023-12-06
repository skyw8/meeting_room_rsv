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
    launchMode: FluWindowType.SingleTask
    appBar: FluAppBar {
        id: app_bar
        title: "驳回"
        width: reject.width
        height: 30
        showMinimize: false
        showMaximize: false
        showDark: false
        z: 7
    }
    Component.onCompleted: {
    }
    ColumnLayout {
        anchors {
            fill: parent
            centerIn: parent
            topMargin: 20
            bottomMargin: 10
        }
        FluText {
            text: "驳回原因"
            font: FluTextStyle.BodyStrong
            Layout.alignment: Qt.AlignHCenter
        }
        FluMultilineTextBox {
            id: reject_reason
            placeholderText: "请输入驳回原因"
            Layout.preferredHeight: 180
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 300
        }
        FluFilledButton {
            id: reject_btn
            text: "提交"
            Layout.alignment: Qt.AlignHCenter
            onClicked: {
                var result = db_mng.rejectRsv(argument.logData.reservationID, argument.logData.approverID, reject_reason.text);
                if(result)
                {
                    showError("操作成功")
                    onResult({msg: "驳回成功"})
                    reject.close()
                }
                else
                {
                    showError("操作失败")
                }
                
            }
        }
    }
}
