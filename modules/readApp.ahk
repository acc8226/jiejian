global appList := parseApp('app.csv')

; 注册热键 和 热字符串
Loop appList.Length {
  if A_Index <= 1
    continue

  it := appList[A_Index]
  if it.highLevel {
    ; 高优先级
    ; e 列
    switch it.escape, 'Off' {
      case "WinClose": GroupAdd "HL_esc_WinClose", it.exe      
    }
    ; f 列
    switch it.close, 'Off' {
      case 'Esc', "{Esc}": GroupAdd "HL_close_Esc", it.exe
      case '!F4', "!{F4}": GroupAdd "HL_close_alt_F4", it.exe
      case '^F4', "^{F4}": GroupAdd "HL_close_ctrl_F4", it.exe        
    }
  } else {
    ; 低优先级
    ; d 列 新建
    switch it.new, 'Off' {
      case "F3", "{F3}": GroupAdd "new_F3", it.exe
      case 'F8', "{F8}": GroupAdd "new_F8", it.exe
      case "!a": GroupAdd "new_alt_a", it.exe
      case "!c": GroupAdd "new_alt_c", it.exe
      case "!n": GroupAdd "new_alt_n", it.exe

      case "!o": GroupAdd "new_alt_o", it.exe
      case "^n": GroupAdd "new_ctrl_n", it.exe
      case "{Control Down}n{Control Up}": GroupAdd "new_ctrl_n_2", it.exe
      case "^o": GroupAdd "new_ctrl_o", it.exe
      case "^t": GroupAdd "new_ctrl_t", it.exe

      case "^!t": GroupAdd "new_ctrl_alt_t", it.exe
      case "^+t": GroupAdd "new_ctrl_shift_t", it.exe
      case "^+n": GroupAdd "new_ctrl_shift_n", it.exe
    }
    ; e 列
    switch it.escape, 'Off' {
      case "WinClose": GroupAdd "esc_WinClose", it.exe
    }
    ; f 列
    switch it.close, 'Off' {
      case "]": GroupAdd "close_closeBracket", it.exe
      case "Esc", "{Esc}": GroupAdd "close_Esc", it.exe
      case '!F4', "!{F4}": GroupAdd "close_alt_F4", it.exe
      case "{Alt Down}{F4 Down}{F4 Up}{Alt Up}": GroupAdd "close_alt_F4_2", it.exe
      case "!l": GroupAdd "close_alt_l", it.exe

      case "!q": GroupAdd "close_alt_q", it.exe
      case "!w": GroupAdd "close_alt_w", it.exe
      case "^w": GroupAdd "close_ctrl_w", it.exe
      case "^!q": GroupAdd "close_ctrl_alt_q", it.exe
      case "^+w": GroupAdd "close_ctrl_shift_w", it.exe
      
      case "^F4", "^{F4}": GroupAdd "close_ctrl_F4", it.exe
    }
    ; g 列 前进
    switch it.forward, 'Off' {
      case "Media_Next", "{Media_Next}": GroupAdd "forward_mediaNext", it.exe
      case "^Right", "^{Right}": GroupAdd "forward_ctrl_Right", it.exe
      case "PgDn", "{PgDn}": GroupAdd "forward_PgDn", it.exe
      case "Right", "{Right}": GroupAdd "forward_Right", it.exe
    }
    ; h 列 下个标签
    switch it.nextTag, 'Off' {
      case "{Media_Next}": GroupAdd "next_mediaNext", it.exe
      case "]": GroupAdd "next_closeBracket", it.exe
      case "n": GroupAdd "next_n", it.exe
      case "Down", "{Down}": GroupAdd "next_Down", it.exe
      case "^PgDn": GroupAdd "next_ctrl_shift_PgDn", it.exe

      case "!]": GroupAdd "next_alt_closeBracket", it.exe
      case "!{Right}": GroupAdd "next_alt_Right", it.exe
      case "^PgDn": GroupAdd "next_ctrl_PgDn", it.exe
      case "^!{Right}": GroupAdd "next_ctrl_alt_Right", it.exe
      case "{PgDn}": GroupAdd "next_PgDn", it.exe
    }
    ; I 列 后退
    switch it.back, 'Off' {
      case "{Media_Prev}": GroupAdd "back_Media_Prev", it.exe
      case "PgUp", "{PgUp}": GroupAdd "back_PgUp", it.exe
      case "Left", "{Left}": GroupAdd "back_Left", it.exe
      case 'Up', "{Up}": GroupAdd "back_Up", it.exe
    }
    ; J 列 上个标签
    switch it.previousTag, 'Off' {
      case "p": GroupAdd "previous_p", it.exe
      case "[": GroupAdd "previous_openBracket", it.exe
      case "Media_Prev", "{Media_Prev}": GroupAdd "previous_mediaPrev", it.exe
      case 'Up', "{Up}": GroupAdd "previous_Up", it.exe
      case "PgUp", "{PgUp}": GroupAdd "previous_PgUp", it.exe

      case "!0": GroupAdd "previous_alt_0", it.exe
      case "!Left", "!{Left}": GroupAdd "previous_alt_Left", it.exe
      case "![": GroupAdd "previous_alt_openBracket", it.exe
      case "^Left", "^{Left}": GroupAdd "previous_ctrl_Left", it.exe
      case "^PgUp", "^{PgUp}": GroupAdd "previous_ctrl_PgUp", it.exe

      case "^!Left", "^!{Left}": GroupAdd "previous_ctrl_alt_Left", it.exe
      case "Media_Play_Pause", "{Media_Play_Pause}": GroupAdd "previous_mediaPlayPause", it.exe
      case 'Space', "{Space}": GroupAdd "previous_space", it.exe
    }
    ; k 列 全屏
    switch it.fs, 'Off' {
      case "^+F12", "^+{F12}": GroupAdd "fullscreen_c_s_f12", it.exe
      case "回车": GroupAdd "fullscreen_enter", it.exe
      case "f": GroupAdd "fullscreen_f", it.exe
    }    
  }
}

