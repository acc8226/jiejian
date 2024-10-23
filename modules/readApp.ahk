GLOBAL TEXT_GROUP := 'text_group'
; 完善 TEXT_GROUP 组信息
GroupAdd TEXT_GROUP, 'ahk_class ^AutoHotkeyGUI$'

ParseAppCSV
ParseAppCSV() {
  applist := parseApp('app.csv')
  ; 注册热键 和 热字符串
  Loop applist.Length {
    if A_Index <= 1
      continue
  
    it := applist[A_Index]
    if (it.highLevel) {
      ; 高优先级
      ; e 列 关闭
      switch it.close, 'Off' {
        case "Esc", "{Esc}": GroupAdd('HL_close_esc', it.exe)
        case "!F4", "!{F4}": GroupAdd('HL_close_alt_F4', it.exe)
        case "^F4", "^{F4}": GroupAdd('HL_close_ctrl_F4', it.exe)
      }
    } else {
      ; 低优先级
      ; d 列 新建
      switch it.new, 'Off' {
        case "F3", "{F3}": GroupAdd("new_F3", it.exe)
        case 'F8', "{F8}": GroupAdd("new_F8", it.exe)
        case 'L', : GroupAdd("new_L", it.exe)
        case 'O', : GroupAdd("new_O", it.exe)
        case "!a": GroupAdd("new_alt_a", it.exe)

        case "!c": GroupAdd("new_alt_c", it.exe)
        case "!n": GroupAdd("new_alt_n", it.exe)
        case "!o": GroupAdd("new_alt_o", it.exe)
        case "^n": GroupAdd("new_ctrl_n", it.exe)
        case "^o": GroupAdd("new_ctrl_o", it.exe)

        case "^t": GroupAdd("new_ctrl_t", it.exe)  
        case "^!t", "!^t": GroupAdd('new_ctrl_alt_t', it.exe)
        case "^+t", "+^t": GroupAdd('new_ctrl_shift_t', it.exe)
        case "^+n", "+^n": GroupAdd('new_ctrl_shift_n', it.exe)
      }
      ; e 列 关闭 和 鼠标后退键
      switch it.close, 'Off' {
        case "WinClose", '关闭': GroupAdd("close_WinClose", it.exe)
        case "Esc", "{Esc}": GroupAdd("close_Esc", it.exe)
        case "]": GroupAdd("close_closeBracket", it.exe)
        case '!F4', "!{F4}": GroupAdd("close_alt_F4", it.exe)
        case "!l": GroupAdd("close_alt_L", it.exe)
  
        case "!q": GroupAdd("close_alt_q", it.exe)
        case "!w": GroupAdd("close_alt_w", it.exe)
        case "^c": GroupAdd("close_ctrl_c", it.exe)
        case "^v": GroupAdd("close_ctrl_v", it.exe)
        case "^w": GroupAdd("close_ctrl_w", it.exe)
        case "^!q", "!^q": GroupAdd("close_ctrl_alt_q", it.exe)        
        case "^+w", "+^w": GroupAdd("close_ctrl_shift_w", it.exe)
        ; ctrl + f4 将做特殊处理
        case "^F4", "^{F4}": GroupAdd("close_ctrl_F4", it.exe)
      }
      ; f 列 前进
      switch it.forward, 'Off' {
        case "Media_Next", "{Media_Next}": GroupAdd "forward_MediaNext", it.exe
        case "PgDn", "{PgDn}": GroupAdd "forward_PgDn", it.exe
        case "Right", "{Right}": GroupAdd "forward_Right", it.exe
        case "b": GroupAdd "forward_b", it.exe
        case "n": GroupAdd "forward_n", it.exe
  
        case "z": GroupAdd("forward_z", it.exe)
        case "^Right", "^{Right}": GroupAdd("forward_ctrl_Right", it.exe)
        case "^Tab", "^{Tab}": GroupAdd("forward_ctrl_Tab", it.exe)
        case '^]': GroupAdd("forward_ctrl_closeBracket", it.exe)
        case "^n" : GroupAdd("forward_ctrl_n", it.exe)
  
        case "^!Right", "^!{Right}", "!^Right", "!^{Right}": GroupAdd("forward_ctrl_alt_Right", it.exe)
        case "^+Right", "^+{Right}", "+^Right", "+^{Right}": GroupAdd("forward_ctrl_shift_Right", it.exe)
        case "^+f", "+^f": GroupAdd("forward_ctrl_shift_f", it.exe)
      }
      ; g 列 下个标签
      switch it.nextTag, 'Off' {
        case ']': GroupAdd("next_closeBracket", it.exe)
        case 'Down', "{Down}": GroupAdd("next_Down", it.exe)
        case 'Media_Next', "{Media_Next}": GroupAdd("next_MediaNext", it.exe)
        case 'PgDn', '{PgDn}': GroupAdd("next_PgDn", it.exe)
        case "b": GroupAdd("next_b", it.exe)
  
        case "n": GroupAdd('next_n', it.exe)
        case "z": GroupAdd('next_z', it.exe)
        case "!]": GroupAdd('next_alt_closeBracket', it.exe)
        case "^]": GroupAdd('next_ctrl_closeBracket', it.exe)
        case "!Right", "!{Right}": GroupAdd('next_alt_Right', it.exe)
  
        case "^PgDn", "^{PgDn}": GroupAdd('next_ctrl_PgDn', it.exe)
        case "^Right", "^{Right}": GroupAdd("next_ctrl_Right", it.exe)
        case "^f": GroupAdd("next_ctrl_f", it.exe)
        case "^n": GroupAdd("next_ctrl_n", it.exe)
        case "^!PgDn", "^!{PgDn}", "!^PgDn", "!^{PgDn}": GroupAdd("next_ctrl_alt_PgDn", it.exe)

        case "^!Right", "^!{Right}", "!^Right", "!^{Right}": GroupAdd("next_ctrl_alt_Right", it.exe)  
        case "^+Right", "^+{Right}", "+^Right", "+^{Right}": GroupAdd("next_ctrl_shift_Right", it.exe)
      }
      ; h 列 后退
      switch it.back, 'Off' {
        case 'BackSpace', "{BackSpace}", "退格": GroupAdd("back_BackSpace", it.exe)
        case 'Left', "{Left}": GroupAdd("back_Left", it.exe)
        case 'Media_Prev', "{Media_Prev}": GroupAdd("back_MediaPrev", it.exe)
        case 'PgUp', "{PgUp}": GroupAdd("back_PgUp", it.exe)
        case 'Up', "{Up}": GroupAdd("back_Up", it.exe)
  
        case "v": GroupAdd('back_v', it.exe)
        case "z": GroupAdd('back_z', it.exe)
        case "^[": GroupAdd('back_ctrl_openBracket', it.exe)
        case "^Left", "^{Left}": GroupAdd('back_ctrl_Left', it.exe)
        case "^b": GroupAdd('back_ctrl_b', it.exe)
  
        case "^!Left", "^!{Left}", "!^Left", "!^{Left}": GroupAdd "back_ctrl_alt_Left", it.exe
        case "^+b", "+^b": GroupAdd('back_ctrl_shift_b', it.exe)
        case "^+Tab", "^+{Tab}", "+^Tab", "+^{Tab}": GroupAdd "back_ctrl_shift_Tab", it.exe
        case "^+Left", "^+{Left}", "+^Left", "+^{Left}": GroupAdd "back_ctrl_shift_Left", it.exe
      }
      ; I 列 上个标签 和 前进键
      switch it.previousTag, 'Off' {
        case 'Left', "{Left}": GroupAdd("previous_Left", it.exe)
        case "p": GroupAdd('previous_p', it.exe)
        case "z": GroupAdd('previous_z', it.exe)
        case "[": GroupAdd('previous_openBracket', it.exe)
        case 'Media_Play_Pause', "{Media_Play_Pause}": GroupAdd("previous_MediaPlayPause", it.exe)
        case 'Media_Prev', "{Media_Prev}": GroupAdd("previous_MediaPrev", it.exe)
  
        case 'PgUp', "{PgUp}": GroupAdd('previous_PgUp', it.exe)
        case 'Space', "{Space}", "空格": GroupAdd('previous_Space', it.exe)
        case 'Up', "{Up}": GroupAdd('previous_Up', it.exe)
        case "v": GroupAdd('previous_v', it.exe)
        case "!0": GroupAdd('previous_alt_0', it.exe)
  
        case "![": GroupAdd('previous_alt_openBracket', it.exe)
        case "!Left", "!{Left}": GroupAdd('previous_alt_Left', it.exe)
        case "^[": GroupAdd('previous_ctrl_openBracket', it.exe)
        case "^Left", "^{Left}": GroupAdd('previous_ctrl_Left', it.exe)
        case "^PgUp", "^{PgUp}": GroupAdd('previous_ctrl_PgUp', it.exe)
  
        case "^c": GroupAdd('previous_ctrl_c', it.exe)
        case "^v": GroupAdd('previous_ctrl_v', it.exe)
        case "^b": GroupAdd('previous_ctrl_b', it.exe)
        case "^!Left", "^!{Left}", "!^Left", "!^{Left}": GroupAdd("previous_ctrl_alt_Left", it.exe)
        case "^+Left", "^+{Left}", "+^Left", "+^{Left}": GroupAdd("previous_ctrl_shift_Left", it.exe)
      }
      ; J 列 新建窗口
      switch it.newWin, 'Off' {
        case "^n": GroupAdd("newWin_ctrl_n", it.exe)
        case "^!n", "!^n": GroupAdd("newWin_ctrl_alt_n", it.exe)
        case "^+n", "+^n": GroupAdd("newWin_ctrl_shift_n", it.exe)
      }
      ; K 列 全屏
      switch it.fs, 'Off' {
        case "DoubleClick", "双击": GroupAdd("fullscreen_DoubleClick", it.exe)
        case "Enter", "{Enter}", "回车": GroupAdd("fullscreen_Enter", it.exe)
        case "f": GroupAdd("fullscreen_f", it.exe)
        case "!f": GroupAdd("fullscreen_alt_f", it.exe)
        case "!Enter", "!{Enter}": GroupAdd("fullscreen_alt_Enter", it.exe)
  
        case "^+F12", "^+{F12}", "+^F12", "+^{F12}": GroupAdd("fullscreen_ctrl_shift_F12", it.exe)
      }
    }
  }
}

