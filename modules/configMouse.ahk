#HotIf mouseIsOnTaskBarOrEdge()
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
