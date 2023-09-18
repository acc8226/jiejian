; 窗口组可以用来使热键为一组窗口执行

; 标签类：浏览器大类 使用了 标准的 ctrl + t 新建标签 ctrl + f4 关闭标签 ctrl + tab 进行翻页
; 测试通过过的浏览器：360极速浏览器、Chrome 谷歌浏览器、DuckDuckGo 浏览器、Firefox 火狐系浏览器
; 理论上兼容的浏览器（未经过完全测试）：360 安全浏览器、QQ 浏览器、傲游浏览器、猎豹浏览器、极速浏览器
; 目前已知对搜狗浏览器极度不兼容
GroupAdd "browser_group", "ahk_exe i)123browser.exe" ; 123 浏览器  
GroupAdd "browser_group", "ahk_exe i)115chrome.exe" ; 115 浏览器
GroupAdd "browser_group", "ahk_exe i)2345Explorer.exe" ; 2345 浏览器
GroupAdd "browser_group", "ahk_exe i)360ChromeX.exe" ; 360 极速浏览器【推荐】 https://browser.360.cn/eex/index.html
GroupAdd "browser_group", "ahk_exe i)360se.exe" ; 360 安全浏览器

GroupAdd "browser_group", "ahk_exe i)AvastBrowser.exe" ; Avast 浏览器
GroupAdd "browser_group", "ahk_exe i)brave.exe" ; brave 浏览器
GroupAdd "browser_group", "ahk_exe browser.exe ahk_class YandexBrowser_WidgetWin_1" ; Yandex Browser
GroupAdd "browser_group", "ahk_exe i)catsxp.exe" ; 猫眼浏览器【推荐】难得有鼠标悬停 https://www.catsxp.com/zh-hans/
GroupAdd "browser_group", "ahk_exe i)chrome.exe" ; chrome 谷歌浏览器 & 百分浏览器

GroupAdd "browser_group", "ahk_exe i)DCBrowser.exe" ; 小智双核浏览器
GroupAdd "browser_group", "ahk_exe i)DuckDuckGo.exe" ; Duck 浏览器
GroupAdd "browser_group", "ahk_exe i)duoyu.exe" ; duoyu 多御浏览器
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
GroupAdd "browser_group", "ahk_exe i)redcore.exe" ; 红芯浏览器 淘汰
GroupAdd "browser_group", "ahk_exe i)MyIE9.exe" ; 蚂蚁浏览器官方网站(MyIE®浏览器) 这是一款纯 IE 内核浏览器
GroupAdd "browser_group", "ahk_exe i)Colorfulstone.exe" ; 斑斓石浏览器

; 标签类：类浏览器 使用了 标准的 ctrl + t 新建标签， ctrl + w 关闭标签
GroupAdd "browser_like_group", "ahk_exe i)Beekeeper Studio.exe"
GroupAdd "browser_like_group", "ahk_exe i)BCompare.exe"
GroupAdd "browser_like_group", "ahk_exe i)notepad.exe" ; 完美适配 win11 新版 记事本
GroupAdd "browser_like_group", "ahk_exe i)Postman.exe"
GroupAdd "browser_like_group", "ahk_exe i)SourceTree.exe"

; 文本类 为了 md 增强
GroupAdd "text_group", "ahk_exe i)notepad.exe" ; 记事本
GroupAdd "text_group", "ahk_exe i)Code.exe" ; vscode

; 标签类：终端类 ctrl + shift + t 新建标签， ctrl + shift + w 关闭标签
GroupAdd "terminal_group", "ahk_exe i)Tabby.exe"
GroupAdd "terminal_group", "ahk_exe i)Termius.exe"
GroupAdd "terminal_group", "ahk_exe i)WindowsTerminal.exe"

; ctrl + n 新建标签 / 窗口 
GroupAdd "keep_ctrl_n_g", "ahk_exe i)devenv.exe" ; visual studio
GroupAdd "keep_ctrl_n_g", "ahk_exe i)eclipse.exe"
GroupAdd "keep_ctrl_n_g", "ahk_exe i)editplus.exe"
GroupAdd "keep_ctrl_n_g", "ahk_exe i)EverEdit.exe"
GroupAdd "keep_ctrl_n_g", "ahk_exe i)Fleet.exe"