parseApp(fileName) {
  appList := []
  eachLineLen := 12
  ; 每次从字符串中检索字符串(片段)
  Loop Parse, FileRead(fileName), "`n", "`r" {
      ; 跳过首行
      if (A_Index >= 2) {
        appInfo := parseAppLine(A_LoopField, eachLineLen)
        if appInfo
          appList.Push(appInfo)
      }
  }
  return appList
}

parseAppLine(line, eachLineLen) {
  split := StrSplit(line, ",")
  ; 跳过不符合条件的行
  if split.Length < eachLineLen
    return
  splitEachLineLen := Trim(split[eachLineLen])
  ; 过滤不启用的行
  if NOT (splitEachLineLen == '' || splitEachLineLen = 'y' || splitEachLineLen == '是')
    return

  info := {}
  ; 跳过 exe 为空的行
  info.exe := Trim(split[3])
  if info.exe = ''
    return
  ; 判断是否是高等级
  info.highLevel := split[2] == "高"

  info.new := Trim(split[4])
  info.close := Trim(split[5])

  info.forward := Trim(split[6])
  info.nextTag := Trim(split[7])
  info.back := Trim(split[8])
  info.previousTag := Trim(split[9])
  info.newWin := Trim(split[10])

  info.fs := Trim(split[11])

  ; 过滤空行
  if (info.new == ''
    && info.close == ''

    && info.forward == ''
    && info.nextTag == ''
    && info.back == ''
    && info.previousTag == ''
    && info.fs == ''

    && info.newWin == ''
  ) {
    return
  }

  name := Trim(split[1])
  if name !== '' && info.exe !== '' {
    if 1 == InStr(name, "【浏览器】")
      GroupAdd "browser_group", info.exe
    else if (1 == InStr(name, "【editor】")
        || 1 == InStr(name, "【ftp】")
        || 1 == InStr(name, "【git】")
        || 1 == InStr(name, "【IDE】")
        || 1 == InStr(name, "【office】")
        || 1 == InStr(name, "【sql】")
        || 1 == InStr(name, "【窗口】")
        || '微信' = name
        || '腾讯 QQ' = name
      ) {
        ; 文本编辑
        GroupAdd(TEXT_GROUP, info.exe)
    }
  }
  return info
}

