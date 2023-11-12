/*
捷键-一个简单易用的 windows 小工具

只为简化操作。模拟键盘按键、鼠标点击等操作，从而实现自动化任务、自定义快捷键和用户界面增强等功能。

快速参考 | AutoHotkey v2
https://wyagd001.github.io/v2/docs/

考虑到快捷键的方便性，原则上只使用和改写现有快捷键，但是如果原有快捷键已经占用则只能新造快捷键

* ctrl + f3 新建标签/窗口 避免和已有 ctrl + t 冲突
* ctrl + shift + tab / ctrl + tab 切换到上/下个标签 默认不需要重写
* ctrl + f4 关闭标签/窗口
* ctrl + shift + t 撤销关闭标签 默认不需要重写

* 前进 默认 alt + 右
* 后退 默认 alt + 左

* Esc 逃逸键 用于关闭窗口 目前仅支持记事本
*/
#Requires AutoHotkey >=v2.0
#SingleInstance force ; 跳过对话框并自动替换旧实例

; ----- 1. 热键 之 鼠标操作 -----
#Include "modules\configMouse.ahk"
#Include "modules\anyrun.ahk"
#Include "modules\readApp.ahk"
#Include "modules\readData.ahk"
#Include "modules\utils.ahk"

global isDebug := false

SetTitleMatchMode "RegEx" ; 使 WinTitle, WinText, ExcludeTitle 和 ExcludeText 接受正则表达式
CoordMode "Mouse", "Screen" ; 坐标相对于桌面(整个屏幕)

; 设置托盘图标和菜单
settingTray() {
    A_IconTip := "捷键"
    itemCount := DllCall("GetMenuItemCount", "ptr", A_TrayMenu.Handle)
    MenuHandler(*) {
        Run "https://gitee.com/acc8226/shortcut-key/releases/"
    }
    A_TrayMenu.Insert(itemCount . "&", "捷键 2023.10 by acc8226", MenuHandler)
    Persistent
    ; 建议使用宽度为 16 或 32 像素的图标
    TraySetIcon "favicon.ico"
}
settingTray()

; ----- 2. 热键 之 快捷键重写和增强 -----

; 禁用快捷键
;^v::return

; 仅是实验，使用 alt 就怕和编辑器冲突，能鼠标手势还是鼠标手势靠谱，跳过了快捷键，实现效果更好
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
#HotIf WinActive("ahk_exe i)notepad.exe") or WinActive("ahk_exe i)Code.exe") 
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
