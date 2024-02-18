class MyTrayMenu {

    __new() {
        this.editScript:= '编辑脚本(&E)'
        this.ListVars:= '查看变量(&L)'
        this.pause := Format("{1:-10}", "暂停 Ctrl+Alt+(&S)")
        this.restart:= '重启 Ctrl+Alt+(&R)'
        this.sou:= '搜一搜 Alt+Space(&S)'
        this.biaozhifu:= '查看窗口标识符(&V)'
        this.tongji:= '使用统计(&S)'
        this.kaijiziqi:= '开机自启(&A)'

        this.help:= '帮助(&H)'
        this.document:= '文档(&D)'
        this.video:= '视频教程(&V)'
        this.guanzhuwo:= '在 CSDN 上关注我(&F)'
        this.update:= '检查更新(&U)...'
        this.about:= '关于(&A)'

        this.exit:= '退出(&X)'

        this.linkFile := A_Startup "\jiejian.lnk"

        this.shortcut := unset
        if (A_IsCompiled) {
            this.shortcut := 'jiejian' . (A_Is64bitOS ? '64' : '32' ) . '.exe'
        } else {
            this.shortcut := 'jiejian.ahk'
        }
        this.shortcut := A_WorkingDir . '\' . this.shortcut

        MyTrayMenuHandler := this.TrayMenuHandler.Bind(this)

        ; this.regex := regex        
        if (NOT A_IsCompiled) {
            A_TrayMenu.Add(this.editScript, MyTrayMenuHandler)
            A_TrayMenu.Add(this.ListVars, MyTrayMenuHandler)
            A_TrayMenu.Add
        }
        ; 右对齐不好使，我醉了
        A_TrayMenu.Add(this.pause, MyTrayMenuHandler)
        A_TrayMenu.Add(Format("{1:-10}", this.restart), MyTrayMenuHandler)
        A_TrayMenu.Add(Format("{1:-10}", this.sou), MyTrayMenuHandler)
        A_TrayMenu.Add(this.biaozhifu, MyTrayMenuHandler)
        A_TrayMenu.Add(this.tongji, MyTrayMenuHandler)
        A_TrayMenu.Add(this.kaijiziqi, MyTrayMenuHandler)
        A_TrayMenu.Add

        ; 添加子菜单到上面的菜单中
        helpMenu := Menu()
        helpMenu.Add(this.document, MyTrayMenuHandler)
        helpMenu.Add(this.video, MyTrayMenuHandler)
        helpMenu.Add(this.guanzhuwo, MyTrayMenuHandler)
        helpMenu.Add(this.update, MyTrayMenuHandler)
        helpMenu.Add(this.about, MyTrayMenuHandler)
        A_TrayMenu.Add(this.help, helpMenu)

        A_TrayMenu.Add(this.exit, MyTrayMenuHandler)

        ; 检查是否是自启状态
        global IS_AUTO_START_UP
        isLinkFileExist := FileExist(this.LinkFile)
        if (isLinkFileExist) {
            ; 获取快捷方式(.lnk) 文件的信息, 例如其目标文件
            FileGetShortcut this.LinkFile, &OutTarget
            if (OutTarget !== this.shortcut) {
                IS_AUTO_START_UP := false
                A_TrayMenu.UnCheck(this.kaijiziqi)
            } else {
                IS_AUTO_START_UP := true
                A_TrayMenu.Check(this.kaijiziqi)
            }
        } else {
            IS_AUTO_START_UP := false
            A_TrayMenu.UnCheck(this.kaijiziqi)
        }
        A_TrayMenu.Default := this.pause
        A_TrayMenu.ClickCount := 1 ; 单击可以暂停
    }

    /**
     * 托盘菜单被点击
     * @param ItemName 
     * @param ItemPos 
     * @param MyMenu 
     */
    TrayMenuHandler(ItemName, ItemPos, MyMenu) {
        switch ItemName, 'off' {
        case this.editScript: Edit
        case this.ListVars: ListVars
        case this.pause: this.jiejianToggleSuspend
        case this.restart: jiejianReload
        case this.sou: Anyrun
        case this.biaozhifu: Run "./extra/WindowSpyU32.exe"
        case this.tongji:
            ; 统计软件使用总分钟数
            recordMinsValueName := 'record_mins'
            recordMins := RegRead(regKeyName, recordMinsValueName, 0) + DateDiff(A_NowUTC, startTime, 'Minutes')
            ; 统计软件使用次数
            launchCountValueName := 'launch_count'
            launchCount := RegRead(regKeyName, launchCountValueName, 1)
    
            sb := '总启动次数 ' . launchCount . ' 次，您目前已使用捷键 '
            if (recordMins < 60) {
                MsgBox(sb . recordMins . ' 分钟！', '使用统计')
            } else {
                sb .= recordMins // 60 . ' 小时 '
                mins := Floor(recordMins - recordMins // 60 * 60)
                if mins !== 0 {
                    sb .= mins . ' 分钟'
                }
                sb .= '！'
                MsgBox(sb, '使用统计')
            }
        case this.kaijiziqi:
            ; 当前是否是选中状态
            global IS_AUTO_START_UP
            ; 当前是开机自启
            if (IS_AUTO_START_UP) {
                ; 设置为开机不自启
                FileDelete(this.linkFile)
            } else {
                ; 设置为开机自启
                FileCreateShortcut(this.shortcut, this.linkFile, A_WorkingDir)
            }
            A_TrayMenu.ToggleCheck(this.kaijiziqi)
            IS_AUTO_START_UP := !IS_AUTO_START_UP
    
            case this.document: Run "https://gitcode.com/acc8226/jiejian/overview"
            case this.video: Run "https://www.bilibili.com/video/BV19H4y1e7hJ/"
            case this.guanzhuwo: Run "https://blog.csdn.net/acc8226"
            case this.update: checkUpdate(true)
            case this.about: MsgBox(      
            "版本: " CodeVersion
            "`n发布日期: 2024-2-18"
            "`nAHK 主程序版本: " A_AhkVersion
            "`n操作系统版本号: " A_OSVersion
            "`n计算机名: " A_ComputerName
            "`n用户登录名: " A_UserName
            "`n是否有管理员权限: " (A_IsAdmin ? '是' : '否')
            "`n系统是否 64 位: " (A_Is64bitOS ? '是' : '否')
            , APP_NAME, 'Iconi')
        case '退出(&X)': jiejianExit
        }
    }

    /**
     * 菜单中的暂停
     */
    jiejianToggleSuspend() {
        Suspend(!A_IsSuspended)
        if (A_IsSuspended) {
        A_TrayMenu.Check(this.pause)
        Tip("  暂停捷键  ", -500)
        } else {
        A_TrayMenu.UnCheck(this.pause)
        Tip("  恢复捷键  ", -500)
        }
    }

    /**
     * 快捷键用的暂停
     */
    mySuspend() {
        Suspend(!A_IsSuspended)
        A_IsSuspended ? A_TrayMenu.Check(this.pause) : A_TrayMenu.UnCheck(this.pause)   
    }
}