; 高等级
; e. 关闭 打头
#HotIf WinActive("ahk_group HL_close_esc")
^F4::
XButton1::Send "{Esc}"
#HotIf WinActive("ahk_group HL_close_alt_F4")
^F4::
XButton1::Send "!{F4}"
; 主要为窗口服务，若遇到 ctrl + f4 则必须捕获后处理，而非兜底处理
#HotIf WinActive("ahk_group HL_close_ctrl_F4")
^F4::Send "{Blind}^{F4}"
XButton1::Send "^{F4}"

; 低等级
; d. 新建
#HotIf WinActive("ahk_group new_F3")
^F8::Send "{F3}"
#HotIf WinActive("ahk_group new_F8")
^F8::Send "{F8}"
#HotIf WinActive("ahk_group new_L")
^F8::Send 'l'
#HotIf WinActive("ahk_group new_O")
^F8::Send 'o'
#HotIf WinActive("ahk_group new_alt_a")
^F8::Send '!a'

#HotIf WinActive("ahk_group new_alt_c")
^F8::Send '!c'
#HotIf WinActive("ahk_group new_alt_n")
^F8::Send "!n"
#HotIf WinActive("ahk_group new_alt_o")
^F8::Send "!o"
#HotIf WinActive("ahk_group new_ctrl_n")
^F8::Send "^n"
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

