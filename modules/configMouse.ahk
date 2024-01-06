#HotIf mouseIsOnTaskBarOrEdge()
MButton::Send "{Volume_Mute}"
WheelUp::Send "{Volume_Up}"
WheelDown::Send "{Volume_Down}"
XButton1::Send "{Media_Next}"
XButton2::Send "{Media_Prev}"
!Left::Send "{Media_Prev}"
!Right::Send "{Media_Next}"

#HotIf mouseIsOnEdge()
RButton::Send "{Media_Play_Pause}"

; 鼠标移动到屏幕左或上边缘 或 任务栏上
mouseIsOnTaskBarOrEdge() {
  MouseGetPos &OutputVarX, &OutputVarY, &OutputVarWin
  return (OutputVarX >= 0 and OutputVarX <= 2)
         or (OutputVarY >= 0 and OutputVarY <= 2)
         or WinExist("ahk_class Shell_TrayWnd ahk_id " OutputVarWin)
}

; 鼠标移动到屏幕左或上边缘
mouseIsOnEdge() {
  MouseGetPos &OutputVarX, &OutputVarY
  return (OutputVarX >= 0 and OutputVarX <= 2)
         or (OutputVarY >= 0 and OutputVarY <= 2)
}