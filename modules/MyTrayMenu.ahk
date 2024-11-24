

class MyTrayMenu {
    
    __new() {
        ; 当前是否是选中状态
        GLOBAL IS_AUTO_START_UP
        ; 是否启用定时提醒
        GLOBAL ENABLE_DARK_MODE := RegRead(REG_KEY_NAME, REG_DARK_MODE, true)
        GLOBAL ENABLE_TIMER_REMINDER := RegRead(REG_KEY_NAME, REG_RELAX_REMINDER, false)

        ; 读取当前语言状态，如果读取不到则默认是中文
        LANG_PATH := A_ScriptDir . "\lang\" . CURRENT_LANG . ".ini"

        try {
            this.editScript:= IniRead(LANG_PATH, "Tray", "editScript")
        } catch as e {
            ; 发生 error，语言恢复成英文
            MsgBox "An error was thrown!`nSpecifically: " e.Message
            global CURRENT_LANG := 'en'
            LANG_PATH := A_ScriptDir "\lang\" . CURRENT_LANG . ".ini"
            this.editScript:= IniRead(LANG_PATH, "Tray", "editScript", 'Edit Script (&E)')
        }
        this.listVars:= IniRead(LANG_PATH, "Tray", "listVars", 'List Variables')

        this.pause := IniRead(LANG_PATH, "Tray", "pause", 'Disable Shortcuts (&S)')
        this.restart:= IniRead(LANG_PATH, "Tray", "restart", 'Restart Program (&R)')
        this.search:= IniRead(LANG_PATH, "Tray", "search", 'Search (&Q)')
        this.startUp:= IniRead(LANG_PATH, "Tray", "startUp", 'Startup on Boot')

        this.switchLang:= IniRead(LANG_PATH, "Tray", "switchLang", 'Language (&L)')

        this.more:= IniRead(LANG_PATH, "Tray", "more", 'More (&M)')
        this.document:= IniRead(LANG_PATH, "Tray", "document", 'Help Documentation (&H)')
        this.video:= IniRead(LANG_PATH, "Tray", "video", 'Video Tutorial (&V)')
        this.statistics:= IniRead(LANG_PATH, "Tray", "statistics", 'Usage Statistics (&S)')
        this.viewWinId:= IniRead(LANG_PATH, "Tray", "viewWinId", 'View Window Identifier (&V)')
        this.followMeCSDN:= IniRead(LANG_PATH, "Tray", "followMeCSDN", 'Follow Me on CSDN (&F)')
        this.softwareHomepage:= IniRead(LANG_PATH, "Tray", "followMeGH", 'Software Homepage (&G)')
        this.enableDarkMode:= IniRead(LANG_PATH, "Tray", "enableDarkMode", "Enable Dark Mode")
        this.enableTimerReminder:= IniRead(LANG_PATH, "Tray", "enableTimerReminder", "Enable Eye Care Reminder")
        this.update:= IniRead(LANG_PATH, "Tray", "update", 'Check for Updates (&U)...')
        this.about:= IniRead(LANG_PATH, "Tray", "about", 'About (&A)')     

        this.exit:= IniRead(LANG_PATH, "Tray", "exit", 'Exit (&X)')

        ; 快捷方式以 lnk 结尾
        this.linkFile := A_Startup . "\jiejian.lnk"

        if A_IsCompiled
            this.shortcut := 'jiejian' . (A_Is64bitOS ? '64' : '32' ) . '.exe'
        else
            this.shortcut := 'jiejian.ahk'
        this.shortcut := A_WorkingDir . '\' . this.shortcut

        trayMenuHandlerFunc := this.TrayMenuHandler.Bind(this)

        ; 删除原有的 菜单项
        A_TrayMenu.Delete()
        if (!A_IsCompiled) {
            A_TrayMenu.Add(this.editScript, trayMenuHandlerFunc)
            A_TrayMenu.Add(this.listVars, trayMenuHandlerFunc)
            A_TrayMenu.Add
        }
        
        ; 右对齐不好使，我醉了
        A_TrayMenu.Add(this.pause, trayMenuHandlerFunc)
        A_TrayMenu.Add(this.restart, trayMenuHandlerFunc)
        A_TrayMenu.Add(this.search, trayMenuHandlerFunc)
        A_TrayMenu.Add(this.startUp, trayMenuHandlerFunc)
        A_TrayMenu.Add

        ; 切换语言
        this.langMenu := Menu()
        A_TrayMenu.Add(this.switchLang, this.langMenu)
        this.CreateLangMenu()

        ; 添加子菜单到上面的菜单中
        moreMenu := Menu()
        moreMenu.Add(this.document, trayMenuHandlerFunc)
        moreMenu.Add(this.video, trayMenuHandlerFunc)
        moreMenu.Add(this.statistics, trayMenuHandlerFunc)
        moreMenu.Add(this.viewWinId, trayMenuHandlerFunc)
        moreMenu.Add(this.followMeCSDN, trayMenuHandlerFunc)
        moreMenu.Add(this.softwareHomepage, trayMenuHandlerFunc)
        moreMenu.Add(this.enableDarkMode, trayMenuHandlerFunc)
        moreMenu.Add(this.enableTimerReminder, trayMenuHandlerFunc)
        moreMenu.Add(this.update, trayMenuHandlerFunc)
        moreMenu.Add(this.about, trayMenuHandlerFunc)
        A_TrayMenu.Add(this.more, moreMenu)
        this.moreMenu := moreMenu

        A_TrayMenu.Add(this.exit, trayMenuHandlerFunc)

        ; 检查是否是自启状态
        if (FileExist(this.LinkFile)) {
            ; 获取快捷方式(.lnk) 文件的信息, 例如其目标文件
            FileGetShortcut(this.LinkFile, &OutTarget)
            if (OutTarget !== this.shortcut) {
                IS_AUTO_START_UP := false
                A_TrayMenu.UnCheck this.startUp
            } else {
                IS_AUTO_START_UP := true
                A_TrayMenu.Check this.startUp
            }
        } else {
            IS_AUTO_START_UP := false
            A_TrayMenu.UnCheck this.startUp
        }

        WindowsTheme.SetAppMode ENABLE_DARK_MODE
        if (ENABLE_DARK_MODE) {
            WindowsTheme.SetAppMode ENABLE_DARK_MODE
            moreMenu.Check this.enableDarkMode
        } else {
            moreMenu.UnCheck this.enableDarkMode
        }
        ; 自动获取系统的深色模式开关
        ; SYSTEM_THEME_MODE := RegRead("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize", "SystemUsesLightTheme", true)
        ; WindowsTheme.SetAppMode(!SYSTEM_THEME_MODE)
        
        ; 是否开启定时提醒
        this.counter := RelaxCounter()
        if (ENABLE_TIMER_REMINDER) {
            ; 测试 this.counter.Tick
            this.counter.Start
            moreMenu.Check(this.enableTimerReminder)
        } else {
            moreMenu.UnCheck(this.enableTimerReminder)
        }

        A_TrayMenu.Default := this.pause
        A_TrayMenu.ClickCount := 1 ; 单击可以暂停
    }

