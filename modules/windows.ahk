!x::{
    WinGetPos ,, &Width, &Height, "A"
    WinMove 0, 0, A_ScreenWidth/2,A_ScreenHeight/2,  "A"
}

!y::{
    WinGetPos ,, &Width, &Height, "A"
    WinMove  A_ScreenWidth/2, 0, A_ScreenWidth/2,A_ScreenHeight/2,  "A"
}

; 判断当前光标是否在 edit 控件上
!z::{
    FocusedHwnd := ControlGetFocus("A")
    FocusedClassNN := ControlGetClassNN(FocusedHwnd)
    MsgBox 'Control with focus = {Hwnd: ' FocusedHwnd ', ClassNN: "' FocusedClassNN '"}'
}
