global DATA_LIST := parseData("data.csv")

class DataType {
  static app := '程序'
  static file := '文件'
  static text := '文本'
  static web := '网址'
  static search := '搜索'
  static inner := '内部'
  static ext := '外部'
  static dl := '下载'
}

; 注册热键 和 热字符串
regMyHotKey()
regMyHotKey() {
  Loop DATA_LIST.Length {
    it := DATA_LIST[A_Index]

    ; 热键：：目前仅作用于程序、文本 和 网址跳转
    if (StrLen(it.hk) > 0 && StrLen(it.path) > 0) {
      ; 如果有多个变体符合触发条件, 那么仅触发最早创建的那个
      Hotkey(it.hk, startByHotKey)
    }

    ; 热串：目前仅作用于网址跳转
    if (StrLen(it.hs) > 0 && it.type = DataType.web) {
        ; 排除在 编辑器中 可跳转网址
        HotIfWinNotactive('ahk_group ' . TEXT_GROUP)
        Hotstring(":C*:" . it.hs, startByHotString)
        ; 要关闭上下文相关性(也就是说, 使后续创建的热键和 热字串在所有窗口中工作), 调用任意 HotIf 或其中一个 HotIfWin 函数, 但省略参数. 例如: HotIf 或 HotIfWinActive
        HotIf
    }
  }
}

parseData(fileName) {
  parseDataLine(line, eachLineLen) {
    global MY_BASH, MY_VSCode, MY_IDEA, MY_NEW_TERMINAL
    global MY_DOUBLE_ALT, MY_DOUBLE_HOME, MY_DOUBLE_END
  
    split := StrSplit(line, ",")
    ; 跳过不符合条件的行
    if split.Length < eachLineLen
      return
    splitEachLineLen := Trim(split[eachLineLen])
    ; 过滤不启用的行
    if NOT (splitEachLineLen = '' || splitEachLineLen = 'y')
      return
    
    info := {}
    info.type := Trim(split[1])
  
    ; 去掉首尾的双引号，但不知为何首尾的一对双引号会转义为三对
    info.path := Trim(split[2])
    if (StrLen(info.path) > 1 && '"""' == SubStr(info.path, 1, 3) && '"""' == SubStr(info.path, -3))
      info.path := SubStr(info.path, 4, -3)
  
    ; 过滤空行
    if (info.type == '' && info.path == '')
      return
    ; 过滤无效路径
    if (info.type = DataType.file) {
      if NOT FileExist(info.path)
        return
    } else if (info.type  = DataType.app) {
      ; 如果是以字母开头 and 不是 shell: 开头
      if IsAlpha(SubStr(info.path, 1, 1)) && 1 !== InStr(info.path, 'shell:', False) {
        ; 如果是绝对路径
        if InStr(info.path, ':') {
          if NOT FileExist(info.path)
            return
        } else {
          ; 如果是相对路径
          if NOT FileExist(info.path) {
              exeExist := false           
              ; 从环境变量 PATH 中获取
              DosPath := EnvGet("PATH")
              isEndsWithExe := '.exe' = SubStr(info.path, StrLen(info.path) - 3)  
              loop parse DosPath, "`;" {
                if A_LoopField == ""
                  continue
                if FileExist(A_LoopField "\" info.path) {
                  exeExist := true
                  break
                }
                ; 如果不以 exe 结尾则拼接 exe 继续尝试
                if NOT isEndsWithExe && FileExist(A_LoopField "\" info.path . '.exe') {
                  exeExist := true
                  break
                }
              }
              if (!exeExist)
                return
          }
        }
      }
    } else if (info.type = DataType.web || info.type = DataType.dl) {
      ; 为节约内存。如果 https 开头则默认去掉
      if InStr(info.path, "https://")
        info.path := SubStr(info.path, StrLen("https://") + 1)
    }
    
    ; 热串关键字
    info.hs := Trim(split[7])
    if info.type = DataType.text {
      ; text 类型用完即走 不加入 array 中
      if (StrLen(info.hs) > 0)
          Hotstring ":C*:" . info.hs, info.path
      return
    }
  
    ; 运行名称
    info.title := Trim(split[4])
    if info.type = '双击Alt' {
      MY_DOUBLE_ALT := info.title
      return
    }
    if info.type = '双击Home' {
      MY_DOUBLE_HOME := info.title
      return
    }
    if info.type = '双击End' {
      MY_DOUBLE_END := info.title
      return
    }
  
    ; 要激活的窗口
    info.winTitle := Trim(split[3])
    ; 运行关键字
    split4 := Trim(split[5])
  
    aliases := StrSplit(split4, "|")
    ; 如果数组长度 > 1 则存成数组
    info.alias := (aliases.Length > 1) ? aliases : split4
    ; 热键关键字
    info.hk := Trim(split[6])
  
    ; 设置 bash 全局变量，如果存在的话，最终会供给启动器使用
    if info.type = DataType.app {
      if info.title = 'Bash' {
        if InStr(info.path, '.lnk') {
          FileGetShortcut(info.path, &OutTarget)
          MY_BASH := OutTarget
        } else {
          MY_BASH := info.path
        }
      } else if info.title = 'VSCode' {
        if InStr(info.path, '.lnk') {
          FileGetShortcut(info.path, &OutTarget)
          MY_VSCode := OutTarget
        } else {
          MY_VSCode := info.path
        }
      } else if info.title = 'IDEA' {
        if InStr(info.path, '.lnk') {
          FileGetShortcut(info.path, &OutTarget)
          MY_IDEA := OutTarget
        } else {
          MY_IDEA := info.path
        }
      } else if info.title = '新终端' {
        if InStr(info.path, '.lnk') {
          FileGetShortcut(info.path, &OutTarget)
          MY_NEW_TERMINAL := OutTarget
        } else {
          MY_NEW_TERMINAL := info.path
        }
      }
    }
    return info
  } 

  dataList := []
  eachLineLen := 8
  ; 每次从字符串中检索字符串(片段)
  Loop Parse, FileRead(fileName), "`n", "`r" {
      ; 跳过首行
      if (A_Index = 1)
          continue
      appInfo := parseDataLine(A_LoopField, eachLineLen)
      if (appInfo)
          dataList.Push(appInfo)
  }
  return dataList  
}