parseApp(fileName) {
  appList := []
  ; 每次从字符串中检索字符串(片段)
  Loop Parse, FileRead(fileName), "`n", "`r" {
      ; 跳过首行
      if A_Index >= 2 {
        appInfo := parseDataLine(A_LoopField)
        if appInfo
            appList.Push(appInfo)
      }
  }
  return appList  
}

parseDataLine(line) {
  split := StrSplit(line, ",")
  ; 跳过不符合条件的行
  if split.Length < 11
    return 
  info := {}
  ; 跳过 exe 为空的行
  info.exe := Trim(split[3])
  if info.exe = ''
    return
  ; 判断是否是高等级
  info.highLevel := split[2] = "高"

  info.new := Trim(split[4])
  info.escape := Trim(split[5])
  info.close := Trim(split[6])

  info.forward := Trim(split[7])
  info.nextTag := Trim(split[8])
  info.back := Trim(split[9])
  info.previousTag := Trim(split[10])  
  info.fs := Trim(split[11])

  ; 过滤空行
  if (info.new = ''
    and info.escape = ''
    and info.close = ''

    and info.forward = ''
    and info.nextTag = ''
    and info.back = ''
    and info.previousTag = ''
    and info.fs = ''
    ) {
      return
    }

    name := Trim(split[1])
    if name !== '' and info.exe !== '' {
      if InStr(name, "【浏览器】")
        GroupAdd "browser_group", info.exe
      else if InStr(name, "【editor】")
        GroupAdd "editor_group", info.exe
      else if InStr(name, "【IDE】")
        GroupAdd "IDE_group", info.exe
    }
  return info
}

