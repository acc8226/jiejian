global dataList := parseData("data.csv")

; 注册热键 和 热字符串
Loop dataList.Length {
  it := dataList[A_Index]
  ; 热键
  if (StrLen(it.hk) > 0 AND StrLen(it.path) > 0)
      Hotkey it.hk, startByHotKey
  ; 热串
  if (StrLen(it.hs) > 0) {
      if (it.type = "web") {
          ; 排除在 编辑器中 可跳转网址
          HotIfWinNotactive 'ahk_group ' . Text_Group
          Hotstring ":C*:" . it.hs, startByHotString
          HotIfWinNotactive
      } else if (it.type = "text")
          Hotstring ":C*:" . it.hs, it.path
  }
}

parseData(filename) {
  dataList := []
  eachLineLen := 8
  ; 每次从字符串中检索字符串(片段)
  Loop Parse, FileRead(filename), "`n", "`r" {
      ; 跳过首行
      if (A_Index = 1)
          continue

      appInfo := parseDataLine(A_LoopField, eachLineLen)
      if (appInfo)
          dataList.Push(appInfo)
  }
  return dataList  
}

parseDataLine(line, eachLineLen) {  
  split := StrSplit(line, ",")
  ; 跳过不符合条件的行
  if split.Length < eachLineLen
    return
  splitEachLineLen := Trim(split[eachLineLen])
  ; 过滤不启用的行
  if NOT (splitEachLineLen = '' OR splitEachLineLen = 'y')
    return
  
  info := {}
  info.type := Trim(split[1])

  ; 去掉首尾的双引号，但不知为何首尾的一对双引号会转义为三对
  info.path := Trim(split[2])
  if (StrLen(info.path) > 1 AND '"""' == SubStr(info.path, 1, 3) AND '"""' == SubStr(info.path, -3))
    info.path := SubStr(info.path, 4, -3)

  ; 过滤空行
  if (info.type == '' AND info.path == '') {
    return
  }
  ; 过滤无效路径
  if ((info.type == 'app' OR info.type == 'file') AND !FileExist(info.path)) {
    return
  }
  
  ; 要激活的窗口
  info.winTitle := Trim(split[3])
  ; 运行名称
  info.title := Trim(split[4])
  ; 运行关键字
  split4 := Trim(split[5])
  aliases := StrSplit(split4, "|")
  ; 如果数组长度 > 1 则存成数组
  info.alias := (aliases.Length > 1) ? aliases : split4
  ; 热键关键字
  info.hk := Trim(split[6])
  ; 热串关键字
  info.hs := Trim(split[7])

  return info
}