    CreateLangMenu() {
        this.langMenu.Delete

        switchLanguageFunc := this.switchLanguage.Bind(this)
        Loop Files A_ScriptDir "\lang\*.ini" {
            SplitPath A_LoopFileName, , , , &FileNameNoExt
            
            currentLang := Code2Language(FileNameNoExt)
            this.langMenu.Add(currentLang ? currentLang : FileNameNoExt, switchLanguageFunc)
        }

        currentLang := Code2Language(CURRENT_LANG)
        this.langMenu.Check(currentLang ? currentLang : CURRENT_LANG)

        Code2Language(code) {
            switch code {
                case 'zh-Hans': return '简体中文 🇨🇳'
                case 'zh-Hant': return '繁体中文 🇨🇳'
                case 'ar': return '(العربية)'
                case 'de': return 'Deutsch 🇩🇪'
                case 'en': return 'English'
                case 'es': return 'Español 🇪🇸'
                case 'fr': return 'Français 🇫🇷'
                case 'it': return 'Italiano 🇮🇹'
                case 'ja': return '日本語 🇯🇵'
                case 'ko': return '한국어 🇰🇷'
                case 'pt': return 'Português 🇵🇹'
                case 'ru': return 'Русский 🇷🇺'
                case 'tr': return 'Türkçe 🇹🇷'
                default: return false
            }
        }
    }

