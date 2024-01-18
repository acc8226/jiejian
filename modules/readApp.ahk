global appList := parseApp()

; 注册热键 和 热字符串
Loop appList.Length {
  if A_Index <= 1
    continue

  it := appList[A_Index]
  if it.highLevel {
    ; 高优先级
    ; 2. 逃逸
    if it.escape = "WinClose"
      GroupAdd "HL_esc_WinClose", it.exe

    ; 3. 关闭
    if it.close = "{Esc}"
      GroupAdd "HL_close_Esc", it.exe
    else if it.close = "!{F4}"
      GroupAdd "HL_close_alt_f4", it.exe

    ; 4. 侧边后退键
    if it.sideBack = "{Esc}"
      GroupAdd "HL_sideBack_Esc", it.exe
    else if it.sideBack = "!{F4}"
      GroupAdd "HL_sideBack_alt_f4", it.exe
  } else {
    ; 低优先级
    ; 1. 新建
    if it.new = "{F3}"
      GroupAdd "new_F3", it.exe
    else if it.new = "{F8}"
      GroupAdd "new_F8", it.exe
    else if it.new = "!a"
      GroupAdd "new_alt_a", it.exe
    else if it.new = "!c"
      GroupAdd "new_alt_c", it.exe
    else if it.new = "!n"
      GroupAdd "new_alt_n", it.exe
    else if it.new = "!o"
      GroupAdd "new_alt_o", it.exe
    else if it.new = "^n"
      GroupAdd "new_ctrl_n", it.exe
    else if it.new = "{Control Down}n{Control Up}"
      GroupAdd "new_ctrl_n_2", it.exe
    else if it.new = "^o"
      GroupAdd "new_ctrl_o", it.exe
    else if it.new = "^t"
      GroupAdd "new_ctrl_t", it.exe
    else if it.new = "^!t"
      GroupAdd "new_ctrl_alt_t", it.exe
    else if it.new = "^+t"
      GroupAdd "new_ctrl_shift_t", it.exe
    else if it.new = "^+n"
      GroupAdd "new_ctrl_shift_n", it.exe

    ; 2. 逃逸
    if it.escape = "WinClose"
      GroupAdd "esc_WinClose", it.exe

    ; 3. 关闭
    if it.close = "{Esc}"
      GroupAdd "close_Esc", it.exe
    else if it.close = "!{F4}"
      GroupAdd "close_alt_f4", it.exe
    else if it.close = "{Alt Down}{F4 Down}{F4 Up}{Alt Up}"
      GroupAdd "close_alt_f4_2", it.exe
    else if it.close = "!l"
      GroupAdd "close_alt_l", it.exe
    else if it.close = "!q"
      GroupAdd "close_alt_q", it.exe
    else if it.close = "!w"
      GroupAdd "close_alt_w", it.exe
    else if it.close = "^{F4}"
      GroupAdd "close_ctrl_f4", it.exe
    else if it.close = "^w"
      GroupAdd "close_ctrl_w", it.exe
    else if it.close = "^!q"
      GroupAdd "close_ctrl_alt_q", it.exe
    else if it.close = "^+w"
      GroupAdd "close_ctrl_shift_w", it.exe

    ; 4. 侧边后退键
    if it.sideBack = "{Esc}"
      GroupAdd "sideBack_Esc", it.exe
    else if it.sideBack = "]"
      GroupAdd "sideBack_closeBracket", it.exe
    else if it.sideBack = "!{F4}"
      GroupAdd "sideBack_alt_f4", it.exe
    else if it.sideBack = "{Alt Down}{F4 Down}{F4 Up}{Alt Up}"
      GroupAdd "sideBack_alt_f4_2", it.exe
    else if it.sideBack = "!l"
      GroupAdd "sideBack_alt_l", it.exe
    else if it.sideBack = "!q"
      GroupAdd "sideBack_alt_q", it.exe
    else if it.sideBack = "!w"
      GroupAdd "sideBack_alt_w", it.exe
    else if it.sideBack = "^{F4}"
      GroupAdd "sideBack_ctrl_f4", it.exe
    else if it.sideBack = "^w"
      GroupAdd "sideBack_ctrl_w", it.exe
    else if it.close = "^!q"
      GroupAdd "sideBack_ctrl_alt_q", it.exe
    else if it.sideBack = "^+w"
      GroupAdd "sideBack_ctrl_shift_w", it.exe

    ; 5. 前进
    if it.forward = "{Media_Next}"
      GroupAdd "forward_mediaNext", it.exe
    else if it.forward = "^{Right}"
      GroupAdd "forward_ctrl_right", it.exe
    else if it.forward = "{PgDn}"
      GroupAdd "forward_PgDn", it.exe
    else if it.forward = "{Right}"
      GroupAdd "forward_Right", it.exe

    ; 6. 下个标签
    if it.nextTag = "{Media_Next}"
      GroupAdd "next_mediaNext", it.exe
    else if it.nextTag = "]"
      GroupAdd "next_closeBracket", it.exe
    else if it.nextTag = "n"
      GroupAdd "next_n", it.exe
    else if it.nextTag = "{Down}"
      GroupAdd "next_Down", it.exe
    else if it.nextTag = "^+{PgDn}"
      GroupAdd "next_ctrl_shift_pgDn", it.exe
    else if it.nextTag = "!]"
      GroupAdd "next_alt_closeBracket", it.exe
    else if it.nextTag = "!{Right}"
      GroupAdd "next_alt_right", it.exe
    else if it.nextTag = "^{PgDn}"
      GroupAdd "next_ctrl_pgDn", it.exe
    else if it.nextTag = "^!{Right}"
      GroupAdd "next_ctrl_alt_right", it.exe
    else if it.nextTag = "{PgDn}"
      GroupAdd "next_pgDn", it.exe

    ; 7. 后退
    if it.back = "{Media_Prev}"
      GroupAdd "back_Media_Prev", it.exe
    else if it.back = "{PgUp}"
      GroupAdd "back_PgUp", it.exe
    else if it.back = "{Left}"
      GroupAdd "back_Left", it.exe
    else if it.back = "{Up}"
      GroupAdd "back_Up", it.exe
    ; 8. 上个标签
    if it.previousTag = "{Media_Prev}"
      GroupAdd "previous_mediaPrev", it.exe
    else if it.previousTag = "["
      GroupAdd "previous_openBracket", it.exe
    else if it.previousTag = "p"
      GroupAdd "previous_p", it.exe
    else if it.previousTag = "{Up}"
      GroupAdd "previous_Up", it.exe
    else if it.previousTag = "!0"
      GroupAdd "previous_alt_0", it.exe
    else if it.previousTag = "!{Left}"
      GroupAdd "previous_alt_left", it.exe
    else if it.previousTag = "!["
      GroupAdd "previous_alt_openBracket", it.exe
    else if it.previousTag = "^{Left}"
      GroupAdd "previous_ctrl_left", it.exe
    else if it.previousTag = "^!{Left}"
      GroupAdd "previous_ctrl_alt_left", it.exe
    else if it.previousTag = "^{PgUp}"
      GroupAdd "previous_ctrl_PgUp", it.exe
    else if it.previousTag = "{PgUp}"
      GroupAdd "previous_PgUp", it.exe

    ; 9. 侧边前进键
    if it.sideForward = "{Media_Prev}"
      GroupAdd "sideForward_mediaPrev", it.exe
    else if it.sideForward = "{Media_Play_Pause}"
      GroupAdd "sideForward_mediaPlayPause", it.exe
    else if it.sideForward = "{Space}"
      GroupAdd "sideForward_space", it.exe
    else if it.sideForward = "["
      GroupAdd "sideForward_openBracket", it.exe
    else if it.sideForward = "p"
      GroupAdd "sideForward_p", it.exe
    else if it.sideForward = "{Up}"
      GroupAdd "sideForward_Up", it.exe
    else if it.sideForward = "{PgUp}"
      GroupAdd "sideForward_PgUp", it.exe
    else if it.sideForward = "!{Left}"
      GroupAdd "sideForward_alt_left", it.exe
    else if it.sideForward = "!0"
      GroupAdd "sideForward_alt_0", it.exe
    else if it.sideForward = "!["
      GroupAdd "sideForward_alt_openBracket", it.exe
    else if it.sideForward = "^{Left}"
      GroupAdd "sideForward_ctrl_left", it.exe
    else if it.sideForward = "^{PgUp}"
      GroupAdd "sideForward_ctrl_PgUp", it.exe
    else if it.sideForward = "^!{Left}"
      GroupAdd "sideForward_ctrl_alt_left", it.exe
  }  
}

