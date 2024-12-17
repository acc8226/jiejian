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
#Requires AutoHotkey >=v2.0

; --------------------- COMPILER DIRECTIVES --------------------------

;@Ahk2Exe-SetCopyright 全民反诈联盟
;@Ahk2Exe-SetDescription 捷键-为简化键鼠操作而生
;@Ahk2Exe-SetMainIcon icons\favicon.ico
;@Ahk2Exe-AddResource icons\favicon-paused.ico, 206 ; 编译后 替换成 标准图标

; --------------------- GLOBAL --------------------------

#SingleInstance force ; 跳过对话框并自动替换旧实例
CoordMode 'Mouse' ; 第二个参数如果省略, 默认为 Screen
FileEncoding 54936 ; Windows XP 及更高版本：GB18030 简体中文 (4 字节)
SetTitleMatchMode 'RegEx' ; 设置 WinTitle parameter 在内置函数中的匹配行为
; This is the setting that runs smoothest on my
; system. Depending on your video card and cpu
; power, you may want to raise or lower this value.
SetWinDelay 30
SetMouseDelay -1  ; Makes movement smoother.

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
GLOBAL CODE_VERSION := '24.11-beta2'
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
        ; https://www.autohotkey.com/docs/v2/misc/Languages.htm
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
}

; ----- 1. 热键 之 鼠标操作 -----
#Include 'lib\Functions.ahk'
#Include 'lib\Actions.ahk'
#Include 'lib\Utils.ahk'
#Include 'lib\WinHole.ahk'
#Include 'lib\KeymapManager.ahk'

#Include <MoveWindow>
#Include <WindowsTheme>

#Include 'modules\ConfigMouse.ahk'
#Include 'modules\Utils.ahk'
#Include 'modules\ReadApp.ahk'
#Include 'modules\ReadData.ahk'
#Include 'modules\Anyrun.ahk'
#Include 'modules\CheckUpdate.ahk'
#Include 'modules\MyTrayMenu.ahk'
#Include 'modules\WindowShading.ahk'

initLanguage

; 生成快捷方式：每次运行检测如果 shortcuts 里的文件为空则重新生成一次快捷方式，要想重新生成可以双击 GenerateShortcuts.ahk 脚本或者清空或删除该文件夹
if !FileExist(A_WorkingDir . '\shortcuts\*')
    Run 'extra/GenerateShortcuts.exe'

SettingTray
; 设置托盘图标和菜单
SettingTray() {
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
    Send('{Home}{# ' . nums . '}' . ' ')
    ; 之所以拆开是为防止被中文输入法影响
    SendText newText
    Send '{End}'
    A_Clipboard := oldText
}
#HotIf

; Ctrl + Alt + R 重启脚本
^!r::{
    Reload
    Sleep 50 ; 不创建多个实例的情况下重新加载脚本的简单实现，给个暂停时长
}
^!s::JJ_TRAY_MENU.MySuspend ; Ctrl + Alt + S 暂停脚本
^!v::Send A_Clipboard ; Ctrl + Alt + V 将剪贴板的内容输入到当前活动应用程序中，防止了一些网站禁止在 HTML 密码框中进行粘贴操作
^+"::Send '""{Left}' ; Ctrl + Shift + " 快捷操作-插入双引号

; 将来可改为条件映射或者不改了

RAlt::LControl ; 右 alt 不常用，映射为左 ctrl

; 启动 Anyrun 组件
#HotIf NOT IniRead('setting.ini', "Common", "AnyRunUseCtrl", '0')
!Space::Anyrun 
#HotIf IniRead('setting.ini', "Common", "AnyRunUseCtrl", '0')
^Space::Anyrun

#HotIf IniRead('setting.ini', "Common", "AppsKey2MediaNext", '0')
; 称为老板键 或者下一曲，或者老板键，打开计算器都能，暂停播放
; AppsKey::Send '#d'
AppsKey::Send '{Media_Next}'

#HotIf IniRead('setting.ini', "Common", "PrintScreen2VolumeDown", '0')
PrintScreen::Send '{Volume_Down}'
ScrollLock::Send '{Media_Play_Pause}'
Pause::Send '{Volume_Up}'

; 数字面板 且 未开启数字键模式
#HotIf IniRead('setting.ini', "Common", "NumpadOff2Media", '0')
NumpadDown::Send '{Media_Next}'
NumpadLeft::Send '{Volume_Down}'
NumpadClear::Send '{Media_Play_Pause}'
NumpadRight::Send '{Volume_Up}'
NumpadUp::Send '{Media_Prev}'