; e. 关闭 打头 和 鼠标后退键 用
#HotIf WinActive("ahk_group close_WinClose")
^F4::
XButton1::WinClose
#HotIf WinActive("ahk_group close_Esc")
^F4::
XButton1::Send '{Esc}'
#HotIf WinActive("ahk_group close_alt_F4")
^F4::
XButton1::Send "!{F4}"
#HotIf WinActive("ahk_group close_closeBracket")
^F4::
XButton1::Send "]"
#HotIf WinActive("ahk_group close_alt_L")
^F4::
XButton1::Send "!l"

#HotIf WinActive("ahk_group close_alt_q")
^F4::
XButton1::Send '!q'
#HotIf WinActive("ahk_group close_alt_w")
^F4::
XButton1::Send "!w"
#HotIf WinActive("ahk_group close_ctrl_c")
^F4::
XButton1::Send "^c"
#HotIf WinActive("ahk_group close_ctrl_v")
^F4::
XButton1::Send "^v"
#HotIf WinActive("ahk_group close_ctrl_w")
^F4::
XButton1::Send "^w"
#HotIf WinActive("ahk_group close_ctrl_alt_q")
^F4::
XButton1::Send "^!q"
#HotIf WinActive("ahk_group close_ctrl_shift_w")
^F4::
XButton1::Send("^+w")

; 如果填写的不是 ctrl + f4 则采取兜底处理：智能关闭
#HotIf !WinActive("ahk_group close_ctrl_F4")
^F4::
XButton1::SmartCloseWindow ; 比 WinClose "A" 好使
; 否则是 ctrl + f4，凡是遇到【#32770 窗口】则使用 esc 进行统一处理
#HotIf WinActive("ahk_class #32770")
^F4::
XButton1::Send '{Esc}'
; 最终则是 ctrl + f4 且非窗口则 ctrl + f4
; XButton1 兜底
#HotIf
XButton1::Send "^{F4}"

; f. 前进键
#HotIf WinActive("ahk_group forward_MediaNext")
!Right::Send "{Media_Next}" ; 下一曲
#HotIf WinActive("ahk_group forward_PgDn")
!Right::Send "{PgDn}"
#HotIf WinActive("ahk_group forward_Right")
!Right::Send "{Right}"
#HotIf WinActive("ahk_group forward_b")
!Right::Send "b"
#HotIf WinActive("ahk_group forward_n")
!Right::Send "n"

