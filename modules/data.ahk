; 窗口组可以用来使热键为一组窗口执行

; 标签类：浏览器大类
; 测试通过过的浏览器：360极速浏览器、Chrome 谷歌浏览器、DuckDuckGo 浏览器、Firefox 火狐系浏览器
; 理论上兼容的浏览器（未经过完全测试）：360 安全浏览器、QQ 浏览器、傲游浏览器、猎豹浏览器、极速浏览器
GroupAdd "browser_group", "ahk_exe 360ChromeX.exe" ; 360 极速浏览器
GroupAdd "browser_group", "ahk_exe 360se.exe" ; 360 安全浏览器
GroupAdd "browser_group", "ahk_exe chrome.exe" ; 谷歌浏览器
GroupAdd "browser_group", "ahk_exe DuckDuckGo.exe" ; Duck 浏览器
GroupAdd "browser_group", "ahk_exe firefox.exe" ; 火狐安全浏览器

GroupAdd "browser_group", "ahk_exe liebao.exe" ; 猎豹浏览器
GroupAdd "browser_group", "ahk_exe msedge.exe" ; edge 浏览器
GroupAdd "browser_group", "ahk_exe Maxthon.exe" ; 傲游浏览器
GroupAdd "browser_group", "ahk_exe QQBrowser.exe" ; QQ 浏览器
GroupAdd "browser_group", "ahk_exe TSBrowser.exe" ; 极速浏览器
GroupAdd "browser_group", "ahk_exe SLBrowser.exe" ; 联想浏览器
GroupAdd "browser_group", "ahk_exe SogouExplorer.exe" ; 搜狗浏览器

; 标签类：类浏览器
GroupAdd "browser_like", "ahk_exe notepad.exe" ; 完美适配 win11 新版 记事本
GroupAdd "browser_like", "ahk_exe Postman.exe"
GroupAdd "browser_like", "ahk_exe Beekeeper Studio.exe"

; 文本类
GroupAdd "text_group", "ahk_exe notepad.exe" ; 记事本
GroupAdd "text_group", "ahk_exe Code.exe" ; vscode

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
  info := {}
  
  split := StrSplit(line, ",")
  if (split.Length != 6) 
    return 
  
  info.type := Trim(split[1])

  ; 去掉首尾的双引号，但不知为何首尾的一对双引号会转义为三对
  info.path := Trim(split[2])
  if StrLen(info.path) > 1 and '"""' == SubStr(info.path, 1, 3) and '"""' == SubStr(info.path, -3) {
    info.path := SubStr(info.path, 4, -3)
  }

  info.title := Trim(split[3])
  
  aliases := StrSplit(Trim(split[4]), "|")
  ; 如果数组长度 > 1 则存成数组
  info.alias := (aliases.Length > 1) ? aliases : Trim(split[4])

  info.hk := Trim(split[5])
  info.hs := Trim(split[6])

  return info
}