parseApp() {
  appList := []
  ; 每次从字符串中检索字符串(片段)
  Loop Parse, FileRead("app.csv", "UTF-8"), "`n", "`r" {
      ; 跳过首行
      if A_Index < 2
        continue
      else {
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
  if split.Length < 12
    return 
  info := {}
  ; 跳过 exe 未填写的行
  info.exe := Trim(split[3])
  if info.exe = ''
    return
  ; 判断是否是高等级
  info.highLevel := split[2] = "高"
  info.new := Trim(split[4])
  info.escape := Trim(split[5])
  info.close := Trim(split[6])

  info.sideBack := Trim(split[7])
  info.forward := Trim(split[8])
  info.nextTag := Trim(split[9])
  info.back := Trim(split[10])
  info.previousTag := Trim(split[11])
  info.sideForward := Trim(split[12])

  ; 过滤空行
  if (info.new = ''
    and info.escape = ''
    and info.close = ''
    and info.sideBack = ''
    and info.forward = ''
    and info.nextTag = ''
    and info.back = ''
    and info.previousTag = ''
    and info.sideForward = ''
    )  
    return  
  return info
}

; 闭包的使用
app_hotkey2(app_title)
{
    isActivate()  ; 这是 app_title 和 app_path 的闭包.
    {
      return WinActive(app_title)
    }
    return isActivate
}

; 高等级
; 2. 逃逸
#HotIf WinActive("ahk_group HL_esc_WinClose")
Esc::WinClose

; 3. 关闭 打头
#HotIf WinActive("ahk_group HL_close_alt_f4")
^F4::Send "!{F4}"
#HotIf WinActive("ahk_group HL_close_Esc")
^F4::Send "{Esc}"

; 4. 侧边后退键 打头
#HotIf WinActive("ahk_group HL_sideBack_alt_f4")
XButton1::Send "!{F4}"
#HotIf WinActive("ahk_group HL_sideBack_Esc")
XButton1::Send "{Esc}"

; 低等级
; 1. 新建
#HotIf WinActive("ahk_group new_F3")
^F3::Send "{F3}"
#HotIf WinActive("ahk_group new_F8")
^F3::Send "{F8}"
#HotIf WinActive("ahk_group new_alt_a")
^F3::Send "!a"
#HotIf WinActive("ahk_group new_alt_c")
^F3::Send "!c"
#HotIf WinActive("ahk_group new_alt_n")
^F3::Send "!n"
#HotIf WinActive("ahk_group new_alt_o")
^F3::Send "!o"
#HotIf WinActive("ahk_group new_ctrl_n")
^F3::Send "^n"
#HotIf WinActive("ahk_group new_ctrl_n_2")
^F3::Send "{Control Down}n{Control Up}"
#HotIf WinActive("ahk_group new_ctrl_o")
^F3::Send "^o"
#HotIf WinActive("ahk_group new_ctrl_t")
^F3::Send "^t"
#HotIf WinActive("ahk_group new_ctrl_alt_t")
^F3::Send "^!t"
#HotIf WinActive("ahk_group new_ctrl_shift_t")
^F3::Send "^+t"
#HotIf WinActive("ahk_group new_ctrl_shift_n")
^F3::Send "^+n"

; 2. 逃逸
#HotIf WinActive("ahk_group esc_WinClose")
Esc::WinClose

; 3. 关闭 打头
#HotIf WinActive("ahk_group close_Esc")
^F4::Send "{Esc}"
#HotIf WinActive("ahk_group close_alt_f4")
^F4::Send "!{F4}"
#HotIf WinActive("ahk_group close_alt_f4_2")
^F4::Send "{Alt Down}{F4 Down}{F4 Up}{Alt Up}"
#HotIf WinActive("ahk_group close_alt_l")
^F4::Send "!l"
#HotIf WinActive("ahk_group close_alt_q")
^F4::Send "!q"
#HotIf WinActive("ahk_group close_alt_w")
^F4::Send "!w"
#HotIf WinActive("ahk_group close_ctrl_w")
^F4::Send "^w"
#HotIf WinActive("ahk_group close_ctrl_alt_q")
^F4::Send "^!q"
#HotIf WinActive("ahk_group close_ctrl_shift_w")
^F4::Send "^+w"
; 兜底
#HotIf not WinActive("ahk_group close_ctrl_f4")
^F4::SmartCloseWindow ; 比 WinClose "A" 好使

; 4. 侧边后退键 打头
#HotIf WinActive("ahk_group sideBack_Esc")
XButton1::Send "{Esc}"
#HotIf WinActive("ahk_group sideBack_closeBracket")
XButton1::Send "]"
#HotIf WinActive("ahk_group sideBack_alt_f4")
XButton1::Send "!{F4}"
#HotIf WinActive("ahk_group sideBack_alt_f4_2")
XButton1::Send "{Alt Down}{F4 Down}{F4 Up}{Alt Up}"
#HotIf WinActive("ahk_group sideBack_alt_l")
XButton1::Send "!l"
#HotIf WinActive("ahk_group sideBack_alt_q")
XButton1::Send "!q"
#HotIf WinActive("ahk_group sideBack_alt_w")
XButton1::Send "!w"
#HotIf WinActive("ahk_group sideBack_ctrl_f4")
XButton1::Send "^{F4}"
#HotIf WinActive("ahk_group sideBack_ctrl_w")
XButton1::Send "^w"
#HotIf WinActive("ahk_group sideBack_ctrl_alt_q")
XButton1::Send "^!q"
#HotIf WinActive("ahk_group sideBack_ctrl_shift_w")
XButton1::Send "^+w"
; 兜底
#HotIf
XButton1::SmartCloseWindow ; 比 WinClose "A" 好使

; 5. 前进键
#HotIf WinActive("ahk_group forward_mediaNext")
!Right::Send "{Media_Next}" ; 下一曲
#HotIf WinActive("ahk_group forward_ctrl_right")
!Right::Send "^{Right}"
#HotIf WinActive("ahk_group forward_PgDn")
!Right::Send "{PgDn}"
#HotIf WinActive("ahk_group forward_Right")
!Right::Send "{Right}"

; 6. 下个标签
#HotIf WinActive("ahk_group next_mediaNext")
^Tab::Send "{Media_Next}" ; 下一曲
#HotIf WinActive("ahk_group next_closeBracket")
^Tab::Send "]"
#HotIf WinActive("ahk_group next_n")
^Tab::Send "n"
#HotIf WinActive("ahk_group next_Down")
^Tab::Send "{Down}"
#HotIf WinActive("ahk_group next_ctrl_shift_pgDn")
^Tab::Send "^+{PgDn}"
#HotIf WinActive("ahk_group next_alt_closeBracket")
^Tab::Send "!]"
#HotIf WinActive("ahk_group next_alt_right")
^Tab::Send "!{Right}"
#HotIf WinActive("ahk_group next_ctrl_pgDn")
^Tab::Send "^{PgDn}"
#HotIf WinActive("ahk_group next_ctrl_alt_right")
^Tab::Send "^!{Right}"
#HotIf WinActive("ahk_group next_pgDn")
^Tab::Send "{PgDn}"

; 7. 后退
#HotIf WinActive("ahk_group back_Media_Prev")
!Left::Send "{Media_Prev}" ; 上一曲
#HotIf WinActive("ahk_group back_PgUp")
!Left::Send "{PgUp}"
#HotIf WinActive("ahk_group back_Left")
!Left::Send "{Left}"
#HotIf WinActive("ahk_group back_Up")
!Left::Send "{Up}"
; 8. 上个标签
#HotIf WinActive("ahk_group previous_mediaPrev")
^+Tab::Send "{Media_Prev}" ; 上一曲
#HotIf WinActive("ahk_group previous_openBracket")
^+Tab::Send "[" ; 对 bilibili 不好用，由于会触发 ctrl + shift 切换输入法我就醉了
#HotIf WinActive("ahk_group previous_p")
^+Tab::Send "p"
#HotIf WinActive("ahk_group previous_Up")
^+Tab::Send "{Up}"
#HotIf WinActive("ahk_group previous_alt_0")
^+Tab::Send "!0"
#HotIf WinActive("ahk_group previous_alt_left")
^+Tab::Send "!{Left}"
#HotIf WinActive("ahk_group previous_alt_openBracket")
^+Tab::Send "!["
#HotIf WinActive("ahk_group previous_ctrl_left")
^+Tab::Send "^{Left}"
#HotIf WinActive("ahk_group previous_ctrl_alt_left")
^+Tab::Send "^!{Left}"
#HotIf WinActive("ahk_group previous_ctrl_PgUp")
^+Tab::Send "^{PgUp}"
#HotIf WinActive("ahk_group previous_PgUp")
^+Tab::Send "{PgUp}"
; 9. 侧边前进键
#HotIf WinActive("ahk_group sideForward_mediaPrev")
XButton2::Send "{Media_Prev}"
#HotIf WinActive("ahk_group sideForward_mediaPlayPause")
XButton2::Send "{Media_Play_Pause}"
#HotIf WinActive("ahk_group sideForward_space")
XButton2::Send "{Space}"
#HotIf WinActive("ahk_group sideForward_openBracket")
XButton2::Send "["
#HotIf WinActive("ahk_group sideForward_p")
XButton2::Send "p"
#HotIf WinActive("ahk_group sideForward_Up")
XButton2::Send "{Up}"
#HotIf WinActive("ahk_group sideForward_PgUp")
XButton2::Send "{PgUp}"
#HotIf WinActive("ahk_group sideForward_alt_left")
XButton2::Send "!{Left}"
#HotIf WinActive("ahk_group sideForward_alt_0")
XButton2::Send "!0"
#HotIf WinActive("ahk_group sideForward_alt_openBracket")
XButton2::Send "!["
#HotIf WinActive("ahk_group sideForward_ctrl_left")
XButton2::Send "^{Left}"
#HotIf WinActive("ahk_group sideForward_ctrl_PgUp")
XButton2::Send "^{PgUp}"
#HotIf WinActive("ahk_group sideForward_ctrl_alt_left")
XButton2::Send "^!{Left}"
; 兜底
#HotIf
XButton2::Send "^+{Tab}"

; 固定写法
; win 11 资源管理器的新建窗口，不过这样会使得新建文件夹失效，直接用鼠标手势不失一种好选择
; #HotIf WinActive("ahk_class CabinetWClass ahk_exe explorer.exe")
; ^+n::Send "^n"
; #HotIf
