#SingleInstance force

; 读取数据
global appList := parseAppInfo()

parseAppInfo() {
  appList := []
  ; 每次从字符串中检索字符串(片段)
  Loop Parse, FileRead("data.csv", "UTF-8"), "`n", "`r" {
      ; 跳过首行
      if A_Index < 2       
        continue
      else {
        appInfo := parseLine(A_LoopField)    
        if appInfo
            appList.Push(appInfo)
      }
  }
  return appList  
}

; 注册热键 和 热字符串
Loop appList.Length {
    if A_Index > 1 {
        it := appList[A_Index]
       
        if it.new = "{F8}"
          GroupAdd("new_F8", it.exe)
        else if it.new = "!a"
          GroupAdd("new_alt_a", it.exe)
        else if it.new = "!c"
          GroupAdd("new_alt_c", it.exe)
        else if it.new = "!n"
          GroupAdd("new_alt_n", it.exe)
        else if it.new = "!o"
          GroupAdd("new_alt_o", it.exe)
        else if it.new = "^n"
          GroupAdd("new_ctrl_n", it.exe)
        else if it.new = "{Control Down}n{Control Up}"
          GroupAdd("new_ctrl_n_2", it.exe)       
        else if it.new = "^t"
          GroupAdd("new_ctrl_t", it.exe)
        else if it.new = "^!t"          
          GroupAdd("new_ctrl_alt_t", it.exe) 
        else if it.new = "^+t"          
          GroupAdd("new_ctrl_shift_t", it.exe)

        if it.escape = "WinClose"
          GroupAdd("esc_WinClose", it.exe)

        if it.close = "^{F4}" or it.close = "" {
          ; do nothing
        }
        else if it.close = "!{F4}"
          GroupAdd("close_alt_f4", it.exe)
        else if it.close = "{Alt Down}{F4 Down}{F4 Up}{Alt Up}"
          GroupAdd("close_alt_f4_2", it.exe)
        else if it.close = "!l"
          GroupAdd("close_alt_l", it.exe)
        else if it.close = "!q"
          GroupAdd("close_alt_q", it.exe)
        else if it.close = "!w"
          GroupAdd("close_alt_w", it.exe)
        else if it.close = "^w"
          GroupAdd("close_ctrl_w", it.exe)
        else if it.close = "^!q"
          GroupAdd("close_ctrl_alt_q", it.exe)
        else if it.close = "^+w"
          GroupAdd("close_ctrl_shift_w", it.exe)
        else if it.close = "{Esc}"
          GroupAdd("close_esc", it.exe)
        else
          GroupAdd("close_WinClose", it.exe)

        if it.sideBack = "!{F4}"
          GroupAdd("sideBack_alt_f4", it.exe)
        else if it.sideBack = "{Alt Down}{F4 Down}{F4 Up}{Alt Up}"
          GroupAdd("sideBack_alt_f4_2", it.exe)
        if it.sideBack = "!l"
          GroupAdd("sideBack_alt_l", it.exe)
        else if it.sideBack = "!q"
          GroupAdd("sideBack_alt_q", it.exe)
        else if it.sideBack = "!w"
          GroupAdd("sideBack_alt_w", it.exe)
        else if it.sideBack = "^{F4}"
          GroupAdd("sideBack_ctrl_f4", it.exe)
        else if it.sideBack = "^w"
          GroupAdd("sideBack_ctrl_w", it.exe)
        else if it.close = "^!q"
          GroupAdd("sideBack_ctrl_alt_q", it.exe)
        else if it.sideBack = "^+w"          
          GroupAdd("sideBack_ctrl_shift_w", it.exe)
        else if it.sideBack = "{Esc}"
          GroupAdd("sideBack_esc", it.exe)
        else
          GroupAdd("sideBack_WinClose", it.exe)

        if it.forward = "{Media_Prev}"
          GroupAdd("forward_Media_Prev", it.exe)

        if it.previous = "{Media_Prev}"
          GroupAdd("previous_Media_Prev", it.exe)
        else if it.previous = "!0"
          GroupAdd("previous_alt_0", it.exe)
        else if it.previous = "!{Left}"
          GroupAdd("previous_alt_left", it.exe)
        else if it.previous = "!["
          GroupAdd("previous_alt_zuofang", it.exe)
        else if it.previous = "^{PgUp}"
          GroupAdd("previous_ctrl_pgup", it.exe)
        else if it.previous = "^!{Left}"
          GroupAdd("previous_ctrl_alt_left", it.exe)

        if it.sideForward = "{Media_Prev}"
          GroupAdd("sideForward_Media_Prev", it.exe)
        else if it.sideForward = "!{Left}"
          GroupAdd("sideForward_alt_left", it.exe)
        else if it.sideForward = "!0"
          GroupAdd("sideForward_alt_0", it.exe)
        else if it.sideForward = "!["
          GroupAdd("sideForward_alt_zuofang", it.exe)
        else if it.sideForward = "^{PgUp}"
          GroupAdd("sideForward_ctrl_pgup", it.exe)
        else if it.sideForward = "^!{Left}"
          GroupAdd("sideForward_ctrl_alt_left", it.exe)
        else if it.sideForward = "^+{Tab}"
          GroupAdd("sideForward_ctrl_alt_tab", it.exe)

        if it.back = "{Media_Next}"
          GroupAdd("back_Media_Next", it.exe)

        if it.next = "{Media_Next}"
          GroupAdd("next_Media_Next", it.exe)
        else if it.next = "^+{PgDn}"
          GroupAdd("next_ctrl_shift_pgdn", it.exe)
        else if it.next = "!]"
          GroupAdd("next_alt_youfang", it.exe)
        else if it.next = "!{Right}"
          GroupAdd("next_alt_right", it.exe)
        else if it.next = "^{PgDn}"
          GroupAdd("next_ctrl_pgdn", it.exe)
        else if it.next = "^!{Right}"
          GroupAdd("next_ctrl_alt_right", it.exe)
      }
}

