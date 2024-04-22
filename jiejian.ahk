/*
快速参考 | AutoHotkey v2 https://wyagd001.github.io/v2/docs/
vscode 插件安装 https://marketplace.visualstudio.com/items?itemName=thqby.vscode-autohotkey2-lsp
*/
#Requires AutoHotkey >=v2.0
#SingleInstance force ; 跳过对话框并自动替换旧实例

;@Ahk2Exe-Set Language, 0x0804
;@Ahk2Exe-SetCopyright 全民反诈 union
;@Ahk2Exe-SetDescription 捷键-为简化键鼠操作而生

CodeVersion := '24.4.21-beta'
;@Ahk2Exe-Let U_version = %A_PriorLine~U).+['"](.+)['"]~$1%
; FileVersion 将写入 exe
;@Ahk2Exe-Set FileVersion, %U_version%
; 往对应文件写入对应版本号，只在生成 32 位 exe 的时候执行
;@Ahk2Exe-Obey U_V, = %A_PtrSize% == 4 ? 'PostExec' : 'Nop'
; 提取出 文件名 再拼接 PostExec.exe; 版本号; When: 2 仅在指定 UPX 压缩时运行 ; WorkingDir: 脚本所在路径
;@Ahk2Exe-%U_V% %A_ScriptName~\.[^\.]+$~PostExec.exe% %U_version%, 2, %A_ScriptDir%

global REG_KEY_NAME := 'HKEY_CURRENT_USER\SOFTWARE\jiejian'
global START_TIME := A_NowUTC
global IS_AUTO_START_UP := false
global APP_NAME := '捷键' ; 用于 msgbox 标题展示
global ctrlTimeStamp := A_NowUTC ; 记录 ctrl + c/x 最新时间戳

; ----- 1. 热键 之 鼠标操作 -----
CoordMode('Mouse', 'Screen') ; RelativeTo 如果省略, 默认为 Screen
FileEncoding 54936 ; Windows XP 及更高版本：GB18030 简体中文 (4 字节)
SetTitleMatchMode 'RegEx' ; 设置 WinTitle parameter 在内置函数中的匹配行为

#Include 'lib/Functions.ahk'
#Include 'lib/Actions.ahk'
#Include 'lib/MoveWindow.ahk'
#Include 'lib/Utils.ahk'

#Include 'modules/ConfigMouse.ahk'
#Include 'modules/Utils.ahk'
#Include 'modules/Anyrun.ahk'
#Include 'modules/ReadApp.ahk'
#Include 'modules/ReadData.ahk'
#Include 'modules/CheckUpdate.ahk'
#Include 'modules/MyTrayMenu.ahk'

global aTrayMenu

GenerateShortcuts ; 生成快捷方式
SettingTray ; 设置托盘图标和菜单
CheckUpdate ; 检查更新

; ----- 热键 之 快捷键重写和增强 -----
; ----- 热键 之 打开网址 -----
; ----- 热键 之 运行程序 ;问题是怎么添加应用商店的路径-----
; ----- 热键 之 启动文件夹 -----
; ----- 热键 之 其他 -----

; 文本类 为了 md 增强 记事本 & vscode
; ctrl + 数字 1-5 为光标所在行添加 markdown 格式标题
#HotIf WinActive('ahk_exe i)notepad.exe') OR WinActive('ahk_class i)Chrome_WidgetWin_1 ahk_exe i)Code.exe') 
^1::
^2::
^3::
^4::
^5::{
    oldText := A_Clipboard
    A_Clipboard := ''
    Send('{Home}{Shift Down}{End}{Shift Up}') ; 切到首部然后选中到尾部
    Sleep(100)
    Send('^x')
    ClipWait ; 等待剪贴板中出现文本.
    newText := RegExReplace(A_Clipboard, "\s*$", "") ; 去掉尾部空格
    newText := RegExReplace(newText, "^#{1,6}\s+(.*)", "$1")
    nums := SubStr(A_ThisHotkey, 2)
    Send "{Home}{# " . nums . "}" . ' '
    ; 之所以拆开是为防止被中文输入法影响
    SendText newText
    Send '{End}'
    A_Clipboard := oldText
}
#HotIf

^!r::Reload ; Ctrl + Alt + R 重启脚本
^!s::aTrayMenu.mySuspend() ; Ctrl + Alt + S 暂停脚本
^!v::Send A_Clipboard ; Ctrl + Alt + V 将剪贴板的内容输入到当前活动应用程序中，防止了一些网站禁止在 HTML 密码框中进行粘贴操作
^+"::Send '""{Left}' ; Ctrl + Shift + " 快捷操作-插入双引号

!Space::Anyrun ; 启动窗口

; ----- 热串 之 打开网址。选择 z 而非 q，因为 q 的距离在第一行太远了，我称之为 Z 模式，用于全局跳转网址 -----
; ----- 热串 之 缩写扩展：将短缩词自动扩展为长词或长句（英文单词中哪个字母开头的单词数最少，我称之为 X 模式）-----
; ----- 热串 之 片段展开-----
; ----- 热串 之 自定义表情符号：将输入的特定字符串替换为自定义的表情符号或 Emoji -----

:C*:xnow::{
    SendText FormatTime(, 'yyyy-MM-dd HH:mm:ss')
}
:C*:xdate::{
    SendText FormatTime(, "'date:' yyyy-MM-dd HH:mm:ss")
}

; ----- 其他-----

; 按住 CapsLock 后可以用鼠标左键拖动窗口
; CapsLock & LButton::EWD_MoveWindow

; 设置托盘图标和菜单
SettingTray() {
    A_TrayMenu.Delete()
    global aTrayMenu := MyTrayMenu()

    localIsAlphaOrBeta := InStr(CodeVersion, "alpha") OR InStr(CodeVersion, "beta")
    A_IconTip := "捷键 " . CodeVersion . (A_IsCompiled ? "" : " 未编译") . (localIsAlphaOrBeta ? " 测试版" : " ") . (A_PtrSize == 4 ? '32位' : '64位')

    if (NOT A_IsCompiled) {
        ; 建议使用 16*16 或 32*32 像素的图标，使用 Ahk2Exe-Let 提取出 favicon.ico
        faviconIco := 'favicon.ico'
        ;@Ahk2Exe-Let U_faviconIco = %A_PriorLine~U).+['"](.+)['"]~$1%
        ;@Ahk2Exe-SetMainIcon %U_faviconIco%
        TraySetIcon(faviconIco)
    }
}

; 注册一个当脚本退出时, 会自动调用的函数
OnExit ExitFunc

ExitFunc(exitReason, exitCode) {
    ; 统计软件使用总分钟数
    minutesDiff := DateDiff(A_NowUTC, START_TIME, 'Minutes')
    if (minutesDiff > 0) {
        recordMinsValueName := 'record_mins'
        recordMins := RegRead(REG_KEY_NAME, recordMinsValueName, 0) + minutesDiff
        RegWrite(recordMins, "REG_DWORD", REG_KEY_NAME, recordMinsValueName)
    }
    ; 统计软件使用次数
    if (NOT exitReason ~= "i)^(?:Error|Reload|Single)$") {
        launchCountValueName := 'launch_count'
        launchCount := RegRead(REG_KEY_NAME, launchCountValueName, 1) + 1
        RegWrite(launchCount, "REG_DWORD", REG_KEY_NAME, launchCountValueName)
    }
}

; 触发热键时, 热键中按键原有的功能不会被屏蔽(对操作系统隐藏)
~LButton & a::
^!1::{
    ; 没有获取到文字直接返回,否则若选中的是网址则打开，否则进行百度搜索
    text := GetSelectedText()
    if (text) {
        if RegExMatch(text, "i)^\s*((?:https?://)?(?:[\w-]+\.)+[\w-]+(?:/[\w-./?%&=]*)?\s*)$", &regExMatchInfo) {
            text := regExMatchInfo.1
            if NOT InStr(text, 'http')
                text := "http://" . text
            Run(text)
        } else Run('https://www.baidu.com/s?wd=' . text)
    }
}

GenerateShortcuts() {
  ; 每次运行检测如果 shortcuts 里的文件为空则重新生成一次快捷方式，要想重新生成可以双击 GenerateShortcuts.ahk 脚本或者清空或删除该文件夹
  if !FileExist(A_WorkingDir . "\shortcuts\*")
    Run('extra/GenerateShortcuts.exe')
}
 
; 双击模式我比较推荐 双击 alt 和 双击 Alt，因为 shift 可能会影响到输入法中英文切换
~Ctrl::{
    if (ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey > 60 && A_TimeSincePriorHotkey < 210 AND MsgBox("立即关机?", APP_NAME, "YesNo") = "Yes")            
        SystemShutdown()
}

~Alt::{
    if (ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey > 60 && A_TimeSincePriorHotkey < 210 AND MsgBox("立即睡眠?", APP_NAME, "YesNo") = "Yes")
        SystemSleep()
}

~Shift::{ ; Shift 键一般用得很少
    if (A_PriorHotkey != "~Shift" or A_TimeSincePriorHotkey > 210) {
        KeyWait "Shift"
        return
    }
    if (MsgBox("立即锁屏?", APP_NAME, "YesNo") = "Yes")
        SystemSleepScreen()
}
~^c::{ ; 监控 ctrl + 按键
    global ctrlTimeStamp := A_NowUTC
}
~^v::{ ; 监控 ctrl + 按键
    global ctrlTimeStamp := A_NowUTC
}

; CapsLock 模式
; 短按依旧有用，但是 CapsLock + 其他键有自己的用法，且确保了 CapsLock 灯不会闪

global CapsLock := ""
global CapsLock2 := ""

Capslock::{
    global CapsLock, CapsLock2
    ;Capslock:  Capslock 键状态标记，按下是 1，松开是 0
    ;Capslock2: 是否使用过 Capslock+ 功能标记，使用过会清除这个变量
    CapsLock := CapsLock2 := 1

    SetTimer(setCapsLock2, -300) ; 300ms 犹豫操作时间

    KeyWait "CapsLock" ; 等待用户物理释放按键
    CapsLock := "" ; Capslock 先置空，来关闭 Capslock+ 功能的触发
    ; 松开的时候才切换大小写
    if CapsLock2
        SetCapsLockState !GetKeyState("CapsLock", "T")
    CapsLock2 := ""
}

; 需要按一次按键才会生效，时好时坏
#HotIf CapsLock
; 相当于 CapsLock + t
t::WinSetTransparent 210, 'A'

; 相当于 CapsLock + Z 复制路径
z::{
    A_Clipboard := ""
    Send "^c"
    if !ClipWait(1) {
        Tip("复制失败")
    } else {
        A_Clipboard := A_Clipboard
        Tip("路径已复制")
    }
}
; 恢复不透明
x::WinSetTransparent "Off", 'A'
#HotIf

setCapsLock2() {
    global CapsLock2 := ""
}
