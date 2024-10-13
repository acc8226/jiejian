/*
AHK2 jiejian
A key mapping/shortcut enhancement tool developed based on AutoHotkey v2.0+ (http://www.autohotkey.com)

Copyright 2023-2024 acc8226
--------------------------------
*/

/*
快速参考 | AutoHotkey v2 https://wyagd001.github.io/v2/docs/
vscode 插件安装 https://marketplace.visualstudio.com/items?itemName=thqby.vscode-autohotkey2-lsp
*/

/*
TODO 对环境变量路径的识别 比如 %ProgramFiles(x86)%\Windows Media Player\wmplayer.exe
*/
#Requires AutoHotkey >=v2.0

; --------------------- COMPILER DIRECTIVES --------------------------

;@Ahk2Exe-SetCopyright 全民反诈联盟
;@Ahk2Exe-SetDescription 捷键-为简化键鼠操作而生
;@Ahk2Exe-SetMainIcon icons\favicon.ico
;@Ahk2Exe-AddResource icons\favicon-paused.ico, 206 ; 编译后 替换成 标准图标

; --------------------- GLOBAL --------------------------

#SingleInstance force ; 跳过对话框并自动替换旧实例
CoordMode('Mouse', 'Screen') ; RelativeTo 如果省略, 默认为 Screen
FileEncoding 54936 ; Windows XP 及更高版本：GB18030 简体中文 (4 字节)
SetTitleMatchMode 'RegEx' ; 设置 WinTitle parameter 在内置函数中的匹配行为

; 如果 非管理器启动 且 不含 /restart 参数（表示首次启动）则以管理员方式启动
if NOT (A_IsAdmin or RegExMatch(DllCall('GetCommandLine', 'str'), ' /restart(?!\S)')) {
    try {
        if A_IsCompiled
            Run '*RunAs "' A_ScriptFullPath '" /restart'
        else
            Run '*RunAs "' A_AhkPath '" /restart "' A_ScriptFullPath '"' ; 双击 .ahk 会进入此，形如 *runs as "autohotkey64.exe" /restart "zhangsan.ahk"
        ExitApp
    } catch Error as e
        ToolTip("`n    捷键正在以普通权限运行。`n    捷键无法在具有管理员权限的窗口中工作（例如，Taskmgr.exe）。    `n ")
}

