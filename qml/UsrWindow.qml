import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.platform
import FluentUI
import meeting_room_rsv
//import "qrc:/meeting_room_rsv/qml/global"
//import "qrc:/meeting_room_rsv/qml/viewmodel"



FluWindow {

    id:window
    title: "会议室预约系统"
    width: 1000
    height: 640
    minimumWidth: 520
    minimumHeight: 200
    launchMode: FluWindowType.SingleTask
    appBar: undefined
    Component.onCompleted:{
        console.log("usrname: ",argument.UsrInfo.UserID)
    }

    SystemTrayIcon {
        id:system_tray
        visible: true
        icon.source: "qrc:meeting_room_rsv/res/rsv.png"
        tooltip: "会议室预约系统"
        menu: Menu {
            MenuItem {
                text: "退出"
                onTriggered: {
                    FluApp.exit()
                }
            }
        }
        onActivated:
            (reason)=>{
                if(reason === SystemTrayIcon.Trigger){
                    window.show()
                    window.raise()
                    window.requestActivate()
                }
            }
    }

    FluContentDialog{
        id:dialog_close
        title:"退出"
        message:"确定要退出程序吗？"
        negativeText:"最小化"
        buttonFlags: FluContentDialogType.NegativeButton | FluContentDialogType.NeutralButton | FluContentDialogType.PositiveButton
        onNegativeClicked:{
            window.hide()
            system_tray.showMessage("友情提示","程序已隐藏至托盘,点击托盘可再次激活窗口");
        }
        positiveText:"退出"
        neutralText:"取消"
        onPositiveClicked:{
            FluApp.exit(0)
        }
    }

    Component{
        id:nav_item_right_menu
        FluMenu{
            id:menu
            width: 130
            FluMenuItem{
                text: "在独立窗口打开"
                visible: true
                onClicked: {
                    FluApp.navigate("/page_window",{title:modelData.title,url:modelData.url})
                }
            }
        }
    }


    FluAppBar {
        id:app_bar
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        showDark: true
        darkClickListener:(button)=>handleDarkChanged(button)
        closeClickListener: ()=>{dialog_close.open()}
        z:7
    }

    FluObject{

        property var navigationView
        property var paneItemMenu

        id:footer_items

        FluPaneItemSeparator{}


        FluPaneItem{
            title:"设置"
            menuDelegate: footer_items.paneItemMenu
            icon:FluentIcons.Settings
            url:"qrc:meeting_room_rsv/qml/page/SettingsPage.qml"
            onTap:{
                footer_items.navigationView.push(url)
            }
        }

    }
    FluObject{

        property var navigationView
        property var paneItemMenu
        id:usr_items
        function rename(item, newName){
            if(newName && newName.trim().length>0){
                item.title = newName;
            }
        }
        FluPaneItem{
            id:rsv_page
            title:"会议室预约"
            icon:FluentIcons.ContactPresence
            menuDelegate: usr_items.paneItemMenu
            url:"qrc:meeting_room_rsv/qml/page/usr/RsvPage.qml"
            onTap:{
                usr_items.navigationView.push(url)
            }
        }

        FluPaneItem{
            id:chk_rsv_page
            title:"查看预约"
            icon:FluentIcons.PhoneBook
            menuDelegate: usr_items.paneItemMenu
            url:"qrc:meeting_room_rsv/qml/page/usr/RsvCheckPage.qml"
            onTap:{
                usr_items.navigationView.push(url)
            }

        }
        FluPaneItem{
            id:room_check_page
            title:"查看会议室"
            icon:FluentIcons.BuildingEnergy
            menuDelegate: usr_items.paneItemMenu
            url:"qrc:meeting_room_rsv/qml/page/usr/RoomCheckPage.qml"
            onTap:{
                usr_items.navigationView.push(url)
            }
        }
    }

    FluNavigationView{
        id:nav_view
        width: parent.width
        height: parent.height
        cellWidth: 200
        z:999
        //Stack模式，每次切换都会将页面压入栈中，随着栈的页面增多，消耗的内存也越多，内存消耗多就会卡顿，这时候就需要按返回将页面pop掉，释放内存。该模式可以配合FluPage中的launchMode属性，设置页面的启动模式
        //                pageMode: FluNavigationViewType.Stack
        //NoStack模式，每次切换都会销毁之前的页面然后创建一个新的页面，只需消耗少量内存，可以配合FluViewModel保存页面数据（推荐）
        pageMode: FluNavigationViewType.NoStack
        items: usr_items
        footerItems: footer_items
        topPadding: FluTools.isMacos() ? 20 : 0
        logo: "qrc:meeting_room_rsv/res/rsv.png"
        title: "会议室预约系统"
        Component.onCompleted: {
            usr_items.navigationView = nav_view
            usr_items.paneItemMenu = nav_item_right_menu
            footer_items.navigationView = nav_view
            footer_items.paneItemMenu = nav_item_right_menu
            setCurrentIndex(0)
            console.log(footerItems)
        }
        Component.onDestruction:{
            console.log(footerItems)
        }
    }
    Component{
        id:com_reveal
        CircularReveal{
            id:reveal
            target:window.contentItem
            anchors.fill: parent
            onAnimationFinished:{
                //动画结束后释放资源
                loader_reveal.sourceComponent = undefined
            }
            onImageChanged: {
                changeDark()
            }
        }
    }

    FluLoader{
        id:loader_reveal
        anchors.fill: parent
    }

    function distance(x1,y1,x2,y2){
        return Math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))
    }

    function handleDarkChanged(button){
        if(!FluTheme.enableAnimation){
            changeDark()
        }else{
            loader_reveal.sourceComponent = com_reveal
            var target = window.contentItem
            var pos = button.mapToItem(target,0,0)
            var mouseX = pos.x
            var mouseY = pos.y
            var radius = Math.max(distance(mouseX,mouseY,0,0),distance(mouseX,mouseY,target.width,0),distance(mouseX,mouseY,0,target.height),distance(mouseX,mouseY,target.width,target.height))
            var reveal = loader_reveal.item
            reveal.start(reveal.width*Screen.devicePixelRatio,reveal.height*Screen.devicePixelRatio,Qt.point(mouseX,mouseY),radius)
        }
    }

    function changeDark(){
        if(FluTheme.dark){
            FluTheme.darkMode = FluThemeType.Light
        }else{
            FluTheme.darkMode = FluThemeType.Dark
        }
    }
    
}