    switchLanguage(ItemName, ItemPos, MyMenu) {
        global CURRENT_LANG
        switch ItemName {
            case '简体中文 🇨🇳': CURRENT_LANG := 'zh-Hans'
            case '繁体中文 🇨🇳': CURRENT_LANG := 'zh-Hant'
            case '(العربية)': CURRENT_LANG := 'ar'
            case 'Deutsch 🇩🇪': CURRENT_LANG := 'de'
            case 'English': CURRENT_LANG := 'en'
            case 'Español 🇪🇸': CURRENT_LANG := 'es'
            case 'Français 🇫🇷': CURRENT_LANG := 'fr'
            case 'Italiano 🇮🇹': CURRENT_LANG := 'it'
            case '日本語 🇯🇵': CURRENT_LANG := 'ja'
            case '한국어 🇰🇷': CURRENT_LANG := 'ko'
            case 'Português 🇵🇹': CURRENT_LANG := 'pt'
            case 'Русский 🇷🇺': CURRENT_LANG := 'ru'
            case 'Türkçe 🇹🇷': CURRENT_LANG := 'tr'
            default: CURRENT_LANG := ItemName
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
        GLOBAL ENABLE_DARK_MODE
        GLOBAL ENABLE_TIMER_REMINDER

        switch ItemName, 'off' {
            case this.editScript: Edit
            case this.listVars: ListVars
            case this.pause: this.ToggleSuspend
            case this.restart: Reload
            case this.search: Anyrun

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
        
            case this.document: Run 'http://acc8226.test.upcdn.net' ; 还是选用国内服务访问最快
            case this.video: Run 'https://www.bilibili.com/video/BV19H4y1e7hJ'

            case this.followMeCSDN: Run 'https://blog.csdn.net/acc8226'
            case this.softwareHomepage: Run 'https://github.com/acc8226/jiejian'

            case this.enableDarkMode:                    
                RegWrite(ENABLE_DARK_MODE ? false : true, "REG_DWORD", REG_KEY_NAME, REG_DARK_MODE)
                this.moreMenu.ToggleCheck this.enableDarkMode
                ENABLE_DARK_MODE := !ENABLE_DARK_MODE
                WindowsTheme.SetAppMode ENABLE_DARK_MODE

            case this.enableTimerReminder:
                if ENABLE_TIMER_REMINDER {
                    RegWrite(0, "REG_DWORD", REG_KEY_NAME, REG_RELAX_REMINDER)
                    this.counter.Stop
                } else {
                    this.counter.start
                    RegWrite(1, "REG_DWORD", REG_KEY_NAME, REG_RELAX_REMINDER)
                }
                this.moreMenu.ToggleCheck(this.enableTimerReminder)
                ENABLE_TIMER_REMINDER := !ENABLE_TIMER_REMINDER

            case this.update: CheckUpdate true
            case this.about: this.AboutFunc
            case this.exit: ExitApp
        }
    }

    /**
     * 菜单中的暂停
     */
    ToggleSuspend() {
        Suspend(!A_IsSuspended)
        if (A_IsSuspended) {
            A_TrayMenu.Check(this.pause)
            Tip '  热键已禁用 ⏸️ ', -500
        } else {
            A_TrayMenu.UnCheck(this.pause)
            Tip '  热键已恢复 🚀 ', -500
        }
    }

    /**
     * 快捷键用的暂停
     */
    MySuspend() {
        Suspend(!A_IsSuspended)
        A_IsSuspended ? A_TrayMenu.Check(this.pause) : A_TrayMenu.UnCheck(this.pause)
    }

    AboutFunc(){
        MsgBox(      
            '版本: ' . CODE_VERSION
            . "`nAHK 主程序版本: " . A_AhkVersion
            . "`n系统默认语言: " . this.LocalLang(A_Language)
            . "`nWindows " . A_OSVersion . (A_Is64bitOS ? ' 64 位' : '')
            . "`n计算机名: " . A_ComputerName
            . "`n当前用户: " . A_UserName
            . "`n是否管理员权限运行: " . (A_IsAdmin ? '是' : '否')
            . "`n是否 64 位程式: " . (A_PtrSize == 8 ? '是' : '否')
            , APP_NAME, 'Iconi T60')
    }

    LocalLang(language) {
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
            DisplayName := this.getLocaleInfo(LocaleName, LOCALE_SENGLISHDISPLAYNAME)
        } else {
            DisplayName := 'unknown'
        }
        return DisplayName      
    }

    LCIDToLocaleName(LCID, Flags := 0) {
        reqBufSize := DllCall("LCIDToLocaleName", "UInt", LCID, "Ptr", 0, "UInt", 0, "UInt", Flags)
        out := Buffer(reqBufSize * 2)
        DllCall("LCIDToLocaleName", "UInt", LCID, "Ptr", out, "UInt", out.Size, "UInt", Flags)
        return StrGet(out)
    }

    getLocaleInfo(LocaleName, LCType) {
        reqBufSize := DllCall("GetLocaleInfoEx", "Str", LocaleName, "UInt", LCType, "Ptr", 0, "UInt", 0)
        out := Buffer(reqBufSize * 2)
        DllCall("GetLocaleInfoEx", "Str", LocaleName, "UInt", LCType, "Ptr", out, "UInt", out.Size)
        return StrGet(out)
    }
}