#HotIf

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
OnExit ExitFunc
ExitFunc(exitReason, exitCode) {
    ; 统计软件使用总分钟数
    minutesDiff := DateDiff(A_NowUTC, START_TIME, 'Minutes')
    if (minutesDiff > 0) {
        recordMins := RegRead(REG_KEY_NAME, REG_RECORD_MINS, 0) + minutesDiff
        RegWrite(recordMins, 'REG_DWORD', REG_KEY_NAME, REG_RECORD_MINS)
    }
    ; 统计软件使用次数
    if (NOT exitReason ~= 'i)^(?:Error|Reload|Single)$') {
        launchCount := RegRead(REG_KEY_NAME, REG_LAUNCH_COUNT, 1) + 1
        RegWrite(launchCount, 'REG_DWORD', REG_KEY_NAME, REG_LAUNCH_COUNT)
    }
    ; 当前选择的语言
    RegWrite(CURRENT_LANG, 'REG_SZ', REG_KEY_NAME, REG_LANG)

    ; 还原窗口 for shading windows
    restoreWindows
}

; 触发热键时, 热键中按键原有的功能不会被屏蔽(对操作系统隐藏)
F17::OpenSelectedText

#HotIf IsSet(MY_DOUBLE_ALT) ; 双击模式我只推荐 双击 Alt，因为 shift 和 ctrl 太过常用
~Alt::DoubleClick(ThisHotkey, MY_DOUBLE_ALT)
#HotIf IsSet(MY_DOUBLE_HOME)
~Home::
~NumpadHome::DoubleClick(ThisHotkey, MY_DOUBLE_HOME)
#HotIf IsSet(MY_DOUBLE_END)
~End::
~NumpadEnd::DoubleClick(ThisHotkey, MY_DOUBLE_END)
#HotIf IsSet(MY_DOUBLE_ESC) ; 双击 esc 表示关闭，esc 不适用于 vscode 防止误操作
~Esc::DoubleClick(ThisHotkey, MY_DOUBLE_ESC)
#HotIf

; command 约定是 type-title 的组合
DoubleClick(hk, command) {
    if (hk == A_PriorHotkey && A_TimeSincePriorHotkey > 100 && A_TimeSincePriorHotkey < 210) {
        ; esc 不适用于 vscode 防止误操作
        if (hk = 'Esc') {
            try {
                processName := WinGetProcessName('A')
                ; 如果是 code 这种频繁使用 esc 按键的软件则禁用双击 esc
                if processName = 'Code.exe'
                    return
            } catch as e {
                MsgBox('An error was thrown!`nSpecifically: ' . e.Message)
                return
            }
        } else {
            ; 分离按下的键
            KeyWait(SubStr(hk, 2)) ; This prevents the keyboard's auto-repeat feature from interfering.
        }
        item := unset
        if (StrLen(command) > 0) {
            split := StrSplit(command, '-')
            ; 分割并截取类型 type 和 title 名称
            if (split.Length == 2) {
                type := split[1]
                title := split[2]
                item := FindItemByTypeAndTitle(type, title)
            }
        }
        if !(IsSet(item) && item != '')
            MsgBox(hk . ' 对应指令找不到！', APP_NAME)
        else
            OpenPathByType item
    }    
}

; 监控 ctrl + c 按键放下
~^c Up::
UpdateCtrlTimestamp(hk?) {
    GLOBAL CTRL_TIMESTAMP := A_NowUTC
}

