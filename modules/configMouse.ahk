#HotIf MouseIsOnLeftEdge()
MButton::{
  ; 静音/不静音主音量
  Send "{Volume_Mute}"
  Tip '静音/恢复', -399
}
RButton::{
  Send "{Media_Play_Pause}"
  Tip '暂停/恢复', -399
}

WheelUp::{
  Send "{Volume_Up 2}"
  ; win 8 以前
  if (VerCompare(A_OSVersion, "6.2") < 0) {
    sleep 69
    Tip('音量 ' . Round(SoundGetVolume()), -399)
  }
}
WheelDown::{
  Send "{Volume_Down 2}"
  if (VerCompare(A_OSVersion, "6.2") < 0) {
    sleep 69
    Tip('音量 ' . Round(SoundGetVolume()), -399)
  }
}

; 上一曲
XButton2::{
  Send "{Media_Prev}"
  Tip '上一曲', -399
}
; 下一曲
XButton1::{
  Send "{Media_Next}"
  Tip '下一曲', -399
}

#HotIf MouseIsOnTopEdge()
MButton::{
  Send "{Volume_Mute}"
  Tip '静音/恢复', -399
}
RButton::{
  Send "{Media_Play_Pause}"
  Tip '暂停/恢复', -399
}

WheelUp::{
  Send "{Media_Next}"
  Tip '下一曲', -399
}
WheelDown::{
  Send "{Media_Prev}"
  Tip '上一曲', -399
}

; 鼠标移动到任务栏上
#HotIf MouseIsOver('ahk_class Shell_TrayWnd')
MButton::Send "{Volume_Mute}"
WheelUp::{
  Send "{Volume_Up 2}"
  ; win 11 22533 版本更新了音量指示器，底部居中显示且更加美观了
  if (VerCompare(A_OSVersion, "10.1.22533") < 0) {
    sleep 69
    Tip('音量 ' . Round(SoundGetVolume()), -399)
  }
}
WheelDown::{
  Send "{Volume_Down 2}"
  if (VerCompare(A_OSVersion, "10.1.22533") < 0) {
    sleep 69
    Tip('音量 ' . Round(SoundGetVolume()), -399)
  }
}


; 下一曲
XButton1::Send '{Media_Next}'
; 上一曲
XButton2::Send '{Media_Prev}'
#HotIf

; 鼠标移动到屏幕左边缘
MouseIsOnLeftEdge() {
  MouseGetPos &OutputVarX
  return OutputVarX >= 0 && OutputVarX <= 2
}

; 鼠标移动到屏幕上边缘
MouseIsOnTopEdge() {
  MouseGetPos , &OutputVarY
  return OutputVarY >= 0 && OutputVarY <= 2
}

MouseIsOver(WinTitle) {
  MouseGetPos ,, &Win
  return WinExist(WinTitle . " ahk_id " . Win)
}
