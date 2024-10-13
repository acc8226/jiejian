GLOBAL EACH_LINE_LEN := 8
GLOBAL DATA_LIST := ParseData("data.csv")

class DataType {
  static text := '文本' ; 用于热字符串替换

  static app := '程序' ; 精确匹配
  static file := '文件' ; 精确匹配
  static web := '网址' ; 精确匹配
  static dl := '下载' ; 精确匹配
  static inner := '内部' ; 精确匹配
  static ext := '外部' ; 精确匹配
  
  static action := '动作' ; 用于 bd + 关键字
  
  static d_alt := '双击Alt' ; 用于热字符串替换
  static d_home := '双击Home' ; 用于热字符串替换
  static d_end := '双击End' ; 用于热字符串替换
  static d_esc := '双击ESC'
}

; 注册热键 和 热字符串
RegMyHotKey
RegMyHotKey() {
  Loop DATA_LIST.Length {
    it := DATA_LIST[A_Index]

    ; 热键：目前仅作用于程序、文本 和 网址跳转。Hotkey 的规则是如果有多个变体符合触发条件, 那么仅触发最早创建的那个
    if StrLen(it.hk) > 0 && StrLen(it.path) > 0
      Hotkey(it.hk, startByHotKey)
    
    ; 热串：目前仅作用于网址跳转
    if (DataType.web = it.type && StrLen(it.hs) > 0) {
        ; 排除在 编辑器中 可跳转网址
        HotIfWinNotactive('ahk_group ' . TEXT_GROUP)
        Hotstring(":C*:" . it.hs, startByHotString)
        ; 要关闭上下文相关性(也就是说, 使后续创建的热键和 热字串在所有窗口中工作), 调用任意 HotIf 或其中一个 HotIfWin 函数, 但省略参数. 例如: HotIf 或 HotIfWinActive
        HotIf
    }
  }
}

; 只供内部调用
ParseData(fileName) {
  ParseDataLine(line) {
    GLOBAL MY_BASH, MY_VSCode, MY_IDEA, MY_NEW_TERMINAL
    GLOBAL MY_DOUBLE_ALT, MY_DOUBLE_HOME, MY_DOUBLE_END, MY_DOUBLE_ESC
  
    split := StrSplit(line, ",")
    ; 跳过不符合条件的行
    if split.Length < EACH_LINE_LEN
      return
    splitEACH_LINE_LEN := Trim(split[EACH_LINE_LEN])
    ; 过滤不启用的行
    if NOT (splitEACH_LINE_LEN = '' || splitEACH_LINE_LEN = 'y')
      return    
    info := {}
    info.type := Trim(split[1])
      
    ; 去掉首尾的双引号，但不知为何只要行内出现 " 则首尾会加入一对 ""，然后里面的每个 " 都会转义为 ""
    ; info.path := Trim(split[2])
    ; if (StrLen(info.path) > 1 && '"' == SubStr(info.path, 1, 1) && '"' == SubStr(info.path, -1))
    ;   info.path := SubStr(info.path, 2, -1)
    info.path := RegExReplace(Trim(split[2]), '"+')      
    ; 过滤空行
    if info.type == '' && info.path == ''
      return
    ; 过滤无效路径
    if (info.type = DataType.file) {
      if NOT FileExist(info.path)
        return
    } else if (info.type  = DataType.app) {
      ; 如果包含竖线则进行分割，并按照从左到右进行匹配
      pathSplit := StrSplit(info.path, "|")
      isPathExist := false
      Loop pathSplit.Length {
        ; 如果能匹配
        item := pathSplit[A_Index]
        ; 过滤空行
        if item == ''
          continue
        ; 如果是以字母开头 并且 不是以 shell: 开头
        if (IsAlpha(SubStr(item, 1, 1)) && 1 !== InStr(item, 'shell:', false)) {   
          if (FileExist(item)) {
            ; 特殊处理 .lnk 则目标必须存在
            if (SubStr(item, -4) == ".lnk") {
              FileGetShortcut(item, &OutTarget)
              if OutTarget && FileExist(OutTarget)
                isPathExist := true
            } else {
              isPathExist := true              
            }
          } else if (NOT InStr(item, ':')) { ; 否则认为是相对路径则继续处理         
            ; 从环境变量 PATH 中获取
            dosPath := EnvGet("PATH")
            isEndsWithExe := '.exe' = SubStr(item, StrLen(item) - 3)  
            loop parse dosPath, "`;" {
              if A_LoopField == ""
                continue
              if (FileExist(A_LoopField . "\" . item)) {
                isPathExist := true
                break
              }
              ; 如果不以 exe 结尾则拼接 exe 继续尝试
              if (!isEndsWithExe && FileExist(A_LoopField . "\" . item . '.exe')) {
                isPathExist := true
                break
              }
            }            
          }
        } else {
          isPathExist := true
        }
        if (isPathExist) {
          info.path := item
          break
        }
      }      
      ; 若文件路径找不到则跳过该条目
      if NOT isPathExist
        return
    } else if (info.type = DataType.web || info.type = DataType.dl) {
      ; 为节约内存。若以 https 开头则默认去掉
      if InStr(info.path, "https://")
        info.path := SubStr(info.path, StrLen("https://") + 1)
    }
    
    ; 热串关键字
    info.hs := Trim(split[7])
    if (info.type = DataType.text) {
      ; text 类型用完即走 不加入 array 中  
      if StrLen(info.hs) > 0          
          Hotstring(":C*:" . info.hs, info.path)
      return
    }
  
    ; 运行名称：可能是息屏、睡眠、关机
    info.title := Trim(split[4])
    if (info.type = DataType.d_alt) {
      MY_DOUBLE_ALT := info.title
      return
    }
    if (info.type = DataType.d_home) {
      MY_DOUBLE_HOME := info.title
      return
    }
    if (info.type = DataType.d_end) {
      MY_DOUBLE_END := info.title
      return
    }
    if (info.type = DataType.d_esc) {
      MY_DOUBLE_ESC := info.title
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
    if (info.type = DataType.app) {
      if (info.title = 'Bash') {
        if (InStr(info.path, '.lnk')) {
          FileGetShortcut(info.path, &OutTarget)
          MY_BASH := OutTarget
        } else {
          MY_BASH := info.path
        }
      } else if (info.title = 'VSCode') {
        if (InStr(info.path, '.lnk')) {
          FileGetShortcut(info.path, &OutTarget)
          MY_VSCode := OutTarget
        } else {
          MY_VSCode := info.path
        }
      } else if (info.title = 'IDEA') {
        if (InStr(info.path, '.lnk')) {
          FileGetShortcut(info.path, &OutTarget)
          MY_IDEA := OutTarget
        } else {
          MY_IDEA := info.path
        }
      } else if (info.title = '新终端') {
        if (InStr(info.path, '.lnk')) {
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
  ; 每次从字符串中检索字符串(片段)
  Loop Parse, FileRead(fileName), "`n", "`r" {
      ; 跳过首行
      if A_Index = 1
          continue
      appInfo := ParseDataLine(A_LoopField)
      if appInfo
          dataList.Push(appInfo)
  }
  return dataList  
}
