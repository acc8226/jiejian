/*
捷键 --- 更简单和易用的 windows 小工具。

它简化了计算机操作。模拟键盘按键、鼠标点击等操作，从而实现自动化任务、自定义快捷键和用户界面增强等功能。

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
#Requires AutoHotkey v2.0
#SingleInstance force
#Include "modules\anyrun.ahk"
#Include "modules\data.ahk"
#Include "modules\utils.ahk"

; 设置托盘图标和菜单
settingTray() {
    A_IconTip := "捷键"
    item_count := DllCall("GetMenuItemCount", "ptr", A_TrayMenu.Handle)
    A_TrayMenu.Insert(item_count "&", "捷键 2023.09 by acc8226", MenuHandler)
    Persistent
    ; 建议使用宽度为 16 或 32 像素的图标
    TraySetIcon "favicon.ico"

    MenuHandler(*) {
        Run "https://gitee.com/acc8226/shortcut-key/releases/"
    }
}
settingTray()

; ----- 1. 热键 之 鼠标操作 -----
#HotIf mouseIsOverTaskBarOrLeftEdge()
WheelUp::Send "{Volume_Up}"
WheelDown::Send "{Volume_Down}"

; ----- 2. 热键 之 重写快捷键 -----
; 禁用快捷键
;^v::return

; 设计原则，根据 hotIf 的优先匹配，先小后大进行判断
; ESC 增强
; 系统类软件 记事本
#HotIf WinActive("ahk_exe notepad.exe")
Esc::WinClose "A"

;^F3 新建标签/窗口
; 标签类软件 vs code
#HotIf WinActive("ahk_exe Code.exe")
^F3::Send "{Control Down}n{Control Up}"
; 系统类软件 资源管理器
#HotIf WinActive("ahk_class SunAwtFrame ahk_exe javaw.exe") ; netbean 32 位 / jmeter
    or WinActive("ahk_class SunAwtFrame ahk_exe netbeans64.exe") ; netbean 64 位
    or WinActive("ahk_exe devenv.exe") ; visual studio
    or WinActive("ahk_exe explorer.exe ahk_class CabinetWClass")
    or WinActive("ahk_exe eclipse.exe")
    or WinActive("ahk_exe editplus.exe")
    or WinActive("ahk_exe Fleet.exe")
    or WinActive("ahk_class SWT_Window0 ahk_exe javaw.exe") ; myeclipse
    or WinActive("ahk_exe kate.exe")
    or WinActive("ahk_exe Notepad--.exe")
    or WinActive("ahk_exe notepad++.exe")
    or WinActive("ahk_exe SpringToolSuite4.exe")
    or WinActive("ahk_exe sublime_text.exe")
    or WinActive("ahk_exe ahk_exe uedit64.exe")
    or WinActive("ahk_exe wps.exe")
^F3::Send "^n"
; 标签类软件 Windows Terminall ---不太好用，目前是失效状态---
#HotIf WinActive("ahk_exe WindowsTerminal.exe")
^F3::Send "^+t"
; 标签类软件（浏览器大类，类浏览器）
#HotIf WinActive("ahk_group browser_group")
    or WinActive("ahk_group browser_like")
    or WinActive("ahk_exe HBuilderX.exe")
^F3::Send "^t" ; 统一为 ctrl + t 意为新建标签

; ^F4 表示 esc 退出弹窗
#HotIf WinActive("ahk_class SunAwtDialog") ; netbean 32/64 位 和 jb 全家桶的弹窗
    or WinActive("ahk_class Chrome_WidgetWin_2 ahk_exe 360ChromeX.exe") ; 360 极速浏览器的下载管理窗口    
    or WinActive("ahk_class #32770") and not WinActive("ahk_exe 360zip.exe") 
    ; 特定软件
    or WinActive("ahk_exe devenv.exe") ; Visual Studio 窗口的特殊处理
       and (WinActive("Microsoft Visual Studio 帐户设置")
           or WinActive("自定义")
           or WinActive("关于 Microsoft Visual Studio")
        )
    or WinActive("ahk_exe QQ.exe")
    or WinActive("ahk_exe Snipaste.exe")
    or WinActive("ahk_exe WeChat.exe")
^F4::{
    Send "{Esc}"
}

; ^F4 关闭标签/窗口/应用
; 桌面
#HotIf WinActive("ahk_exe explorer.exe ahk_class WorkerW")
^F4::{ ; 直接 Send alt + f4 不好使
    Send "{Alt Down}{F4 Down}{F4 Up}{Alt Up}"
}
; 标签类软件 Windows Terminal ---不太好用，目前仅设置页面有时有效---
#HotIf WinActive("ahk_exe WindowsTerminal.exe")
^F4::Send "^+w"
; 资源管理器 或者 标签类软件（类浏览器）
#HotIf WinActive("ahk_class CabinetWClass ahk_exe explorer.exe")
    or WinActive("ahk_exe editplus.exe")      
    or WinActive("ahk_exe kate.exe")
    or WinActive("ahk_exe Notepad--.exe")
    or WinActive("ahk_exe notepad++.exe")
    or WinActive("ahk_group browser_like")
^F4::Send "^w"
; 兜底：排除的软件设置为 close
#HotIf not (WinActive("ahk_exe Code.exe")
         or WinActive("ahk_exe devenv.exe") ; visual studio
         or WinActive("ahk_exe eclipse.exe")
         or WinActive("ahk_exe HBuilderX.exe")
         or WinActive("ahk_class SWT_Window0 ahk_exe javaw.exe") ; 排除 myeclipse
         or WinActive("ahk_exe SpringToolSuite4.exe")
         or WinActive("ahk_exe sublime_text.exe")
         or WinActive("ahk_exe SumatraPDF.exe ahk_class SUMATRA_PDF_FRAME")         
         or WinActive("ahk_class SunAwtFrame",,"Apache JMeter") ; 排除 netbean 32/64 位 和标签类软件 jb 全家桶
         or WinActive("ahk_exe ahk_exe uedit64.exe")
         or WinActive("ahk_exe wps.exe")
         or WinActive("ahk_group browser_group")
        )
^F4::{
    try WinClose "A"
    catch {
        MsgBox "关闭窗口失败，请重试"
    }
}

; 切换标签
#HotIf WinActive("ahk_exe eclipse.exe") 
    or WinActive("ahk_exe HBuilderX.exe")
    or WinActive("ahk_class SunAwtFrame ahk_exe javaw.exe") ; netbean 32 位 / jmeter
    or WinActive("ahk_class SunAwtFrame ahk_exe netbeans64.exe") ; netbean 64 位
    or WinActive("ahk_class SWT_Window0 ahk_exe javaw.exe") ; myeclipse
    or WinActive("ahk_exe SpringToolSuite4.exe")
^+Tab::Send "^{PgUp}" ; 切换到左标签
^Tab::Send "^{PgDn}" ; 切换到右标签
; 标签类软件 jb 全家桶
#HotIf WinActive("ahk_exe kate.exe")
    or WinActive("ahk_class SunAwtFrame")
^+Tab::Send "!{Left}" ; 切换到左标签
^Tab::Send "!{Right}" ; 切换到右标签
#HotIf ; 结束标记

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

; 注册热键 和 热字符串
Loop appList.Length {
    it := appList[A_Index]
    ; 热键
    if StrLen(it.hk) > 0 and StrLen(it.path) > 0
        Hotkey it.hk, appStartByHk
    ; 热串
    if StrLen(it.hs) > 0 {
        if it.type == "web" {
            ; 排除 vscode 和 【浏览器中鼠标处于光标形状，由于 CaretGetPos() 目前不太完美】
            HotIf (*) => not (WinActive("ahk_exe Code.exe")
                              or WinActive("ahk_group browser_group") and A_Cursor == 'IBeam'
                         )
            Hotstring ":C*:" it.hs, openUrl
        } else if it.type == "text" {
            ; 由于 CaretGetPos() 目前不太完美，目前只排除 vscode
            HotIf (*) => not WinActive("ahk_exe Code.exe")
            Hotstring ":C*:" it.hs, it.path
        }
    }
}
; ----- 4. 热键 之 运行程序 ;问题是怎么添加应用商店的路径-----
; !1::Run "explorer"

; ----- 5. 热键 之 启动文件夹 -----
; !d::Run "D:"

; ----- 6. 热键 之 其他 -----
; ctrl + 数字 1-5 为光标所在行添加 markdown 格式标题
#HotIf WinActive("ahk_group text_group")
^1::
^2::
^3::
^4::
^5::{
    nums := SubStr(A_ThisHotkey, 2)
    oldText := A_Clipboard
    A_Clipboard := ""
    Send "{Home}{Shift Down}{End}{Shift Up}" ; 切到首部然后选中到尾部
    Sleep 100
    Send "^x"
    ClipWait  ; 等待剪贴板中出现文本.
    newText := A_Clipboard
    newText := RegExReplace(newText, "\s*$", "") ; 去掉尾部空格
    newText := RegExReplace(newText, "^#{1,6}\s+(.*)", "$1")
    Send "{Home}{# " . nums . "}" . " "
    ; 之所以拆开是为防止被中文输入法影响
    SendText newText
    Send "{End}"
    A_Clipboard := oldText
}
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

openUrl(hs) {
    Run webFindPathByHs(appList, StrReplace(hs, ":C*:"))
}
