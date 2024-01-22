; 窗口组可以用来使热键为一组窗口执行

; 标签类：浏览器大类 使用了 标准的 ctrl + t 新建标签 ctrl + f4 关闭标签 ctrl + tab 进行翻页
; 测试通过过的浏览器：360极速浏览器、Chrome 谷歌浏览器、DuckDuckGo 浏览器、Firefox 火狐系浏览器
; 理论上兼容的浏览器（未经过完全测试）：360 安全浏览器、QQ 浏览器、傲游浏览器、猎豹浏览器、极速浏览器
; 目前已知对搜狗浏览器极度不兼容

global dataList := parseData("data.csv")

; 注册热键 和 热字符串
Loop dataList.Length {
  it := dataList[A_Index]
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

parseData(filename) {
  dataList := []
  ; 每次从字符串中检索字符串(片段)
  Loop Parse, FileRead(filename, "UTF-8"), "`n", "`r" {
      ; 跳过首行
      if A_Index = 1
          continue

      appInfo := parseAppLine(A_LoopField)    
      if appInfo
          dataList.Push(appInfo)
  }
  return dataList  
}

parseAppLine(line) {  
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

openUrl(hs) {
  Run webFindPathByHs(dataList, StrReplace(hs, ":C*:"))
}