; 闭包的使用
app_hotkey2(app_title) {
    isActivate()  ; 这是 app_title 和 app_path 的闭包.
    {
      return WinActive(app_title)
    }
    return isActivate
}

; 高等级
; e. 逃逸
#HotIf WinActive("ahk_group HL_esc_WinClose")
Esc::WinClose

; f. 关闭 打头
#HotIf WinActive("ahk_group HL_close_Esc")
^F4::
XButton1::Send "{Esc}"
#HotIf WinActive("ahk_group HL_close_alt_F4")
^F4::
XButton1::Send "!{F4}"
#HotIf WinActive("ahk_group HL_close_ctrl_F4")
^F4::
XButton1::Send "^{F4}"

; 低等级
; d. 新建
#HotIf WinActive("ahk_group new_F3")
^F8::Send "{F3}"
#HotIf WinActive("ahk_group new_F8")
^F8::Send "{F8}"
#HotIf WinActive("ahk_group new_alt_a")
^F8::Send "!a"
#HotIf WinActive("ahk_group new_alt_c")
^F8::Send "!c"
#HotIf WinActive("ahk_group new_alt_n")
^F8::Send "!n"

#HotIf WinActive("ahk_group new_alt_o")
^F8::Send "!o"
#HotIf WinActive("ahk_group new_ctrl_n")
^F8::Send "^n"
#HotIf WinActive("ahk_group new_ctrl_n_2")
^F8::Send "{Control Down}n{Control Up}"
#HotIf WinActive("ahk_group new_ctrl_o")
^F8::Send "^o"
#HotIf WinActive("ahk_group new_ctrl_t")
^F8::Send "^t"

#HotIf WinActive("ahk_group new_ctrl_alt_t")
^F8::Send "^!t"
#HotIf WinActive("ahk_group new_ctrl_shift_t")
^F8::Send "^+t"
#HotIf WinActive("ahk_group new_ctrl_shift_n")
^F8::Send "^+n"

; e. 逃逸
#HotIf WinActive("ahk_group esc_WinClose")
Esc::WinClose

; f. 关闭 打头
#HotIf WinActive("ahk_group close_closeBracket")
^F4::
XButton1::Send "]"
#HotIf WinActive("ahk_group close_Esc")
^F4::
XButton1::Send "{Esc}"
#HotIf WinActive("ahk_group close_alt_F4")
^F4::
XButton1::Send "!{F4}"
#HotIf WinActive("ahk_group close_alt_F4_2")
^F4::
XButton1::Send "{Alt Down}{F4 Down}{F4 Up}{Alt Up}"
#HotIf WinActive("ahk_group close_alt_l")
^F4::
XButton1::Send "!l"

#HotIf WinActive("ahk_group close_alt_q")
^F4::
XButton1::Send "!q"
#HotIf WinActive("ahk_group close_alt_w")
^F4::
XButton1::Send "!w"
#HotIf WinActive("ahk_group close_ctrl_w")
^F4::
XButton1::Send "^w"
#HotIf WinActive("ahk_group close_ctrl_alt_q")
^F4::
XButton1::Send "^!q"
#HotIf WinActive("ahk_group close_ctrl_shift_w")
^F4::
XButton1::Send "^+w"

; 兜底1
#HotIf not WinActive("ahk_group close_ctrl_F4")
^F4::SmartCloseWindow ; 比 WinClose "A" 好使
#HotIf WinActive("ahk_group close_ctrl_F4")
XButton1::Send "^{F4}"
; 兜底2
#HotIf
XButton1::SmartCloseWindow ; 比 WinClose "A" 好使

; g. 前进键
#HotIf WinActive("ahk_group forward_mediaNext")
!Right::Send "{Media_Next}" ; 下一曲
#HotIf WinActive("ahk_group forward_ctrl_Right")
!Right::Send "^{Right}"
#HotIf WinActive("ahk_group forward_PgDn")
!Right::Send "{PgDn}"
#HotIf WinActive("ahk_group forward_Right")
!Right::Send "{Right}"