initLanguage() {
    if !FileExist(A_ScriptDir . '\' . 'lang')
        DirCreate(A_ScriptDir . '\' . 'lang')
    if !FileExist(A_ScriptDir . '\' . 'tools')
        DirCreate(A_ScriptDir . '\' . 'tools')

    ; 在已编译的脚本中包含指定的文件
    if (A_IsCompiled) {
        ; 要添加到已编译可执行文件中的文件名. 如果没有指定绝对路径, 则假定该文件位于(或相对于) 脚本自己的目录中
        FileInstall 'lang\ar.ini', 'lang\ar.ini', true
        FileInstall 'lang\de.ini', 'lang\de.ini', true
        FileInstall 'lang\en.ini', 'lang\en.ini', true
        FileInstall 'lang\es.ini', 'lang\es.ini', true
        FileInstall 'lang\fr.ini', 'lang\fr.ini', true
        FileInstall 'lang\it.ini', 'lang\it.ini', true
        FileInstall 'lang\ja.ini', 'lang\ja.ini', true
        FileInstall 'lang\ko.ini', 'lang\ko.ini', true
        FileInstall 'lang\pt.ini', 'lang\pt.ini', true
        FileInstall 'lang\ru.ini', 'lang\ru.ini', true
        FileInstall 'lang\tr.ini', 'lang\tr.ini', true
        ; 简体中文为主
        FileInstall 'lang\zh-Hans.ini', 'lang\zh-Hans.ini', true
        FileInstall 'lang\zh-Hant.ini', 'lang\zh-Hant.ini', true

        ; 鼠标控制
        FileInstall 'tools\MouseSC_x64.exe', 'tools\MouseSC_x64.exe', true
        FileInstall 'tools\MouseSC_Query.bat', 'tools\MouseSC_Query.bat', true
        ; 重建图标缓存 https://www.sordum.org/9194/rebuild-shell-icon-cache-v1-3/
        FileInstall 'tools\ReIconCache_x64.exe', 'tools\ReIconCache_x64.exe', true
        ; Rexplorer_x64 用于重启文件资源管理器
        FileInstall 'tools\Rexplorer_x64.exe', 'tools\Rexplorer_x64.exe', true
        ; 声音控制
        FileInstall 'tools\SoundControl.exe', 'tools\SoundControl.exe', true
        ; Windows 11 Classic Context Menu
        FileInstall 'tools\W11ClassicMenu.exe', 'tools\W11ClassicMenu.exe', true
        FileInstall 'tools\W11ClassicMenu.ini', 'tools\W11ClassicMenu.ini', true
        ; 禁用 windows update https://www.sordum.org/9470/windows-update-blocker-v1-8/
        FileInstall 'tools\Wub.ini', 'tools\Wub.ini', true
        FileInstall 'tools\Wub_x64.exe', 'tools\Wub_x64.exe', true        
    }
}

; 一个记录秒数的示例类...
class RelaxCounter {
    __New() {
        ; 半小时提醒
        ; this.interval := 13000
        this.interval := 3600000
        ; Tick() 有一个隐式参数 "this", 其引用一个对象。所以, 我们需要创建一个封装了 "this " 和调用方法的函数
        this.timer := ObjBindMethod(this, "Tick")
    }
    
    Start() {
        SetTimer this.timer, this.interval
    }
    
    Stop() {
        ; 要关闭计时器, 我们必须传递和之前一样的对象
        SetTimer this.timer, 0
    }
    
    ; 本例中, 计时器调用了以下方法:
    Tick() {    
        MyGui := Gui('-Caption +AlwaysOnTop +ToolWindow')
        MyGui.SetFont("c1A9F55 s15", 'Consolas')
        MyGui.SetFont("c1A9F55 s15", 'Microsoft YaHei')
        MyGui.BackColor := "030704"  ; 可以是任何 RGB 颜色(下面会变成透明的)
        guiWidth := 420
        progressBarPaddingLeft := 72
        textGUI1 := MyGui.AddText('w' . (guiWidth - MyGui.MarginX * 2) . ' Center', '休息提醒（当前） ' . FormatTime(, 'HH:mm') . '`n下次提醒时间　　 ' . FormatTime(DateAdd(A_Now, 60, "Minutes"), 'HH:mm'))    
        MyGui.AddProgress("XM" . progressBarPaddingLeft . " w" . (guiWidth - (MyGui.MarginX + progressBarPaddingLeft) * 2) . " h23 c1A9F55 vMyProgress")
        ; 当窗口处于最小化或最大化状态时, 还原窗口. 窗口显示但不进行激活.
        MyGui.Show 'NoActivate W' . guiWidth . ' H116'

        loop {
            if (MyGui["MyProgress"].Value >= 100) {
                ; 消失前短暂停留
                Sleep 300
                MyGui.Destroy
                break
            }
            ; 每 1 秒，进度增长 10% =（100/10）
            Sleep 1000
            MyGui["MyProgress"].Value += (100/60) ; 进度增长
        }
    }
}