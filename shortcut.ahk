/*
捷键-为简化 windows 操作。可自定义快捷键、快捷键改写、快捷键功能增强。提供快捷启动等功能。可搭配契合鼠标手势软件。

快速参考 | AutoHotkey v2
https://wyagd001.github.io/v2/docs/

考虑到快捷键的方便性，原则上只使用和改写现有快捷键，但是如果原有快捷键已经占用则会考虑新造快捷键
*/
#Requires AutoHotkey >=v2.0
#SingleInstance force ; 跳过对话框并自动替换旧实例

; ----- 1. 热键 之 鼠标操作 -----
global isDebug := true

CoordMode "Mouse" ; 默认坐标相对于桌面(整个屏幕)

#Include "lib\Functions.ahk"
#Include "lib\Actions.ahk"
#Include "lib\MoveWindow.ahk"

#Include "modules\configMouse.ahk"
#Include "modules\utils.ahk"
#Include "modules\anyrun.ahk"
#Include "modules\readApp.ahk"
#Include "modules\readData.ahk"

; 设置托盘图标和菜单
settingTray() {
    A_IconTip := "捷键"
    itemCount := DllCall("GetMenuItemCount", "ptr", A_TrayMenu.Handle)
    
    MenuHandler1(*) {
        Run "https://gitcode.com/acc8226/jiejian/overview"
    }
    A_TrayMenu.Insert(itemCount++ . "&", "帮助", MenuHandler1)

    MenuHandler2(*) {
        Run "https://gitcode.com/acc8226/jiejian/releases"
    }
    A_TrayMenu.Insert(itemCount++ . "&", "捷键 24年1月 beta 版", MenuHandler2)

    MenuHandler3(*) {
        Run "https://gitcode.com/acc8226/"
    }
    A_TrayMenu.Insert(itemCount++ . "&", "关于作者", MenuHandler3)

    Persistent
    ; 建议使用 16*16 或 32*32 像素的图标
    TraySetIcon "favicon.ico"
}
settingTray()

; ----- 2. 热键 之 快捷键重写和增强 -----

; 禁用快捷键
;^v::return

; 仅是实验，使用 Alt 则怕和编辑器冲突，能鼠标手势还是鼠标手势靠谱，跳过了快捷键，实现效果更好
; ; alt + m Minimize 最小化当前活动窗口
; !m::WinMinimize "A"
; ; alt + f fullscreen 最大化或还原
; !f::{
;     minMax := WinGetMinMax("A")
;     if minMax = 1
;         WinRestore "A"
;     else
;         WinMaximize "A"
; }
; ; alt + q quit 关闭窗口/不一定会退出程序
; !q::WinClose "A" ; 否则统一为关闭

; ----- 3. 热键 之 打开网址 -----
; !6::Run url_bilibili

; ----- 4. 热键 之 运行程序 ;问题是怎么添加应用商店的路径-----
; !1::Run "explorer"

; ----- 5. 热键 之 启动文件夹 -----
; !d::Run "D:"

; ----- 6. 热键 之 其他 -----
; 文本类 为了 md 增强 记事本 & vscode
; ctrl + 数字 1-5 为光标所在行添加 markdown 格式标题
#HotIf WinActive("ahk_exe notepad.exe") or WinActive("ahk_exe Notepad.exe") or WinActive("ahk_class Chrome_WidgetWin_1 ahk_exe Code.exe") 
^1::
^2::
^3::
^4::
^5::{
    oldText := A_Clipboard
    A_Clipboard := ""
    Send "{Home}{Shift Down}{End}{Shift Up}" ; 切到首部然后选中到尾部
    Sleep 100
    Send "^x"
    ClipWait ; 等待剪贴板中出现文本.
    newText := RegExReplace(A_Clipboard, "\s*$", "") ; 去掉尾部空格
    newText := RegExReplace(newText, "^#{1,6}\s+(.*)", "$1")
    nums := SubStr(A_ThisHotkey, 2)
    Send "{Home}{# " . nums . "}" . " "
    ; 之所以拆开是为防止被中文输入法影响
    SendText newText
    Send "{End}"
    A_Clipboard := oldText
}

; 暂停脚本 Ctrl+Alt+S
#HotIf isDebug
^!s::Suspend
#HotIf
; ctrl + alt + v 将剪贴板的内容输入到当前活动应用程序中，防止了一些网站禁止在 HTML 密码框中进行粘贴操作
^!v::Send A_Clipboard
^+"::Send '""{Left}' ; ctrl + shift + " 快捷操作-插入双引号
^!r::Reload ; Ctrl + Alt + R 重启脚本
!Space::anyrun ; 启动窗口

; ----- 7. 热串 之 打开网址。选择 z 而非 q，因为 q 的距离在第一行太远了，我称之为 Z 模式，用于全局跳转网址 -----
; ----- 8. 热串之 缩写扩展：将短缩词自动扩展为长词或长句（英文单词中哪个字母开头的单词数最少，我称之为 X 模式）-----
; :C*:xnb::很牛呀
:C*:xnow::{
    SendText FormatTime(, "yyyy-MM-dd HH:mm:ss")
}
:C*:xdate::{
    SendText FormatTime(, "'date:' yyyy-MM-dd HH:mm:ss")
}
; ----- 9. 热串之 片段展开-----
; C 区分大小写  * 不需要额外键入终止符

; ----- 10. 热串之 自定义表情符号：将输入的特定字符串替换为自定义的表情符号或 Emoji -----
; :C*:xwx::😄 ; 微笑

; ----- 11. 其他-----
; 按住 CapsLock 后可以用鼠标左键拖动窗口
CapsLock & LButton::EWD_MoveWindow