#HotIf WinActive("ahk_group forward_z")
!Right::Send "z"
#HotIf WinActive("ahk_group forward_ctrl_Right")
!Right::Send "^{Right}"
#HotIf WinActive("ahk_group forward_ctrl_Tab")
!Right::Send "^{Tab}"
#HotIf WinActive("ahk_group forward_ctrl_closeBracket")
!Right::Send "^]"
#HotIf WinActive("ahk_group forward_ctrl_n")
!Right::Send "^n"

#HotIf WinActive("ahk_group forward_ctrl_alt_Right")
!Right::Send "^!{Right}"
#HotIf WinActive("ahk_group forward_ctrl_shift_Right")
!Right::Send "^+{Right}"
#HotIf WinActive("ahk_group forward_ctrl_shift_f")
!Right::Send "^+f"

; g. 下个标签
#HotIf WinActive('ahk_group next_closeBracket')
^Tab::Send "]"
#HotIf WinActive("ahk_group next_Down")
^Tab::Send "{Down}"
#HotIf WinActive("ahk_group next_MediaNext")
^Tab::Send "{Media_Next}"
#HotIf WinActive("ahk_group next_PgDn")
^Tab::Send "{PgDn}"
#HotIf WinActive('ahk_group next_b')
^Tab::Send "b"

#HotIf WinActive('ahk_group next_n')
^Tab::Send "n"
#HotIf WinActive("ahk_group next_z")
^Tab::Send "z"
#HotIf WinActive("ahk_group next_alt_closeBracket")
^Tab::Send "!]"
#HotIf WinActive("ahk_group next_ctrl_closeBracket")
^Tab::Send "^]"
#HotIf WinActive("ahk_group next_alt_Right")
^Tab::Send "!{Right}"

#HotIf WinActive("ahk_group next_ctrl_PgDn")
^Tab::Send "^{PgDn}"
#HotIf WinActive("ahk_group next_ctrl_Right")
^Tab::Send "^{Right}"
#HotIf WinActive("ahk_group next_ctrl_f")
^Tab::Send "^f"
#HotIf WinActive("ahk_group next_ctrl_n")
^Tab::Send "^n"
#HotIf WinActive("ahk_group next_ctrl_alt_PgDn")
^Tab::Send "^!{PgDn}"

#HotIf WinActive("ahk_group next_ctrl_alt_Right")
^Tab::Send "^!{Right}"
#HotIf WinActive("ahk_group next_ctrl_shift_Right")
^Tab::Send "^+{Right}"

; h. 后退
#HotIf WinActive("ahk_group back_BackSpace")
!Left::Send "{BackSpace}"
#HotIf WinActive("ahk_group back_MediaPrev")
!Left::Send "{Media_Prev}" ; 上一曲
#HotIf WinActive("ahk_group back_PgUp")
!Left::Send "{PgUp}"
#HotIf WinActive("ahk_group back_Left")
!Left::Send "{Left}"
#HotIf WinActive("ahk_group back_Up")
!Left::Send "{Up}"

#HotIf WinActive("ahk_group back_v")
!Left::Send "v"
#HotIf WinActive("ahk_group back_z")
!Left::Send "z"
#HotIf WinActive("ahk_group back_ctrl_openBracket")
!Left::Send "^["
#HotIf WinActive("ahk_group back_ctrl_Left")
!Left::Send "^{Left}"
#HotIf WinActive("ahk_group back_ctrl_b")
!Left::Send "^b"
#HotIf WinActive("ahk_group back_ctrl_alt_Left")
!Left::Send "^!{Left}"
#HotIf WinActive("ahk_group back_ctrl_shift_b")
!Left::Send "^+b"
#HotIf WinActive("ahk_group back_ctrl_shift_Tab")
!Left::Send "^+{Tab}"
#HotIf WinActive("ahk_group back_ctrl_shift_Left")
!Left::Send "^+{Left}"