; 定义版本信息并写入
GLOBAL CODE_VERSION := '24.10-beta3'
;@Ahk2Exe-Let U_version = %A_PriorLine~U).+['"](.+)['"]~$1%
; FileVersion 将写入 exe
;@Ahk2Exe-Set FileVersion, %U_version%
; 往对应文件写入对应版本号，只在生成 32 位 exe 的时候执行
;@Ahk2Exe-Obey U_V, = %A_PtrSize% == 4 ? 'PostExec' : 'Nop'
; 提取出 文件名 再拼接 PostExec.exe; 版本号; When: 2 仅在指定 UPX 压缩时运行 ; WorkingDir: 脚本所在路径
;@Ahk2Exe-%U_V% %A_ScriptName~\.[^\.]+$~PostExec.exe% %U_version%, 2, %A_ScriptDir%

SetDefaults
SetDefaults() {
    GLOBAL
    REG_KEY_NAME := 'HKEY_CURRENT_USER\SOFTWARE\jiejian'
    REG_RECORD_MINS := 'record_mins'
    REG_LAUNCH_COUNT := 'launch_count'
    REG_LANG := 'LANG'
    REG_RELAX_REMINDER := 'relaxReminder'
    REG_DARK_MODE := 'darkMode'

    CURRENT_LANG := RegRead(REG_KEY_NAME, REG_LANG, '')
    if (CURRENT_LANG = '') {
        switch A_Language {
            case '7804', '0004', '0804', '1004' : CURRENT_LANG := 'zh-Hans'
            case '7C04', '0C04', '1404', '0404' : CURRENT_LANG := 'zh-Hant'
            default: CURRENT_LANG := 'en'
        } 
    }
    
    START_TIME := A_NowUTC
    APP_NAME := '捷键' ; 用于 msgbox 标题展示
    CTRL_TIMESTAMP := A_NowUTC ; 记录 ctrl + c/x 最新时间戳
    
    ; CapsLock 模式：对任务管理器 和 系统高级设置没用
    ; 短按依旧有用 确保了 CapsLock 灯不会闪
    IS_CAPS_PRESSED := false
    ; 使用过会清除这个变量
    ENABLE_CHANGE_CAPS_STATE := false
}

; ----- 1. 热键 之 鼠标操作 -----
#Include 'lib/Functions.ahk'
#Include 'lib/Actions.ahk'
#Include 'lib/Utils.ahk'

#Include <MoveWindow>
#Include <WindowsTheme>

#Include 'modules/ConfigMouse.ahk'
#Include 'modules/Utils.ahk'
#Include 'modules/ReadApp.ahk'
#Include 'modules/ReadData.ahk'
#Include 'modules/Anyrun.ahk'
#Include 'modules/CheckUpdate.ahk'
#Include 'modules/MyTrayMenu.ahk'

initLanguage

; 生成快捷方式：每次运行检测如果 shortcuts 里的文件为空则重新生成一次快捷方式，要想重新生成可以双击 GenerateShortcuts.ahk 脚本或者清空或删除该文件夹
if NOT FileExist(A_WorkingDir . '\shortcuts\*')
    Run 'extra/GenerateShortcuts.exe'

settingTray
; 设置托盘图标和菜单
settingTray() {
    ; 构建菜单项
    GLOBAL JJ_TRAY_MENU := MyTrayMenu()

    localIsAlphaOrBeta := InStr(CODE_VERSION, 'alpha') || InStr(CODE_VERSION, 'beta')
    A_IconTip := "捷键 " . CODE_VERSION . (A_IsCompiled ? '' : ' 未编译') . (localIsAlphaOrBeta ? " 测试版" : " ") . (A_PtrSize == 4 ? '32位' : '64位')

    if !A_IsCompiled
        TraySetIcon 'icons\favicon.ico' ; 建议使用 16*16 或 32*32 像素的图标，使用 Ahk2Exe-Let 提取出 favicon.ico
}

; 检查更新
CheckUpdate

; ----- 热键 之 快捷键重写和增强 -----
; ----- 热键 之 打开网址 -----
; ----- 热键 之 运行程序 ;问题是怎么添加应用商店的路径-----
; ----- 热键 之 启动文件夹 -----
; ----- 热键 之 其他 -----

; 文本类 为了 md 增强 记事本 & vscode
; ctrl + 数字 1-5 为光标所在行添加 markdown 格式标题
#HotIf WinActive('ahk_exe i)notepad.exe') || WinActive('ahk_class i)Chrome_WidgetWin_1 ahk_exe i)Code.exe') 
^1::
^2::
^3::
^4::
^5::{
    oldText := A_Clipboard
    A_Clipboard := ''
    Send('{Home}{Shift Down}{End}{Shift Up}') ; 切到首部然后选中到尾部
    Sleep 100
    Send '^x'
    ClipWait ; 等待剪贴板中出现文本
    newText := RegExReplace(A_Clipboard, "\s*$", "") ; 去掉尾部空格
    newText := RegExReplace(newText, "^#{1,6}\s+(.*)", "$1")
    nums := SubStr(A_ThisHotkey, 2)
    Send("{Home}{# " . nums . "}" . ' ')
    ; 之所以拆开是为防止被中文输入法影响
    SendText newText
    Send '{End}'
    A_Clipboard := oldText
}
#HotIf

; Ctrl + Alt + R 重启脚本
^!r::{
    Reload
    Sleep(50) ; 不创建多个实例的情况下重新加载脚本的简单实现，给个暂停时长
}
^!s::JJ_TRAY_MENU.mySuspend ; Ctrl + Alt + S 暂停脚本
^!v::Send(A_Clipboard) ; Ctrl + Alt + V 将剪贴板的内容输入到当前活动应用程序中，防止了一些网站禁止在 HTML 密码框中进行粘贴操作
^+"::Send('""{Left}') ; Ctrl + Shift + " 快捷操作-插入双引号

!Space::Anyrun ; 启动窗口

; ----- 热串 之 打开网址。选择 z 而非 q，因为 q 的距离在第一行太远了，我称之为 Z 模式，用于全局跳转网址 -----
; ----- 热串 之 缩写扩展：将短缩词自动扩展为长词或长句（英文单词中哪个字母开头的单词数最少，我称之为 X 模式）-----

; 意为 'now'
:C*:xnn::{
    SendText(FormatTime(, 'yyyy-MM-dd HH:mm:ss'))
}
; 意为 'day'
:C*:xdd::{
    SendText(FormatTime(, "'date:' yyyy-MM-dd HH:mm:ss"))
}
; 意为 '分割线的首字母 f'
:C*:xff::{
    SendText '——————— ฅ՞• •՞ฅ ———————'
}
; 意为 idcard
#HotIf NOT A_IsCompiled
:C*:xii::{
    SendText '431121199210010012'
}
#HotIf

; 注册一个当脚本退出时, 会自动调用的函数
OnExit(exitFunc)
exitFunc(exitReason, exitCode) {
    ; 统计软件使用总分钟数
    minutesDiff := DateDiff(A_NowUTC, START_TIME, 'Minutes')
    if (minutesDiff > 0) {
        recordMins := RegRead(REG_KEY_NAME, REG_RECORD_MINS, 0) + minutesDiff
        RegWrite(recordMins, "REG_DWORD", REG_KEY_NAME, REG_RECORD_MINS)
    }
    ; 统计软件使用次数
    if (NOT exitReason ~= 'i)^(?:Error|Reload|Single)$') {
        launchCount := RegRead(REG_KEY_NAME, REG_LAUNCH_COUNT, 1) + 1
        RegWrite(launchCount, "REG_DWORD", REG_KEY_NAME, REG_LAUNCH_COUNT)
    }
    ; 当前选择的语言
    RegWrite(CURRENT_LANG, "REG_SZ", REG_KEY_NAME, REG_LANG)
}

; 触发热键时, 热键中按键原有的功能不会被屏蔽(对操作系统隐藏)
~LButton & a::{
    ; 没有获取到文字直接返回,否则若选中的是网址则打开，否则进行百度搜索
    text := GetSelectedText()
    if (text) {
        if RegExMatch(text, 'i)^\s*((?:https?://)?(?:[\w-]+\.)+[\w-]+(?:/[\w-./?%&=]*)?\s*)$', &regExMatchInfo) {
            text := regExMatchInfo.1
            if NOT InStr(text, 'http')
                text := ("http://" . text)
            Run text
        } else {
            Run('https://www.baidu.com/s?wd=' . text)
        }            
    }
}

#HotIf IsSet(MY_DOUBLE_ALT) ; 双击模式我只推荐 双击 Alt，因为 shift 和 ctrl 太过常用
~Alt::doubleClick(ThisHotkey, MY_DOUBLE_ALT)
#HotIf IsSet(MY_DOUBLE_HOME)
~Home::doubleClick(ThisHotkey, MY_DOUBLE_HOME)
#HotIf IsSet(MY_DOUBLE_END)
~End::doubleClick(ThisHotkey, MY_DOUBLE_END)
#HotIf IsSet(MY_DOUBLE_ESC) ; 双击 esc 表示关闭，esc 不适用于 vscode 防止误操作
~Esc::doubleClick(ThisHotkey, MY_DOUBLE_ESC)
#HotIf

; command 约定是 type-title 的组合
doubleClick(hk, command) {
    if (hk == A_PriorHotkey && A_TimeSincePriorHotkey > 100 && A_TimeSincePriorHotkey < 210) {
        ; esc 不适用于 vscode 防止误操作
        if (hk = '~Esc') {
            try {
                processName := WinGetProcessName('A')
                ; 如果是 code 这种频繁使用 esc 按键的软件则禁用双击 esc
                if processName = 'Code.exe'
                    return
            } catch as e {
                MsgBox('An error was thrown!`nSpecifically: ' . e.Message)
                return
            }
        }

        item := unset
        if (StrLen(command) > 0) {
            split := StrSplit(command, '-')
            ; 分割并截取类型 type 和 title 名称
            if split.Length == 2 {
                type := split[1]
                title := split[2]
                item := findItemByTypeAndTitle(type, title)
            }
        }
        if !IsSet(item) || item == ''
            MsgBox(hk . ' 对应指令找不到！', APP_NAME)
        else
            openPathByType item
    }    
}

; 监控 ctrl + c 按键放下
~^c Up::
UpdateCtrlTimestamp(*) {
    GLOBAL CTRL_TIMESTAMP := A_NowUTC
}

Capslock::{
    GLOBAL IS_CAPS_PRESSED := true
    GLOBAL ENABLE_CHANGE_CAPS_STATE := true

    DisableCapsChange() {
        GLOBAL ENABLE_CHANGE_CAPS_STATE := false
    }
    
    SetTimer DisableCapsChange, -300 ; 300 ms 犹豫操作时间
    KeyWait('CapsLock') ; 等待用户物理释放按键
    IS_CAPS_PRESSED := false ; Capslock 先置空，来关闭 Capslock+ 功能的触发
    ; 松开的时候才切换 CapsLock 大小写
    if ENABLE_CHANGE_CAPS_STATE
        SetCapsLockState(!GetKeyState('CapsLock', 'T'))
    DisableCapsChange
}

; 需要按一次按键才会生效，时好时坏
#HotIf IS_CAPS_PRESSED

; 关闭窗口
q::SmartCloseWindow

; 宽度拉升至最大
w::SetWindowWeightToFullScreen
; 高度拉升至最大
h::SetWindowHeightToFullScreen

; 切换到上个窗口
e::Send '!{tab}'

; 程序内切换窗口 caps + ` 或者 r 来切换
SC029::
r::LoopRelatedWindows

; 切换到上一个虚拟桌面
y::Send '^#{Left}'
; 切换到下一个虚拟桌面
n::Send '^#{Right}'

; 适合 b 站
a::CenterAndResizeWindow 818, 460
; 适合 b 站
s::CenterAndResizeWindow 1280, 770
d::CenterAndResizeWindow 1920, 1080 ; 16:9
; 最大化或还原
f::MaximizeWindow

j::CenterAndResizeWindow_window_percent 200
k::CenterAndResizeWindow_window_percent -200

u::Click
i::Click 'Up Right'

o::MouseMove 0, -3,, 'R' ; 上移
l::MouseMove -3, 0,, 'R' ; 左移
SC027::MouseMove 3, 0,, 'R' ; 右移 caps + ;
SC034::MouseMove 0, 3,, 'R' ; 下移 caps + .

; 复制路径
z::CopySelectedAsPlainText
; 窗口移到下一个显示器
v::Send '#+{right}'
; 窗口最小化
m::MinimizeWindow

; 复制选中文件路径并打开 Anyrun 组件
Space::{
    CopySelectedAsPlainTextQuiet
    ; 由于命令发送 ctrl + c 不会触发监听则手动更新时间戳
    UpdateCtrlTimestamp
    Anyrun
}

; 按住 CapsLock 时同时按下鼠标左键拖动窗口
LButton::MoveWindow

Left::MoveRelative -28
Right::MoveRelative 28
Up::MoveRelative 0, -28
Down::MoveRelative 0, 28
#HotIf

; 尽量避免为编译程序 和 以编译的程序打架
if A_IsCompiled {
    ; 32 位 和 64 位独活一个
    if (A_PtrSize == 8) {
        ; 杀掉 32 位程式
        if PID := ProcessExist("jiejian32.exe")
            ProcessClose PID
    } else {
        ; 杀掉 64 位程式
        if PID := ProcessExist("jiejian64.exe")
            ProcessClose PID
    }
} else {
    ; 关闭所有测试程序
    if PID := ProcessExist("jiejian32.exe")
        ProcessClose PID
    if PID := ProcessExist("jiejian64.exe")
        ProcessClose PID
}

; windows 版本
;
; Windows 11 [10.1.xxxxx]
; Windows 10 [10.0.10240] (29.07.2015)
; Windows 8.1 [6.3.9200]
; Windows 8 [6.2.9200]
; Windows 7 service pack 1(SP1) [6.1.7601]
; Windows 7 [6.1.7600]
; Windows Vista service pack 2(SP2) [6.0.6002]
; Windows Vista [6.0.6000]
; Windows XP service pack 3(SP3) [5.1.2600]
