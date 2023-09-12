; 窗口组可以用来使热键为一组窗口执行

; 标签类：浏览器大类 使用了 标准的 ctrl + t 新建标签， ctrl + f4 关闭标签
; 测试通过过的浏览器：360极速浏览器、Chrome 谷歌浏览器、DuckDuckGo 浏览器、Firefox 火狐系浏览器
; 理论上兼容的浏览器（未经过完全测试）：360 安全浏览器、QQ 浏览器、傲游浏览器、猎豹浏览器、极速浏览器
; 目前已知对搜狗浏览器极度不兼容
GroupAdd "browser_group", "ahk_exe i)115chrome.exe" ; 115 浏览器
GroupAdd "browser_group", "ahk_exe i)2345Explorer.exe" ; 2345 浏览器
GroupAdd "browser_group", "ahk_exe i)360ChromeX.exe" ; 360 极速浏览器
GroupAdd "browser_group", "ahk_exe i)360se.exe" ; 360 安全浏览器
GroupAdd "browser_group", "ahk_exe i)AvastBrowser.exe" ; Avast 浏览器

GroupAdd "browser_group", "ahk_exe i)brave.exe" ; brave 浏览器
GroupAdd "browser_group", "ahk_exe browser.exe ahk_class YandexBrowser_WidgetWin_1" ; Yandex Browser
GroupAdd "browser_group", "ahk_exe i)chrome.exe" ; chrome 谷歌浏览器 & 百分浏览器
GroupAdd "browser_group", "ahk_exe i)DCBrowser.exe" ; 小智双核浏览器
GroupAdd "browser_group", "ahk_exe i)DuckDuckGo.exe" ; Duck 浏览器

GroupAdd "browser_group", "ahk_exe i)firefox.exe" ; 火狐安全浏览器 & Tor 浏览器
GroupAdd "browser_group", "ahk_exe i)HuaweiBrowser.exe" ; 华为浏览器
GroupAdd "browser_group", "ahk_exe i)liebao.exe" ; 猎豹浏览器
GroupAdd "browser_group", "ahk_exe i)msedge.exe" ; edge 浏览器
GroupAdd "browser_group", "ahk_exe i)Maxthon.exe" ; 傲游浏览器

GroupAdd "browser_group", "ahk_exe i)opera.exe" ; opera 浏览器
GroupAdd "browser_group", "ahk_exe i)QQBrowser.exe" ; QQ 浏览器
GroupAdd "browser_group", "ahk_exe i)TSBrowser.exe" ; 极速浏览器
GroupAdd "browser_group", "ahk_exe i)SLBrowser.exe" ; 联想浏览器
GroupAdd "browser_group", "ahk_exe i)SogouExplorer.exe" ; 搜狗浏览器

GroupAdd "browser_group", "ahk_exe i)twinkstar.exe" ; 星愿浏览器
GroupAdd "browser_group", "ahk_exe i)UCBrowser.exe" ; UC 浏览器
GroupAdd "browser_group", "ahk_exe i)vivaldi.exe" ; vivaldi 浏览器
GroupAdd "browser_group", "ahk_exe i)waterfox.exe" ; waterfox 浏览器
GroupAdd "browser_group", "ahk_exe i)Yidian.exe" ; 一点浏览器 搜狗 过时

; 标签类：类浏览器 使用了 标准的 ctrl + t 新建标签， ctrl + w 关闭标签
GroupAdd "browser_like_group", "ahk_exe i)Beekeeper Studio.exe"
GroupAdd "browser_like_group", "ahk_exe i)BCompare.exe"
GroupAdd "browser_like_group", "ahk_exe i)notepad.exe" ; 完美适配 win11 新版 记事本
GroupAdd "browser_like_group", "ahk_exe i)Postman.exe"
GroupAdd "browser_like_group", "ahk_exe i)SourceTree.exe"

