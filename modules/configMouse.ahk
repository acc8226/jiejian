#HotIf mouseIsOnLeftEdge()
MButton::{
  ; 静音/不静音主音量
  Send "{Volume_Mute}"
  Tip('静音/恢复', -399)
}
RButton::{
  Send "{Media_Play_Pause}"
  Tip('暂停/恢复', -399)
}

WheelUp::volumeUp
WheelDown::volumeDown

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
MButton::{
  Send "{Volume_Mute}"
  Tip('静音/恢复', -399)
}
RButton::{
  Send "{Media_Play_Pause}"
  Tip('暂停/恢复', -399)
}

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
WheelUp::volumeUp
WheelDown::volumeDown

; 下一曲
XButton1::Send "{Media_Next}"
; 上一曲
XButton2::Send "{Media_Prev}"
#HotIf

; 鼠标移动到屏幕左边缘
mouseIsOnLeftEdge() {
  MouseGetPos &OutputVarX
  return OutputVarX >= 0 && OutputVarX <= 2
}

; 鼠标移动到屏幕上边缘
mouseIsOnTopEdge() {
  MouseGetPos , &OutputVarY
  return OutputVarY >= 0 && OutputVarY <= 2
}

MouseIsOver(WinTitle) {
  MouseGetPos ,, &Win
  return WinExist(WinTitle . " ahk_id " . Win)
}

volumeUp() {
  Send "{Volume_Up}"
  if (VerCompare(A_OSVersion, "6.2") < 0) {
    sleep 69
    Tip(Round(SoundGetVolume()), -399)
  }
}

volumeDown() {
  Send "{Volume_Down}"
  if (VerCompare(A_OSVersion, "6.2") < 0) {
    sleep 69
    Tip(Round(SoundGetVolume()), -399)
  }
}
