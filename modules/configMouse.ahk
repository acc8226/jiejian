#HotIf mouseIsOnEdge()
RButton::{
  Send "{Media_Play_Pause}"
  Tip('暂停/恢复', -399)
}

MButton::{
  Send "{Volume_Mute}"
  Tip('静音/恢复', -399)
}
WheelUp::Send "{Volume_Up}"
WheelDown::Send "{Volume_Down}"

; 下一曲
XButton1::
^F4::
!Right::
^Tab::{
  Send "{Media_Next}"
  Tip('下一曲', -399)
}
; 上一曲
XButton2::
!Left::
^+Tab::{
  Send "{Media_Prev}"
  Tip('上一曲', -399)
}

#HotIf mouseIsOnTaskBar()
MButton::Send "{Volume_Mute}"
WheelUp::Send "{Volume_Up}"
WheelDown::Send "{Volume_Down}"

; 下一曲
XButton1::
^F4::
!Right::
^Tab::Send "{Media_Next}"
; 上一曲
XButton2::
!Left::
^+Tab::Send "{Media_Prev}"
#HotIf

; 鼠标移动到屏幕左或上边缘
mouseIsOnEdge() {
  MouseGetPos &OutputVarX, &OutputVarY
  return (OutputVarX >= 0 and OutputVarX <= 2)
  or (OutputVarY >= 0 and OutputVarY <= 2)
}

; 鼠标移动到任务栏上
mouseIsOnTaskBar() {
  MouseGetPos ,, &OutputVarWin
  return WinExist("ahk_class Shell_TrayWnd ahk_id " OutputVarWin)
}