GroupAdd "keep_ctrl_n_g", "ahk_exe i)MarkdownPad2.exe"
GroupAdd "keep_ctrl_n_g", "ahk_exe i)GitHubDesktop.exe"
GroupAdd "keep_ctrl_n_g", "ahk_exe i)kate.exe"
GroupAdd "keep_ctrl_n_g", "ahk_exe javaw.exe ahk_class SunAwtFrame" ; netbean 32 位 / jmeter
GroupAdd "keep_ctrl_n_g", "ahk_exe javaw.exe ahk_class SWT_Window0" ; myeclipse

GroupAdd "keep_ctrl_n_g", "ahk_exe netbeans64.exe ahk_class SunAwtFrame" ; netbean 64 位
GroupAdd "keep_ctrl_n_g", "ahk_exe i)notepad++.exe"
GroupAdd "keep_ctrl_n_g", "ahk_exe i)Notepad--.exe"
GroupAdd "keep_ctrl_n_g", "ahk_exe i)SpringToolSuite4.exe"
GroupAdd "keep_ctrl_n_g", "ahk_exe i)sublime_text.exe"

GroupAdd "keep_ctrl_n_g", "ahk_exe i)uedit64.exe"
GroupAdd "keep_ctrl_n_g", "ahk_exe i)WinMergeU.exe"
GroupAdd "keep_ctrl_n_g", "ahk_exe i)wps.exe"
GroupAdd "keep_ctrl_n_g", "ahk_exe i)Xftp.exe"
GroupAdd "keep_ctrl_n_g", "ahk_exe i)Brackets.exe"
GroupAdd "keep_ctrl_n_g", "ahk_exe i)devcpp.exe"

GroupAdd "keep_ctrl_n_g", "ahk_exe i)Typora.exe"
GroupAdd "keep_ctrl_n_g", "ahk_exe i)skylark.exe"
GroupAdd "keep_ctrl_n_g", "ahk_exe i)Notepad2.exe"
GroupAdd "keep_ctrl_n_g", "ahk_exe i)Notepad3.exe"

; ctrl + t 新建标签 / 窗口 
GroupAdd "keep_ctrl_t_g", "ahk_exe explorer.exe ahk_class CabinetWClass" ; 系统类软件 win 11 版资源管理器终于支持多标签页了
GroupAdd "keep_ctrl_t_g", "ahk_exe i)HBuilderX.exe"
GroupAdd "keep_ctrl_t_g", "ahk_exe i)heidisql.exe"
GroupAdd "keep_ctrl_t_g", "ahk_exe i)notepad.exe"
GroupAdd "keep_ctrl_t_g", "ahk_exe i)MarkText.exe"

GroupAdd "keep_ctrl_t_g", "ahk_exe i)SQLyog.exe"
GroupAdd "keep_ctrl_t_g", "ahk_exe i)想天浏览器.exe"

GroupAdd "keep_ctrl_t_g", "ahk_group browser_group"
GroupAdd "keep_ctrl_t_g", "ahk_group browser_like_group" ; 标签类软件（浏览器大类，类浏览器）

; ctrl + w 关闭标签
GroupAdd "keep_ctrl_w_g", "ahk_exe i)想天浏览器.exe"
GroupAdd "keep_ctrl_w_g", "ahk_exe i)Brackets.exe"
GroupAdd "keep_ctrl_w_g", "ahk_exe i)editplus.exe" ; editplus
GroupAdd "keep_ctrl_w_g", "ahk_exe i)EverEdit.exe"
GroupAdd "keep_ctrl_w_g", "ahk_exe explorer.exe ahk_class CabinetWClass" ; 资源管理器
GroupAdd "keep_ctrl_w_g", "ahk_exe i)kate.exe"

GroupAdd "keep_ctrl_w_g", "ahk_exe i)MarkText.exe"
GroupAdd "keep_ctrl_w_g", "ahk_exe i)Notepad.exe"
GroupAdd "keep_ctrl_w_g", "ahk_exe i)Notepad--.exe"
GroupAdd "keep_ctrl_w_g", "ahk_exe i)notepad++.exe"
GroupAdd "keep_ctrl_w_g", "ahk_exe i)thunderbird.exe"
GroupAdd "keep_ctrl_w_g", "ahk_exe i)devcpp.exe"
GroupAdd "keep_ctrl_w_g", "ahk_exe i)skylark.exe"


GroupAdd "keep_ctrl_w_g", "ahk_group browser_like_group"