Capslock::{
    GLOBAL IS_CAPS_PRESSED := true
    ; 使用过会清除该变量
    GLOBAL ENABLE_CHANGE_CAPS_STATE := true

    DisableCapsChange() {
        GLOBAL ENABLE_CHANGE_CAPS_STATE := false
    }
    
    SetTimer(DisableCapsChange, -300) ; 300 ms 犹豫操作时间
    KeyWait 'CapsLock' ; 等待用户物理释放按键

    ; Capslock 先置空，来关闭 Capslock+ 功能的触发
    IS_CAPS_PRESSED := false
    ; 松开的时候才切换 CapsLock 大小写
    if ENABLE_CHANGE_CAPS_STATE
        SetCapsLockState(!GetKeyState('CapsLock', 'T'))
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
vkC0::
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
VKba::MouseMove 3, 0,, 'R' ; 右移 caps + ; vk=BA sc=027   
VKbe::MouseMove 0, 3,, 'R' ; 下移 caps + . vk=BE sc=034

; 复制路径
z::CopySelectedAsPlainText
; 音量调节
x::SoundControl
; 搜索或打开网址
c::OpenSelectedText
; 窗口移到下一个显示器
v::Send '#+{right}'

; 窗口最小化
m::MinimizeWindow
; Window Shading(窗口遮帘) caps + ,
vkBC::shadingWindows

; 复制选中文件路径并打开 Anyrun 组件
Space::{
    CopySelectedAsPlainTextQuiet
    ; 由于命令发送 ctrl + c 不会触发监听则手动更新时间戳
    UpdateCtrlTimestamp
    Anyrun
}

; 按住 CapsLock 的同时 按下鼠标左键拖动窗口
LButton::MoveWindow2
RButton::resizeWindow

Left::MoveRelative -28
Right::MoveRelative 28
Up::MoveRelative 0, -28
Down::MoveRelative 0, 28

; 为程序员们添加 ctrl + alt + t 为在当前页面打开终端
#HotIf WinActive('ahk_exe explorer.exe')
^!t::openCMDhere()
openCMDhere() {
    WinClass := WinGetClass('A')
    If (WinClass = 'Progman' or WinClass = 'WorkerW') {
        if IsSet(MY_NEW_TERMINAL)
            Run(MY_NEW_TERMINAL ' /d .', A_Desktop)
        else
            Run(A_ComSpec, A_Desktop)
        return
    }
    WinHWND := WinGetID('A')
    ; 从所有的文件窗口中进行筛选
    for window in ComObject("Shell.Application").Windows {
        If (window.HWND = WinHWND) {
            if window.LocationURL = ""
                return
            currdir := SubStr(window.LocationURL, 9)
            currdir := RegExReplace(currdir, "%20", " ")
            if IsSet(MY_NEW_TERMINAL)
                Run(MY_NEW_TERMINAL ' /d .', currdir)
            else
                Run(A_ComSpec, currdir)
            break
        }
    }
}
#HotIf

; 避免 未编译程序 和 已编译的程序打架
if (A_IsCompiled) {
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

; 引入 mykeymap 的 keymapmanager.ahk
; 窗口组
GroupAdd("MY_WINDOW_GROUP__1", "Stardew Valley ahk_class SDL_app")
GroupAdd("MY_WINDOW_GROUP__1", "ahk_exe Rune Factory 3 Special.exe")
KeymapManager.GlobalKeymap.DisabledAt := "ahk_group MY_WINDOW_GROUP__1"

; 分号模式( ; )
km13 := KeymapManager.NewKeymap("*;", "分号模式( `; )", "")
km := km13
km.Map("*a", _ => (Send("{blind}*")))
km.Map("*b", _ => (Send("{blind}%")))
km.Map("*c", _ => (Send("{blind}.")))
km.Map("*d", _ => (Send("{blind}=")))
km.Map("*e", _ => (Send("{blind}{^}")))
km.Map("*f", _ => (Send("{blind}>")))
km.Map("*g", _ => (Send("{blind}{!}")))
km.Map("*h", _ => (Send("{blind}{+}")))
km.Map("*i", _ => (Send("{blind}:")))
km.Map("*j", _ => (Send("{blind};")))
km.Map("*k", _ => (Send("{blind}``")))
km.Map("*m", _ => (Send("{blind}-")))
km.Map("*n", _ => (Send("{blind}/")))
km.Map("*r", _ => (Send("{blind}&")))
km.Map("*s", _ => (Send("{blind}<")))
km.Map("*t", _ => (Send("{blind}~")))
km.Map("*u", _ => (Send("{blind}$")))
km.Map("*v", _ => (Send("{blind}|")))
km.Map("*w", _ => (Send("{blind}{#}")))
km.Map("*x", _ => (Send("{blind}_")))
km.Map("*y", _ => (Send("{blind}@")))
km.Map("*z", _ => (Send("{blind}\")))
km.Map("singlePress", _ => Send("{blind};"))

KeymapManager.GlobalKeymap.Enable()

; 是否启用手柄
if NOT IniRead('setting.ini', "JoyControl", "enable", '0')
    return

; 如果有手柄则开启手柄按键映射
; If you want to unconditionally use a specific controller number, change
; the following value from 0 to the number of the controller (1-16).
; A value of 0 causes the controller number to be auto-detected:
ControllerNumber := 0
; Auto-detect the controller number if called for:
if (ControllerNumber <= 0) {
    Loop 16  ; Query each controller number to find out which ones exist.
    {
        if GetKeyState(A_Index "JoyName") {
            ControllerNumber := A_Index
            break
        }
    }
    if ControllerNumber <= 0
        return
}

; This script converts a controller (gamepad, joystick, etc.) into a three-button
; mouse. It allows each button to drag just like a mouse button and it uses
; virtually no CPU time. Also, it will move the cursor faster depending on how far
; you push the stick from center. You can personalize various settings at the
; top of the script.
;
; Note: For Xbox controller 2013 and newer (anything newer than the Xbox 360
; controller), this script will only work if a window it owns is active,
; such as a message box, GUI, or the script's main window.

; Increase the following value to make the mouse cursor move faster:
ContMultiplier := 0.5

; Decrease the following value to require less stick displacement-from-center
; to start moving the mouse.  However, you may need to calibrate your stick
; -- ensuring it's properly centered -- to avoid cursor drift. A perfectly tight
; and centered stick could use a value of 1:
ContThreshold := 3

; Change the following to true to invert the Y-axis, which causes the mouse to
; move vertically in the direction opposite the stick:
InvertYAxis := false

; If your system has more than one controller, increase this value to use a
; controller other than the first:
ControllerNumber := 1

; END OF CONFIG SECTION -- Don't change anything below this point unless you want
; to alter the basic nature of the script.

ControllerPrefix := ControllerNumber . "Joy"
Hotkey ControllerPrefix . 1, ClickButtonLeft
Hotkey ControllerPrefix . 2, ClickButtonRight
; 播放
Hotkey ControllerPrefix . 3, (*) => Send("{Media_Play_Pause}") 
; 下一首
Hotkey ControllerPrefix . 4, (*) => Send("{Media_Next}")

; 菜单键
Hotkey ControllerPrefix . 7, (*) => Send("{Volume_Down}")
; 开始键
Hotkey ControllerPrefix . 8, (*) => Send("{Volume_Up}")

; Calculate the axis displacements that are needed to start moving the cursor:
ContThresholdUpper := 50 + ContThreshold
ContThresholdLower := 50 - ContThreshold
YAxisMultiplier := InvertYAxis ? -1 : 1
; Monitor the movement of the stick.
SetTimer(WatchController, 30)

; The functions below do not use KeyWait because that would sometimes trap the
; WatchController quasi-thread beneath the wait-for-button-up thread, which would
; effectively prevent mouse-dragging with the controller.
ClickButtonLeft(*) {
    MouseClick "Left",,, 1, 0, "D"  ; Hold down the left mouse button.
    SetTimer(WaitForLeftButtonUp, 10)
    
    WaitForLeftButtonUp() {
        if GetKeyState(A_ThisHotkey)
            return  ; The button is still, down, so keep waiting.
        ; Otherwise, the button has been released.
        SetTimer , 0
        MouseClick("Left",,, 1, 0, "U")  ; Release the mouse button.
    }
}

ClickButtonRight(*) {
    MouseClick "Right",,, 1, 0, "D"  ; Hold down the right mouse button.
    SetTimer(WaitForRightButtonUp, 10)
    
    WaitForRightButtonUp() {
        if GetKeyState(A_ThisHotkey)
            return  ; The button is still, down, so keep waiting.
        ; Otherwise, the button has been released.
        SetTimer , 0
        MouseClick("Right",,, 1, 0, "U")  ; Release the mouse button.
    }
}

WatchController() {
    global
    ; Don't do anything if the script is suspended.
    if A_IsSuspended
        return
    MouseNeedsToBeMoved := false  ; Set default.
    JoyX := GetKeyState(ControllerNumber "JoyX")
    JoyY := GetKeyState(ControllerNumber "JoyY")
    
    if (JoyX == '' or JoyY == '' or (JoyX < 5 and JoyY < 5) or (JoyX > 95 and JoyY > 95)) {
        SetTimer , 0
        return
    }
        
    if JoyX > ContThresholdUpper {
        MouseNeedsToBeMoved := true
        DeltaX := Round(JoyX - ContThresholdUpper)
    } else if JoyX < ContThresholdLower {
        MouseNeedsToBeMoved := true
        DeltaX := Round(JoyX - ContThresholdLower)
    } else {
        DeltaX := 0
    }

    if JoyY > ContThresholdUpper {
        MouseNeedsToBeMoved := true
        DeltaY := Round(JoyY - ContThresholdUpper)
    } else if JoyY < ContThresholdLower {
        MouseNeedsToBeMoved := true
        DeltaY := Round(JoyY - ContThresholdLower)
    } else {
        DeltaY := 0
    }

    if (MouseNeedsToBeMoved) {
        SetMouseDelay -1  ; Makes movement smoother.
        MouseMove DeltaX * ContMultiplier, DeltaY * ContMultiplier * YAxisMultiplier, 0, "R"
    }
}
