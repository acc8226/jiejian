global appList := parseApp()

; 注册热键 和 热字符串
Loop appList.Length {
  if A_Index > 1 {
      it := appList[A_Index]
      
      ; 1. 新建
      if it.new = "{F8}"
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
      else if it.new = "^t"
        GroupAdd "new_ctrl_t", it.exe
      else if it.new = "^!t"          
        GroupAdd "new_ctrl_alt_t", it.exe
      else if it.new = "^+t"          
        GroupAdd "new_ctrl_shift_t", it.exe

      ; 2. 逃逸
      if it.escape = "WinClose"
        GroupAdd "esc_WinClose", it.exe

      ; 3. 关闭
      if it.close = "{Esc}"
        GroupAdd "close_esc", it.exe
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
        GroupAdd "sideBack_esc", it.exe
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
        GroupAdd "forward_Media_Next", it.exe
      else if it.forward = "^{Right}"
        GroupAdd "forward_ctrl_right", it.exe

      ; 6. 下个标签
      if it.nextTag = "{Media_Next}"
        GroupAdd "next_Media_Next", it.exe
      else if it.nextTag = "^+{PgDn}"
        GroupAdd "next_ctrl_shift_pgdn", it.exe
      else if it.nextTag = "!]"
        GroupAdd "next_alt_youfang", it.exe
      else if it.nextTag = "!{Right}"
        GroupAdd "next_alt_right", it.exe
      else if it.nextTag = "^{PgDn}"
        GroupAdd "next_ctrl_pgdn", it.exe
      else if it.nextTag = "^!{Right}"
        GroupAdd "next_ctrl_alt_right", it.exe

      ; 7. 后退
      if it.back = "{Media_Prev}"
        GroupAdd "back_Media_Prev", it.exe

      ; 8. 上个标签
      if it.previousTag = "{Media_Prev}"
        GroupAdd "previous_Media_Prev", it.exe
      else if it.previousTag = "!0"
        GroupAdd "previous_alt_0", it.exe
      else if it.previousTag = "!{Left}"
        GroupAdd "previous_alt_left", it.exe
      else if it.previousTag = "!["
        GroupAdd "previous_alt_zuofang", it.exe
      else if it.previousTag = "^{Left}"
        GroupAdd "previous_ctrl_left", it.exe
      else if it.previousTag = "^!{Left}"
        GroupAdd "previous_ctrl_alt_left", it.exe
      else if it.previousTag = "^{PgUp}"
        GroupAdd "previous_ctrl_pgup", it.exe

      ; 9. 侧边前进键
      if it.sideForward = "{Media_Prev}"
        GroupAdd "sideForward_Media_Prev", it.exe
      else if it.sideForward = "!{Left}"
        GroupAdd "sideForward_alt_left", it.exe
      else if it.sideForward = "!0"
        GroupAdd "sideForward_alt_0", it.exe
      else if it.sideForward = "!["
        GroupAdd "sideForward_alt_zuofang", it.exe
      else if it.sideForward = "^{Left}"
        GroupAdd "sideForward_ctrl_left", it.exe
      else if it.sideForward = "^{PgUp}"
        GroupAdd "sideForward_ctrl_pgup", it.exe
      else if it.sideForward = "^!{Left}"
        GroupAdd "sideForward_ctrl_alt_left", it.exe
      else if it.sideForward = "^+{Tab}"
        GroupAdd "sideForward_ctrl_alt_tab", it.exe
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
  if split.Length != 11
    return 
  info := {}
  info.exe := Trim(split[2])

  info.new := Trim(split[3])

  info.escape := Trim(split[4])

  info.close := Trim(split[5])
  info.sideBack := Trim(split[6])

  info.forward := Trim(split[7])
  info.nextTag := Trim(split[8])

  info.back := Trim(split[9])
  info.previousTag := Trim(split[10])
  info.sideForward := Trim(split[11])

  if (info.exe = '' and info.new = '' and info.escape = '' and info.close = '' and info.sideBack = ''    
    and info.forward = '' and info.previousTag = '' and info.sideForward = '' and info.back = '' and info.nextTag = '') {        
      return    
    }  
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

; 单独的 class 必须单独配置，不能配置在表格中。因为 class 的适配范围太广了
; 通用 dialog，适用于 netbean 32/64 位 和 jb 全家桶的弹窗
#HotIf WinActive("ahk_class SunAwtDialog")
       or WinActive("ahk_class #32770") ; 通用窗口
            and not WinActive("ahk_exe 360zip.exe") ; 排除不处理 360 压缩
            and not WinActive("ahk_exe geek64.exe") ; 排除不处理 极客卸载

^F4::
XButton1::Send "{Esc}"

; 1. 新建
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

; 2. 逃逸
#HotIf WinActive("ahk_group esc_WinClose")
Esc::WinClose

; 3. 关闭 打头
#HotIf WinActive("ahk_group close_esc")
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
#HotIf not WinActive("ahk_group close_ctrl_f4")
; 兜底
^F4::{
  try WinClose "A"
  catch {
      MsgBox "关闭窗口失败，请重试"
  }
}

; 4. 侧边后退键 打头
#HotIf WinActive("ahk_group sideBack_esc")
XButton1::Send "{Esc}"
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
#HotIf
; 兜底
XButton1::{
  try WinClose "A"
  catch {
      MsgBox "关闭窗口失败，请重试"
  }
}

; 5. 前进键
#HotIf WinActive("ahk_group forward_Media_Next")
!Left::Send "{Media_Next}" ; 下一曲
#HotIf WinActive("ahk_group forward_ctrl_right")
^+Tab::Send "^{Right}"
; 6. 下个标签
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

; 7. 后退
#HotIf WinActive("ahk_group back_Media_Prev")
!Left::Send "{Media_Prev}" ; 上一曲
; 8. 上个标签
#HotIf WinActive("ahk_group previous_Media_Prev")
^+Tab::Send "{Media_Prev}" ; 上一曲
#HotIf WinActive("ahk_group previous_alt_0")
^+Tab::Send "!0"
#HotIf WinActive("ahk_group previous_alt_left")
^+Tab::Send "!{Left}"
#HotIf WinActive("ahk_group previous_alt_zuofang")
^+Tab::Send "!["
#HotIf WinActive("ahk_group previous_ctrl_left")
^+Tab::Send "^{Left}"
#HotIf WinActive("ahk_group previous_ctrl_alt_left")
^+Tab::Send "^!{Left}"
#HotIf WinActive("ahk_group previous_ctrl_pgup")
^+Tab::Send "^{PgUp}"
; 9. 侧边前进键
#HotIf WinActive("ahk_group sideForward_Media_Prev")
XButton2::Send "{Media_Prev}" ; 上一曲
#HotIf WinActive("ahk_group sideForward_alt_left")
XButton2::Send "!{Left}"
#HotIf WinActive("ahk_group sideForward_alt_0")
XButton2::Send "!0"
#HotIf WinActive("ahk_group sideForward_alt_zuofang")
XButton2::Send "!["
#HotIf WinActive("ahk_group sideForward_ctrl_left")
XButton2::Send "^{Left}"
#HotIf WinActive("ahk_group sideForward_ctrl_pgup")
XButton2::Send "^{PgUp}"
#HotIf WinActive("ahk_group sideForward_ctrl_alt_left")
XButton2::Send "^!{Left}"
#HotIf WinActive("ahk_group sideForward_ctrl_alt_tab")
XButton2::Send "^+{Tab}"