; ctrl + f4 关闭标签 兜底
GroupAdd "keep_f4_g", "ahk_exe i)Code.exe"
GroupAdd "keep_f4_g", "ahk_exe i)devenv.exe"
GroupAdd "keep_f4_g", "ahk_exe i)eclipse.exe"
GroupAdd "keep_f4_g", "ahk_exe i)HBuilderX.exe"
GroupAdd "keep_f4_g", "ahk_exe i)heidisql.exe"

GroupAdd "keep_f4_g", "ahk_exe i)MarkdownPad2.exe"
GroupAdd "keep_f4_g", "ahk_exe javaw.exe ahk_class SWT_Window0"
GroupAdd "keep_f4_g", "ahk_exe i)SecureCRT.exe"
GroupAdd "keep_f4_g", "ahk_exe i)SpringToolSuite4.exe"
GroupAdd "keep_f4_g", "ahk_exe i)SumatraPDF.exe ahk_class SUMATRA_PDF_FRAME"

GroupAdd "keep_f4_g", "ahk_exe i)sublime_text.exe"
GroupAdd "keep_f4_g", "ahk_exe i)uedit64.exe"
GroupAdd "keep_f4_g", "ahk_exe i)WinMergeU.exe"
GroupAdd "keep_f4_g", "ahk_exe i)wps.exe"
GroupAdd "keep_f4_g", "ahk_class SunAwtFrame",,"Apache JMeter" ; netbean 32/64 位 & 标签类软件 jb 全家桶 & fleet

GroupAdd "keep_f4_g", "ahk_group browser_group"

; 使用了 标准的 ctrl + Page 进行切换标签
GroupAdd "keep_ctrl_page_g", "ahk_exe i)Brackets.exe"
GroupAdd "keep_ctrl_page_g", "ahk_exe i)eclipse.exe"
GroupAdd "keep_ctrl_page_g", "ahk_exe i)Fleet.exe ahk_class SunAwtFrame" ; Fleet
GroupAdd "keep_ctrl_page_g", "ahk_exe i)HBuilderX.exe"
GroupAdd "keep_ctrl_page_g", "ahk_exe i)javaw.exe ahk_class SunAwtFrame" ; netbean 32 位 / jmeter

GroupAdd "keep_ctrl_page_g", "ahk_exe i)javaw.exe ahk_class SWT_Window0" ; myeclipse
GroupAdd "keep_ctrl_page_g", "ahk_exe i)netbeans64.exe ahk_class SunAwtFrame" ; netbean 64 位
GroupAdd "keep_ctrl_page_g", "ahk_exe i)SpringToolSuite4.exe"
GroupAdd "keep_ctrl_page_g", "ahk_exe i)SQLyog.exe"

; 使用了 标准的 ctrl + shift + tab 切换上一个标签
GroupAdd "keep_ctrl_shift_tab_g", "ahk_exe i)想天浏览器.exe"
GroupAdd "keep_ctrl_shift_tab_g", "ahk_exe i)Beekeeper Studio.exe"
GroupAdd "keep_ctrl_shift_tab_g", "ahk_exe i)Code.exe"
GroupAdd "keep_ctrl_shift_tab_g", "ahk_exe explorer.exe ahk_class CabinetWClass" ; 资源管理器
GroupAdd "keep_ctrl_shift_tab_g", "ahk_exe i)EverEdit.exe"
GroupAdd "keep_ctrl_shift_tab_g", "ahk_exe i)heidisql.exe"

GroupAdd "keep_ctrl_shift_tab_g", "ahk_exe i)Notepad.exe"
GroupAdd "keep_ctrl_shift_tab_g", "ahk_exe i)Postman.exe"
GroupAdd "keep_ctrl_shift_tab_g", "ahk_exe i)SecureCRT.exe"
GroupAdd "keep_ctrl_shift_tab_g", "ahk_exe i)MarkdownPad2.exe"
GroupAdd "keep_ctrl_shift_tab_g", "ahk_exe i)MarkText.exe"
GroupAdd "keep_ctrl_shift_tab_g", "ahk_exe i)thunderbird.exe"

GroupAdd "keep_ctrl_shift_tab_g", "ahk_exe i)Xftp.exe"
GroupAdd "keep_ctrl_shift_tab_g", "ahk_exe i)Xshell.exe"
GroupAdd "keep_ctrl_shift_tab_g", "ahk_exe i)wps.exe"
GroupAdd "keep_ctrl_shift_tab_g", "ahk_exe i)zoc.exe"
GroupAdd "keep_ctrl_shift_tab_g", "ahk_exe i)devcpp.exe"

GroupAdd "keep_ctrl_shift_tab_g", "ahk_group browser_group"

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