parseLine(line) {  
  split := StrSplit(line, ",")  
  if split.Length != 12
    return     
  info := {}
  info.exe := Trim(split[2])
  info.new := Trim(split[3])
  info.escape := Trim(split[4])
  info.close := Trim(split[5])
  info.sideBack := Trim(split[6])

  info.forward := Trim(split[7])
  info.previous := Trim(split[8])
  info.sideForward := Trim(split[9])

  info.back := Trim(split[10])
  info.next := Trim(split[11])

  info.restore := Trim(split[12])
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

app_hotkey4(hk)
{
    heiha(ladaoba)  ; 这是 app_title 和 app_path 的闭包.
    {
      MsgBox "hk = " hk
    }
    return heiha
}

feitang(yushe) {
  heiha(hk) 
  {
    MsgBox "yushe = " yushe ", hk = " hk
    return true
  }
  return heiha
}

; g := app_hotkey()
; MsgBox g("ahk_exe 360ChromeX.exe")
; MsgBox g("ahk_exe Code.exe")

; m := app_hotkey2("ahk_exe 360ChromeX.exe")
; MsgBox m()
; m := app_hotkey2("ahk_exe Code.exe")
; MsgBox m()

; GroupAdd "keep_ctrl_n_g", "ahk_exe i)MarkdownPad2.exe"
; ; 判断是否在 新建组 ctrl + n ， 必须知道元 和 想如何映射

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
#HotIf WinActive("ahk_group new_ctrl_t")
^F3::Send "^t"
#HotIf WinActive("ahk_group new_ctrl_alt_t")
^F3::Send "^!t"
#HotIf WinActive("ahk_group new_ctrl_shift_t")
^F3::Send "^+t"

#HotIf WinActive("ahk_group esc_WinClose")
Esc::WinClose

#HotIf WinActive("ahk_group close_WinClose")
^F4::{
  try WinClose "A" ; not WinActive 必须和 WinClose 搭配，且 WinClose 通用性更好
  catch {
      MsgBox "关闭窗口失败，请重试"
  }
}
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
#HotIf WinActive("ahk_group close_esc")
^F4::Send "{Esc}"

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
#HotIf WinActive("ahk_group sideBack_esc")
XButton1::Send "{Esc}"
#HotIf WinActive("ahk_group sideBack_WinClose")
XButton1::{
  try WinClose "A" ; not WinActive 必须和 WinClose 搭配，且 WinClose 通用性更好
  catch {
      MsgBox "关闭窗口失败，请重试"
  }
}

#HotIf WinActive("ahk_group forward_Media_Prev")
!Left::Send "{Media_Prev}" ; 上一曲

#HotIf WinActive("ahk_group previous_Media_Prev")
^+Tab::Send "{Media_Prev}" ; 上一曲
#HotIf WinActive("ahk_group previous_alt_0")
^+Tab::Send "!0"
#HotIf WinActive("ahk_group previous_alt_left")
^+Tab::Send "!{Left}"
#HotIf WinActive("ahk_group previous_alt_zuofang")
^+Tab::Send "!["
#HotIf WinActive("ahk_group previous_ctrl_pgup")
^+Tab::Send "^{PgUp}"
#HotIf WinActive("ahk_group previous_ctrl_alt_left")
^+Tab::Send "^!{Left}"

#HotIf WinActive("ahk_group sideForward_Media_Prev")
XButton2::Send "{Media_Prev}" ; 上一曲
#HotIf WinActive("ahk_group sideForward_alt_left")
XButton2::Send "!{Left}"
#HotIf WinActive("ahk_group sideForward_alt_0")
XButton2::Send "!0"
#HotIf WinActive("ahk_group sideForward_alt_zuofang")
XButton2::Send "!["
#HotIf WinActive("ahk_group sideForward_ctrl_pgup")
XButton2::Send "^{PgUp}"
#HotIf WinActive("ahk_group sideForward_ctrl_alt_left")
XButton2::Send "^!{Left}"
#HotIf WinActive("ahk_group sideForward_ctrl_alt_tab")
XButton2::Send "^+{Tab}"

#HotIf WinActive("ahk_group back_Media_Next")
!Right::Send "{Media_Next}" ; 下一曲

#HotIf WinActive("ahk_group next_Media_Next")
^Tab::Send "{Media_Next}" ; 下一曲
#HotIf WinActive("ahk_group next_ctrl_shift_pgdn")
^Tab::Send "^+{PgDn}"
#HotIf WinActive("ahk_group next_alt_youfang")
^Tab::Send "!]"
#HotIf WinActive("ahk_group next_alt_right")
^Tab::Send "!{Right}"
#HotIf WinActive("ahk_group next_ctrl_pgdn")
^Tab::Send "^{PgDn}"
#HotIf WinActive("ahk_group next_ctrl_alt_right")
^Tab::Send "^!{Right}"
