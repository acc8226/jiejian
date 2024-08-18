class MyTrayMenu {
    
    __new() {
        ; 当前是否是选中状态
        GLOBAL IS_AUTO_START_UP

        this.editScript:= '编辑脚本(&E)'
        this.listVars:= '查看变量(&L)'
        this.pause := "暂停(Ctrl+Alt+S)"
        this.restart:= '重载程序(Ctrl+Alt+R)'
        this.search:= '搜一搜(Alt+空格)'
        this.viewWinId:= '查看窗口标识符(&V)'
        this.statistics:= '使用统计(&S)'
        this.startUp:= '开机自启(&A)'

        this.more:= '更多(&M)'
        this.document:= '帮助文档(&H)'
        this.video:= '视频教程(&V)'
        this.followMeCSDN:= '在 CSDN 上关注我(&F)'
        this.followMeGH:= '在 Github 上关注我(&F)'
        this.update:= '检查更新(&U)...'
        this.about:= '关于(&A)'

        this.exit:= '退出(&X)'

        ; 快捷方式以 lnk 结尾
        this.linkFile := A_Startup "\jiejian.lnk"

        this.shortcut := unset
        if A_IsCompiled
            this.shortcut := 'jiejian' . (A_Is64bitOS ? '64' : '32' ) . '.exe'
        else
            this.shortcut := 'jiejian.ahk'
        this.shortcut := A_WorkingDir . '\' . this.shortcut

        myTrayMenuHandler := this.TrayMenuHandler.Bind(this)

        ; 删除原有的 菜单项
        A_TrayMenu.Delete()
        if (NOT A_IsCompiled) {
            A_TrayMenu.Add(this.editScript, myTrayMenuHandler)
            A_TrayMenu.Add(this.listVars, myTrayMenuHandler)
            A_TrayMenu.Add
        }
        ; 右对齐不好使，我醉了
        A_TrayMenu.Add(this.pause, myTrayMenuHandler)
        A_TrayMenu.Add(Format("{1:-10}", this.restart), myTrayMenuHandler)
        A_TrayMenu.Add(Format("{1:-10}", this.search), myTrayMenuHandler)
        A_TrayMenu.Add(this.viewWinId, myTrayMenuHandler)
        A_TrayMenu.Add(this.statistics, myTrayMenuHandler)
        A_TrayMenu.Add(this.startUp, myTrayMenuHandler)
        A_TrayMenu.Add

        ; 添加子菜单到上面的菜单中
        moreMenu := Menu()
        moreMenu.Add(this.document, myTrayMenuHandler)
        moreMenu.Add(this.video, myTrayMenuHandler)
        moreMenu.Add(this.followMeCSDN, myTrayMenuHandler)
        moreMenu.Add(this.followMeGH, myTrayMenuHandler)
        moreMenu.Add(this.update, myTrayMenuHandler)
        moreMenu.Add(this.about, myTrayMenuHandler)
        A_TrayMenu.Add(this.more, moreMenu)

        A_TrayMenu.Add(this.exit, myTrayMenuHandler)

        ; 检查是否是自启状态
        if (FileExist(this.LinkFile)) {
            ; 获取快捷方式(.lnk) 文件的信息, 例如其目标文件
            FileGetShortcut(this.LinkFile, &OutTarget)
            if (OutTarget !== this.shortcut) {
                IS_AUTO_START_UP := false
                A_TrayMenu.UnCheck(this.startUp)
            } else {
                IS_AUTO_START_UP := true
                A_TrayMenu.Check(this.startUp)
            }
        } else {
            IS_AUTO_START_UP := false
            A_TrayMenu.UnCheck(this.startUp)
        }
        A_TrayMenu.Default := this.pause
        A_TrayMenu.ClickCount := 1 ; 单击可以暂停
    }

    /**
     * 托盘菜单被点击
     * 
     * @param ItemName
     * @param ItemPos 
     * @param MyMenu
     */
    TrayMenuHandler(ItemName, ItemPos, MyMenu) {        
        GLOBAL IS_AUTO_START_UP

        switch ItemName, 'off' {
        case this.editScript: Edit
        case this.listVars: ListVars
        case this.pause: this.jiejianToggleSuspend
        case this.restart: Reload
        case this.search: anyrun
        case this.viewWinId: Run("extra/WindowSpyU32.exe")
        case this.statistics:
            ; 统计软件使用总分钟数
            recordMinsValueName := 'record_mins'
            recordMins := RegRead(REG_KEY_NAME, recordMinsValueName, 0) + DateDiff(A_NowUTC, START_TIME, 'Minutes')
            ; 统计软件使用次数
            launchCountValueName := 'launch_count'
            launchCount := RegRead(REG_KEY_NAME, launchCountValueName, 1)
    
            sb := '总启动次数 ' . launchCount . ' 次，您目前已使用捷键 ' . recordMins . ' 分钟'
            if (recordMins >= 60) {
                sb .= '（约 '
                recordYears := recordMins // (365 * 24 * 60)
                if recordYears > 0
                    sb .= recordYears . ' 年 '
                recordDays := recordMins // (24 * 60) - recordYears * 365
                if recordDays >= 1
                    sb .= recordDays . ' 天 '
                recordHours := recordMins // 60 - recordYears * 365 * 24 - recordDays * 24
                if recordHours >= 1
                    sb .= recordHours . ' 小时 '
                mins := recordMins - recordMins // 60 * 60
                if mins >= 1
                    sb .= mins . ' 分钟'
                sb .= '）'
            }                     
            MsgBox(sb, '使用统计')
        case this.startUp:
            ; 当前是开机自启则设置为开机不自启，否则设置为开机自启
            if IS_AUTO_START_UP
                FileDelete(this.linkFile)
            else
                FileCreateShortcut(this.shortcut, this.linkFile, A_WorkingDir)
            A_TrayMenu.ToggleCheck(this.startUp)
            IS_AUTO_START_UP := !IS_AUTO_START_UP
    
            ; case this.document: Run('https://acc8226.pages.dev/mypage/jumpJiejian') 备用
            case this.document: Run('http://acc8226.test.upcdn.net') ; 还是选用国内服务访问最快
            case this.video: Run('https://www.bilibili.com/video/BV19H4y1e7hJ')
            case this.followMeCSDN: Run('https://blog.csdn.net/acc8226')
            case this.followMeGH: Run('https://github.com/acc8226')
            case this.update: checkUpdate(true)
            case this.about: MsgBox(      
                '版本: ' . CODE_VERSION
                . "`nAHK 主程序版本: " . A_AhkVersion
                . "`nWindows " . A_OSVersion . (A_Is64bitOS ? ' x64' : '')
                . "`n计算机名: " . A_ComputerName
                . "`n当前用户: " . A_UserName
                . "`n是否管理员权限运行: " . (A_IsAdmin ? '是' : '否')
                . "`n是否 64 位程式: " . (A_PtrSize == 8 ? '是' : '否')
                , APP_NAME, 'Iconi T60')
        case this.exit: ExitApp
        }
    }

    /**
     * 菜单中的暂停
     */
    jiejianToggleSuspend() {
        Suspend(!A_IsSuspended)
        if (A_IsSuspended) {
            A_TrayMenu.Check(this.pause)
            Tip('  暂停捷键  ', -500)
        } else {
            A_TrayMenu.UnCheck(this.pause)
            Tip('  恢复捷键  ', -500)
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