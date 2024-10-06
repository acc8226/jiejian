class MyTrayMenu {
    
    __new() {
        ; 当前是否是选中状态
        GLOBAL IS_AUTO_START_UP

        ; 读取当前语言状态，如果读取不到则默认是中文
        LANG_PATH := A_ScriptDir "\lang\" . settingLanguage . ".ini"

        try
            this.editScript:= IniRead(LANG_PATH, "Tray", "editScript")
        catch as e {
            ; 发生 error，语言恢复成英文
            MsgBox "An error was thrown!`nSpecifically: " e.Message
            global settingLanguage := 'en'
            LANG_PATH := A_ScriptDir "\lang\" . settingLanguage . ".ini"
            this.editScript:= IniRead(LANG_PATH, "Tray", "editScript")
        }        
        this.listVars:= IniRead(LANG_PATH, "Tray", "listVars")

        this.pause := IniRead(LANG_PATH, "Tray", "pause")
        this.restart:= IniRead(LANG_PATH, "Tray", "restart")
        this.search:= IniRead(LANG_PATH, "Tray", "search")
        this.startUp:= IniRead(LANG_PATH, "Tray", "startUp")

        this.more:= IniRead(LANG_PATH, "Tray", "more")
        this.document:= IniRead(LANG_PATH, "Tray", "document")
        this.video:= IniRead(LANG_PATH, "Tray", "video")
        this.statistics:= IniRead(LANG_PATH, "Tray", "statistics")
        this.viewWinId:= IniRead(LANG_PATH, "Tray", "viewWinId")
        this.followMeCSDN:= IniRead(LANG_PATH, "Tray", "followMeCSDN")
        this.followMeGH:= IniRead(LANG_PATH, "Tray", "followMeGH")
        this.update:= IniRead(LANG_PATH, "Tray", "update")
        this.about:= IniRead(LANG_PATH, "Tray", "about")

        this.switchLang:= IniRead(LANG_PATH, "Tray", "switchLang")

        this.exit:= IniRead(LANG_PATH, "Tray", "exit")

        this.langMenu := Menu()

        ; 快捷方式以 lnk 结尾
        this.linkFile := A_Startup . "\jiejian.lnk"

        this.shortcut := unset
        if A_IsCompiled
            this.shortcut := 'jiejian' . (A_Is64bitOS ? '64' : '32' ) . '.exe'
        else
            this.shortcut := 'jiejian.ahk'
        this.shortcut := A_WorkingDir . '\' . this.shortcut

        trayMenuHandlerFunc := this.TrayMenuHandler.Bind(this)

        ; 删除原有的 菜单项
        A_TrayMenu.Delete()
        if (NOT A_IsCompiled) {
            A_TrayMenu.Add(this.editScript, trayMenuHandlerFunc)
            A_TrayMenu.Add(this.listVars, trayMenuHandlerFunc)
            A_TrayMenu.Add
        }
        
        ; 右对齐不好使，我醉了
        A_TrayMenu.Add(this.pause, trayMenuHandlerFunc)
        A_TrayMenu.Add(this.restart, trayMenuHandlerFunc)
        A_TrayMenu.Add(this.search, trayMenuHandlerFunc)
        A_TrayMenu.Add(this.startUp, trayMenuHandlerFunc)
        ; 切换语言
        A_TrayMenu.Add(this.switchLang, this.langMenu)
        this.createLangMenu()

        ; 添加子菜单到上面的菜单中
        moreMenu := Menu()
        moreMenu.Add(this.document, trayMenuHandlerFunc)
        moreMenu.Add(this.video, trayMenuHandlerFunc)
        moreMenu.Add(this.statistics, trayMenuHandlerFunc)
        moreMenu.Add(this.viewWinId, trayMenuHandlerFunc)
        moreMenu.Add(this.followMeCSDN, trayMenuHandlerFunc)
        moreMenu.Add(this.followMeGH, trayMenuHandlerFunc)
        moreMenu.Add(this.update, trayMenuHandlerFunc)
        moreMenu.Add(this.about, trayMenuHandlerFunc)
        A_TrayMenu.Add(this.more, moreMenu)

        A_TrayMenu.Add(this.exit, trayMenuHandlerFunc)

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

    createLangMenu() {
        this.langMenu.Delete

        switchLanguageFunc := this.switchLanguage.Bind(this)
        Loop Files A_ScriptDir "\lang\*.ini" {
            SplitPath A_LoopFileName, , , , &FileNameNoExt
            if (FileNameNoExt == 'zh-Hans') {
                this.langMenu.Add('简体中文', switchLanguageFunc)
            } else if (FileNameNoExt == 'zh-Hant') {
                this.langMenu.Add('繁体中文', switchLanguageFunc)
            } else {
                this.langMenu.Add(FileNameNoExt, switchLanguageFunc)
            }
        }

        switch settingLanguage {
            case 'zh-Hans': this.langMenu.Check('简体中文')
            case 'zh-Hant': this.langMenu.Check('繁体中文') 
            default: this.langMenu.Check(settingLanguage)
        }
    }

    switchLanguage(ItemName, ItemPos, MyMenu) {
        switch ItemName {
            case '简体中文': global settingLanguage := 'zh-Hans'
            case '繁体中文': global settingLanguage := 'zh-Hant'     
            default: global settingLanguage := ItemName
        }
        Reload
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
            case this.pause: this.toggleSuspend
            case this.restart: Reload
            case this.search: anyrun

            case this.viewWinId: Run("extra/WindowSpyU32.exe")
            case this.statistics:
                ; 统计软件使用总分钟数
                recordMins := RegRead(REG_KEY_NAME, REG_RECORD_MINS, 0) + DateDiff(A_NowUTC, START_TIME, 'Minutes')
                ; 统计软件使用次数
                launchCount := RegRead(REG_KEY_NAME, REG_LAUNCH_COUNT, 1)
        
                if recordMins < 10000
                    tit := '青铜'
                else if recordMins < 20000
                    tit := '白银'
                else if recordMins < 40000
                    tit := '黄金'
                else if recordMins < 80000
                    tit := '铂金'
                else if recordMins < 160000
                    tit := '钻石'
                else
                    tit := '传说'
                sb := '尊敬的' . tit . '用户：`n' . '　　您当前总启动次数 ' . launchCount . ' 次，您目前已使用捷键 ' . recordMins . ' 分钟'
                if (recordMins >= 60) {
                    sb .= '（'
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
                MsgBox(sb, '捷键-使用统计')
            case this.startUp:
                ; 当前是开机自启则设置为开机不自启，否则设置为开机自启
                if IS_AUTO_START_UP
                    FileDelete(this.linkFile)
                else
                    FileCreateShortcut(this.shortcut, this.linkFile, A_WorkingDir)
                A_TrayMenu.ToggleCheck(this.startUp)
                IS_AUTO_START_UP := !IS_AUTO_START_UP
        
            case this.document: Run('http://acc8226.test.upcdn.net') ; 还是选用国内服务访问最快
            case this.video: Run('https://www.bilibili.com/video/BV19H4y1e7hJ')

            case this.followMeCSDN: Run('https://blog.csdn.net/acc8226')
            case this.followMeGH: Run('https://github.com/acc8226')
            case this.update: checkUpdate(true)
            case this.about: this.aboutFunc
            case this.exit: ExitApp
        }
    }

    /**
     * 菜单中的暂停
     */
    toggleSuspend() {
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

    aboutFunc(){
        MsgBox(      
            '版本: ' . CODE_VERSION
            . "`nAHK 主程序版本: " . A_AhkVersion
            . "`n系统默认语言: " . this.localLang(A_Language)
            . "`nWindows " . A_OSVersion . (A_Is64bitOS ? ' 64 位' : '')
            . "`n计算机名: " . A_ComputerName
            . "`n当前用户: " . A_UserName
            . "`n是否管理员权限运行: " . (A_IsAdmin ? '是' : '否')
            . "`n是否 64 位程式: " . (A_PtrSize == 8 ? '是' : '否')
            , APP_NAME, 'Iconi T60')
    }

    localLang(language) {
        if language = '7804'
            return '中文'
        else if language = '0004'
            return '简体中文'
        else if language = '0804'
            return '简体中文（中国）'
        else if language = '1004'
            return '简体中文（新加坡）'
        else if language = '7C04'
            return '繁体中文'
        else if language = '0C04'
            return '繁体中文（香港特别行政区）'
        else if language = '1404'
            return '繁体中文（澳门特别行政区）'
        else if language = '0404'
            return '繁体中文（台湾）'
        LCID := Integer('0x' . language)
        LOCALE_ALLOW_NEUTRAL_NAMES := 0x08000000
        LOCALE_SENGLISHDISPLAYNAME := 0x72
        LocaleName := this.LCIDToLocaleName(LCID, LOCALE_ALLOW_NEUTRAL_NAMES)
        if LocaleName {
            DisplayName := this.GetLocaleInfo(LocaleName, LOCALE_SENGLISHDISPLAYNAME)
        } else {
            DisplayName := 'unknown'
        }
        return DisplayName      
    }

    LCIDToLocaleName(LCID, Flags := 0) {
        reqBufSize := DllCall("LCIDToLocaleName", "UInt", LCID, "Ptr", 0, "UInt", 0, "UInt", Flags)
        out := Buffer(reqBufSize*2)
        DllCall("LCIDToLocaleName", "UInt", LCID, "Ptr", out, "UInt", out.Size, "UInt", Flags)
        return StrGet(out)
    }

    GetLocaleInfo(LocaleName, LCType) {
        reqBufSize := DllCall("GetLocaleInfoEx", "Str", LocaleName, "UInt", LCType, "Ptr", 0, "UInt", 0)
        out := Buffer(reqBufSize*2)
        DllCall("GetLocaleInfoEx", "Str", LocaleName, "UInt", LCType, "Ptr", out, "UInt", out.Size)
        return StrGet(out)
    }
}

initLanguage() {
    folderCheckList := ['lang']
    for item in folderCheckList
        If !FileExist(A_ScriptDir . '\' . item)
            DirCreate(A_ScriptDir . '\' . item)
    ; 在已编译的脚本中包含指定的文件
    if (A_IsCompiled) {
        ; 要添加到已编译可执行文件中的文件名. 如果没有指定绝对路径, 则假定该文件位于(或相对于) 脚本自己的目录中
        FileInstall('lang\ar.ini', 'lang\ar.ini')
        FileInstall('lang\de.ini', 'lang\de.ini')
        FileInstall('lang\en.ini', 'lang\en.ini')
        FileInstall('lang\es.ini', 'lang\es.ini')
        FileInstall('lang\fr.ini', 'lang\fr.ini')
        FileInstall('lang\it.ini', 'lang\it.ini')
        FileInstall('lang\ja.ini', 'lang\ja.ini')
        FileInstall('lang\ko.ini', 'lang\ko.ini')
        FileInstall('lang\pt.ini', 'lang\pt.ini')
        FileInstall('lang\ru.ini', 'lang\ru.ini')
        FileInstall('lang\tr.ini', 'lang\tr.ini')
        FileInstall('lang\zh-Hans.ini', 'lang\zh-Hans.ini')
        FileInstall('lang\zh-Hant.ini', 'lang\zh-Hant.ini')
    }
}
