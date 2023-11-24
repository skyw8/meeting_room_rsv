import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.platform
import FluentUI

FluWindow {
    id: login
    title: "登录"
    width: 400
    height: 300
    minimumWidth: 400
    minimumHeight: 300
    launchMode: FluWindowType.SingleTask
    appBar: undefined
    property var result
    property var set_win_register: registerForWindowResult("/db_set")
    Connections {
        target: set_win_register
        function onResult(result) {
            showSuccess(result.msg)
        }
    }
    FluAppBar {
        id: app_bar_login
        title: "登录"
        showMinimize: false
        showMaximize: false
        showStayTop: false
        showDark: false
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        darkClickListener: button => handleDarkChanged(button)
        closeClickListener: () => {
            FluApp.exit(0);
        }
        z: 7
    }

    Timer {
        id: delayTimer
        interval: 500
        onTriggered: {
            if (login.result.UserType === "admin") {
                FluApp.navigate("/admin", {
                        UsrInfo: login.result
                    });
                login.close();
            } else if (login.result.UserType === "user") {
                FluApp.navigate("/usr", {
                        UsrInfo: login.result
                    });
                login.close();
            } else {
                console.log("未知用户类型");
            }
        }
    }
    ColumnLayout {
        anchors.fill: parent
        anchors.centerIn: parent
        spacing: 6

        FluText {
            text: "会议室预约系统"
            font: FluTextStyle.Title
            Layout.alignment: Qt.AlignHCenter
            Layout.bottomMargin: 10
        }
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            FluText {
                text: "账号"
            }
            FluTextBox {
                id: accountInput
                width: 200
                placeholderText: "请输入账号"
                Layout.preferredWidth: 200
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            FluText {
                text: "密码"
            }
            FluPasswordBox {
                id: passwordInput
                width: 200
                placeholderText: "请输入密码"
                Layout.preferredWidth: 200
            }
        }
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            FluFilledButton {
                id: login_btn
                text: "登录"
                onClicked: {
                    if(db_mng.isDbOpen()===false){
                        showError("数据库未连接");
                        return;
                    }
                    login.result = db_mng.auth(accountInput.text.toString(), passwordInput.text);
                    if (!result.isValid) {
                        showError("请输入正确的账号和密码");
                    } else {
                        showSuccess("登录成功");
                        delayTimer.start();
                    }
                }
            }
        }
    }
    FluIconButton {
        iconSource: FluentIcons.Settings
        anchors {
            left: parent.left
            bottom: parent.bottom
        }
        onClicked: {
            set_win_register.launch()
        }
    }
}