; I 列：上个标签 和 鼠标前进键 用
#HotIf WinActive("ahk_group previous_Left")
^+Tab::
XButton2::Send "{Left}"
#HotIf WinActive("ahk_group previous_p")
^+Tab::
XButton2::Send "p"
#HotIf WinActive("ahk_group previous_z")
^+Tab::
XButton2::Send "z"
#HotIf WinActive('ahk_group previous_openBracket')
^+Tab::
XButton2::Send "[" ; 对 bilibili 不好用，由于会触发 ctrl + shift 切换输入法我就醉了
#HotIf WinActive("ahk_group previous_MediaPlayPause")
^+Tab::
XButton2::Send "{Media_Play_Pause}"
#HotIf WinActive("ahk_group previous_MediaPrev")
^+Tab::
XButton2::Send "{Media_Prev}"

#HotIf WinActive("ahk_group previous_PgUp")
^+Tab::
XButton2::Send '{PgUp}'
#HotIf WinActive("ahk_group previous_Space")
^+Tab::
XButton2::Send "{Space}"
#HotIf WinActive("ahk_group previous_Up")
^+Tab::
XButton2::Send "{Up}"
#HotIf WinActive("ahk_group previous_v")
^+Tab::
XButton2::Send "v"
#HotIf WinActive("ahk_group previous_alt_0")
^+Tab::
XButton2::Send "!0"

#HotIf WinActive("ahk_group previous_alt_openBracket")
^+Tab::
XButton2::Send "!["
#HotIf WinActive('ahk_group previous_alt_Left')
^+Tab::
XButton2::Send "!{Left}"
#HotIf WinActive("ahk_group previous_ctrl_openBracket")
^+Tab::
XButton2::Send '^['
#HotIf WinActive("ahk_group previous_ctrl_Left")
^+Tab::
XButton2::Send "^{Left}"
#HotIf WinActive('ahk_group previous_ctrl_PgUp')
^+Tab::
XButton2::Send "^{PgUp}"

#HotIf WinActive('ahk_group previous_ctrl_c')
^+Tab::
XButton2::Send "^c"
#HotIf WinActive('ahk_group previous_ctrl_v')
^+Tab::
XButton2::Send "^v"
#HotIf WinActive('ahk_group previous_ctrl_b')
^+Tab::
XButton2::Send "^b"
#HotIf WinActive('ahk_group previous_ctrl_alt_Left')
^+Tab::
XButton2::Send '^!{Left}'
#HotIf WinActive('ahk_group previous_ctrl_shift_Left')
^+Tab::
XButton2::Send '^+{Left}'

; XButton2 兜底
#HotIf
XButton2::Send '^+{Tab}'

; J 列 新建窗口
#HotIf WinActive('ahk_group newWin_ctrl_n')
^F9::Send "{Blind}^n"
#HotIf WinActive('ahk_group newWin_ctrl_alt_n')
^F9::Send "{Blind}^!n"
#HotIf WinActive('ahk_group newWin_ctrl_shift_n')
^F9::Send "{Blind}^+n"

; K 列 F11 功能键增强 全屏
; 如果是浏览器 且 打开的是 bilibili 或 YouTube 则特殊处理，将 f11 转成按键 f
#HotIf WinActive("(?:- YouTube -|哔哩哔哩_bilibili) ahk_group browser_group")
F11::Send 'f'

#HotIf WinActive('ahk_group fullscreen_DoubleClick')
F11::MouseClick("left", , , 2)
#HotIf WinActive('ahk_group fullscreen_Enter')
F11::Send '{Enter}'
#HotIf WinActive('ahk_group fullscreen_f')
F11::Send 'f'
#HotIf WinActive('ahk_group fullscreen_alt_f')
F11::Send '!f'
#HotIf WinActive('ahk_group fullscreen_alt_Enter')
F11::Send '!{Enter}'
#HotIf WinActive('ahk_group fullscreen_ctrl_shift_F12')
F11::Send '^+{F12}'

; 增强：火狐浏览器 的 新建隐私窗口
#HotIf WinActive('ahk_class ^MozillaWindowClass$')
^+n::Send '{Blind}^+p'

; ctrl + F7 通用：置顶/取消置顶
#HotIf
^F7::ToggleWindowTopMost
