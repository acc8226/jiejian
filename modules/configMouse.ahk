#HotIf mouseIsOnLeftEdge()
MButton::{
  Send "{Volume_Mute}"
  Tip('静音/恢复', -399)
}
RButton::{
  Send "{Media_Play_Pause}"
  Tip('暂停/恢复', -399)
}

WheelUp::Send "{Volume_Up}"
WheelDown::Send "{Volume_Down}"

; 上一曲
XButton2::{
  Send "{Media_Prev}"
  Tip('上一曲', -399)
}
; 下一曲
XButton1::{
  Send "{Media_Next}"
  Tip('下一曲', -399)
}

#HotIf mouseIsOnTopEdge()
WheelUp::{
  Send "{Media_Next}"
  Tip('下一曲', -399)
}
WheelDown::{
  Send "{Media_Prev}"
  Tip('上一曲', -399)
}

; 鼠标移动到任务栏上
#HotIf MouseIsOver('ahk_class Shell_TrayWnd')
MButton::Send "{Volume_Mute}"
WheelUp::Send "{Volume_Up}"
WheelDown::Send "{Volume_Down}"
; 下一曲
XButton1::Send "{Media_Next}"
; 上一曲
XButton2::Send "{Media_Prev}"
#HotIf

; 鼠标移动到屏幕左边缘
mouseIsOnLeftEdge() {
  MouseGetPos &OutputVarX
  return OutputVarX >= 0 and OutputVarX <= 2
}

; 鼠标移动到屏幕上边缘
mouseIsOnTopEdge() {
  MouseGetPos , &OutputVarY
  return OutputVarY >= 0 and OutputVarY <= 2
}

MouseIsOver(WinTitle) {
  MouseGetPos ,, &Win
  return WinExist(WinTitle . " ahk_id " . Win)
}