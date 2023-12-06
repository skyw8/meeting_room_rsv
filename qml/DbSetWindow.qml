import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.platform
import FluentUI

FluWindow {
    id: db_set
    title: "设置"
    width: 300
    height: 300
    minimumWidth: 300
    maximumWidth: 300
    minimumHeight: 300
    maximumHeight: 300
    fixSize: true
    launchMode: FluWindowType.SingleTask
    appBar: FluAppBar {
        id: app_bar
        width: db_set.width
        height: 30
        title: "设置"
        showMinimize: false
        showMaximize: false
        showDark: false
        showStayTop: false
        z: 7
    }
    Component.onCompleted: {
        // var info=db_mng.getDbInfo()
        ip_input.text = SettingsHelper.getHostName();
        name_input.text = SettingsHelper.getDbName();
        usr_input.text = SettingsHelper.getUserName();
        pswd_input.text = SettingsHelper.getPassword();
    }
    ColumnLayout {
        anchors {
            fill: parent
            centerIn: parent
            topMargin: 20
        }
        spacing: 3

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            FluText {
                text: "主机IP"
            }
            FluTextBox {
                id: ip_input
                placeholderText: "请输入目标IP"
                Layout.preferredWidth: 200
            }
        }
        RowLayout {
            Layout.alignment: Qt.AlignHCenter

            FluText {
                text: "数据库名称"
            }
            FluTextBox {
                id: name_input
                placeholderText: "请输入数据库名称"
                Layout.preferredWidth: 200
            }
        }
        RowLayout {
            Layout.alignment: Qt.AlignHCenter

            FluText {
                text: "用户名"
            }
            FluTextBox {
                id: usr_input
                placeholderText: "请输入用户名"
                Layout.preferredWidth: 200
            }
        }
        RowLayout {
            Layout.alignment: Qt.AlignHCenter

            FluText {
                text: "密码"
            }
            FluPasswordBox {
                id: pswd_input
                placeholderText: "请输入密码"
                Layout.preferredWidth: 200
            }
        }
        FluFilledButton {
            text: "保存"
            Layout.alignment: Qt.AlignHCenter
            onClicked: {
                var success = db_mng.setup(ip_input.text, name_input.text, usr_input.text, pswd_input.text);
                if (success) {
                    onResult({
                            msg: "数据库已连接"
                        });
                    db_set.close();
                } else {
                    showError("数据库连接失败");
                }
            }
        }
    }
}