; h. 下个标签
#HotIf WinActive("ahk_group next_mediaNext")
^Tab::Send "{Media_Next}" ; 下一曲
#HotIf WinActive("ahk_group next_closeBracket")
^Tab::Send "]"
#HotIf WinActive("ahk_group next_n")
^Tab::Send "n"
#HotIf WinActive("ahk_group next_Down")
^Tab::Send "{Down}"
#HotIf WinActive("ahk_group next_ctrl_shift_PgDn")
^Tab::Send "^+{PgDn}"
#HotIf WinActive("ahk_group next_alt_closeBracket")
^Tab::Send "!]"
#HotIf WinActive("ahk_group next_alt_Right")
^Tab::Send "!{Right}"
#HotIf WinActive("ahk_group next_ctrl_PgDn")
^Tab::Send "^{PgDn}"
#HotIf WinActive("ahk_group next_ctrl_alt_Right")
^Tab::Send "^!{Right}"
#HotIf WinActive("ahk_group next_PgDn")
^Tab::Send "{PgDn}"

; I. 后退
#HotIf WinActive("ahk_group back_Media_Prev")
!Left::Send "{Media_Prev}" ; 上一曲
#HotIf WinActive("ahk_group back_PgUp")
!Left::Send "{PgUp}"
#HotIf WinActive("ahk_group back_Left")
!Left::Send "{Left}"
#HotIf WinActive("ahk_group back_Up")
!Left::Send "{Up}"

; j 列：上个标签
#HotIf WinActive("ahk_group previous_p")
^+Tab::
XButton2::Send "p"
#HotIf WinActive("ahk_group previous_openBracket")
^+Tab::
XButton2::Send "[" ; 对 bilibili 不好用，由于会触发 ctrl + shift 切换输入法我就醉了
#HotIf WinActive("ahk_group previous_mediaPrev")
^+Tab::
XButton2::Send "{Media_Prev}"
#HotIf WinActive("ahk_group previous_Up")
^+Tab::
XButton2::Send "{Up}"
#HotIf WinActive("ahk_group previous_PgUp")
^+Tab::
XButton2::Send "{PgUp}"

#HotIf WinActive("ahk_group previous_alt_0")
^+Tab::
XButton2::Send "!0"
#HotIf WinActive("ahk_group previous_alt_Left")
^+Tab::
XButton2::Send "!{Left}"
#HotIf WinActive("ahk_group previous_alt_openBracket")
^+Tab::
XButton2::Send "!["
#HotIf WinActive("ahk_group previous_ctrl_Left")
^+Tab::
XButton2::Send "^{Left}"
#HotIf WinActive("ahk_group previous_ctrl_PgUp")
^+Tab::
XButton2::Send "^{PgUp}"

#HotIf WinActive("ahk_group previous_ctrl_alt_Left")
^+Tab::
XButton2::Send "^!{Left}"
#HotIf WinActive("ahk_group previous_mediaPlayPause")
^+Tab::
XButton2::Send "{Media_Play_Pause}"
#HotIf WinActive("ahk_group previous_space")
^+Tab::
XButton2::Send "{Space}"

; 兜底
#HotIf
XButton2::Send "^+{Tab}"

; k 列：F11 功能键增强 全屏
; 如果是浏览器 且 打开的是 bilibili 则将 f11 转成按键 f
#HotIf WinActive("哔哩哔哩_bilibili ahk_group browser_group")
F11::Send "f"

#HotIf WinActive("ahk_group fullscreen_c_s_f12")
F11::Send "^+{F12}"
#HotIf WinActive("ahk_group fullscreen_enter")
F11::Send "Enter"
#HotIf WinActive("ahk_group fullscreen_f")
F11::Send "f"
#HotIf

; ctrl + F7 通用操作：置顶/取消置顶
^F7::ToggleWindowTopMost