; 文本类 为了 md 增强
GroupAdd "text_group", "ahk_exe i)notepad.exe" ; 记事本
GroupAdd "text_group", "ahk_exe i)Code.exe" ; vscode

; 使用了 标准的 ctrl + f4 关闭标签
GroupAdd "keepF4_group", "ahk_exe i)Code.exe"
GroupAdd "keepF4_group", "ahk_exe i)devenv.exe"
GroupAdd "keepF4_group", "ahk_exe i)eclipse.exe"
GroupAdd "keepF4_group", "ahk_exe i)HBuilderX.exe"
GroupAdd "keepF4_group", "ahk_exe javaw.exe ahk_class SWT_Window0"

GroupAdd "keepF4_group", "ahk_exe i)SecureCRT.exe"
GroupAdd "keepF4_group", "ahk_exe i)SpringToolSuite4.exe"
GroupAdd "keepF4_group", "ahk_exe i)sublime_text.exe"
GroupAdd "keepF4_group", "ahk_exe i)SumatraPDF.exe ahk_class SUMATRA_PDF_FRAME"
GroupAdd "keepF4_group", "ahk_class SunAwtFrame",,"Apache JMeter" ; netbean 32/64 位 & 标签类软件 jb 全家桶 & fleet
GroupAdd "keepF4_group", "ahk_exe i)uedit64.exe"

GroupAdd "keepF4_group", "ahk_exe i)WinMergeU.exe"
GroupAdd "keepF4_group", "ahk_exe i)wps.exe"
GroupAdd "keepF4_group", "ahk_group browser_group"

; 使用了 标准的 ctrl + shift + tab 切换上一个标签
GroupAdd "keep_ctrl_shift_tab_group", "ahk_exe i)Code.exe"
GroupAdd "keep_ctrl_shift_tab_group", "ahk_exe i)Notepad.exe"
GroupAdd "keep_ctrl_shift_tab_group", "ahk_exe i)Postman.exe"
GroupAdd "keep_ctrl_shift_tab_group", "ahk_exe i)SecureCRT.exe"

GroupAdd "keep_ctrl_shift_tab_group", "ahk_exe i)Xftp.exe"
GroupAdd "keep_ctrl_shift_tab_group", "ahk_exe i)Xshell.exe"

GroupAdd "keep_ctrl_shift_tab_group", "ahk_exe i)wps.exe"
GroupAdd "keep_ctrl_shift_tab_group", "ahk_exe i)zoc.exe"

; 标签类：终端类 ctrl + shift + t 新建标签， ctrl + shift + w 关闭标签
GroupAdd "terminal_group", "ahk_exe i)Tabby.exe"
GroupAdd "terminal_group", "ahk_exe i)Termius.exe"
GroupAdd "terminal_group", "ahk_exe i)WindowsTerminal.exe"

global appList := parseAppInfo()

parseAppInfo() {
  appList := []
  ; 每次从字符串中检索字符串(片段)
  Loop Parse, FileRead("appList.csv", "UTF-8"), "`n", "`r" {
      ; 跳过首行
      if A_Index = 1
          continue

      appInfo := parseLine(A_LoopField)    
      if appInfo
          appList.Push(appInfo)
  }
  return appList  
}

parseLine(line) {  
  split := StrSplit(line, ",")
  if split.Length != 6
    return 
  
  info := {}
  info.type := Trim(split[1])

  ; 去掉首尾的双引号，但不知为何首尾的一对双引号会转义为三对
  info.path := Trim(split[2])
  if StrLen(info.path) > 1 and '"""' == SubStr(info.path, 1, 3) and '"""' == SubStr(info.path, -3)
    info.path := SubStr(info.path, 4, -3)

  info.title := Trim(split[3])  
  aliases := StrSplit(Trim(split[4]), "|")
  ; 如果数组长度 > 1 则存成数组
  info.alias := (aliases.Length > 1) ? aliases : Trim(split[4])
  info.hk := Trim(split[5])
  info.hs := Trim(split[6])

  return info
}
