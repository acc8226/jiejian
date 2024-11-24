MoveWindow() {
    MouseGetPos &EWD_MouseStartX, &EWD_MouseStartY, &EWD_MouseWin

    if !WinGetMinMax(EWD_MouseWin)  ; Only if the window isn't maximized 
        SetTimer EWD_WatchMouse, 30 ; Track the mouse as the user drags it.

    EWD_WatchMouse() {
        if !GetKeyState("LButton", "P")  ; Button has been released, so drag is complete.
        {
            SetTimer , 0
            return
        }
        ; Otherwise, reposition the window to match the change in mouse coordinates
        ; caused by the user having dragged the mouse:
        CoordMode "Mouse"
        MouseGetPos &EWD_MouseX, &EWD_MouseY
        WinGetPos &EWD_WinX, &EWD_WinY,,, EWD_MouseWin

        SetWinDelay 30   ; Makes the below move faster/smoother.
        WinMove EWD_WinX + EWD_MouseX - EWD_MouseStartX, EWD_WinY + EWD_MouseY - EWD_MouseStartY,,, EWD_MouseWin
        EWD_MouseStartX := EWD_MouseX  ; Update for the next timer-call to this subroutine.
        EWD_MouseStartY := EWD_MouseY
    }
}

MoveWindow2() {
    ; Get the initial mouse position and window id, and
    ; abort if the window is maximized.
    MouseGetPos &KDE_X1, &KDE_Y1, &KDE_id
    if WinGetMinMax(KDE_id)
        return
    ; Get the initial window position.
    WinGetPos &KDE_WinX1, &KDE_WinY1,,, KDE_id
    Loop {
        if !GetKeyState("LButton", "P") ; Break if button has been released.
            break
        MouseGetPos &KDE_X2, &KDE_Y2 ; Get the current mouse position.
        KDE_X2 -= KDE_X1 ; Obtain an offset from the initial mouse position.
        KDE_Y2 -= KDE_Y1
        KDE_WinX2 := (KDE_WinX1 + KDE_X2) ; Apply this offset to the window position.
        KDE_WinY2 := (KDE_WinY1 + KDE_Y2)
        WinMove KDE_WinX2, KDE_WinY2,,, KDE_id ; Move the window to the new position.
    }
}

resizeWindow() {
    ; Get the initial mouse position and window id, and
    ; abort if the window is maximized.
    MouseGetPos &KDE_X1, &KDE_Y1, &KDE_id
    if WinGetMinMax(KDE_id)
        return
    ; Get the initial window position and size.
    WinGetPos &KDE_WinX1, &KDE_WinY1, &KDE_WinW, &KDE_WinH, KDE_id

    ; Define the window region the mouse is currently in.
    ; The four regions are Up and Left, Up and Right, Down and Left, Down and Right.
    if (KDE_X1 < KDE_WinX1 + KDE_WinW / 2)
        KDE_WinLeft := 1
    else
        KDE_WinLeft := -1
    if (KDE_Y1 < KDE_WinY1 + KDE_WinH / 2)
        KDE_WinUp := 1
    else
        KDE_WinUp := -1

    Loop {
        if !GetKeyState("RButton", "P") ; Break if button has been released.
            break
        ; 不断获得当前的鼠标位置 和 屏幕位置
        MouseGetPos &KDE_X2, &KDE_Y2 ; Get the current mouse position.
        ; Get the current window position and size.
        WinGetPos &KDE_WinX1, &KDE_WinY1, &KDE_WinW, &KDE_WinH, KDE_id

        KDE_X2 -= KDE_X1 ; Obtain an offset from the initial mouse position.
        KDE_Y2 -= KDE_Y1

        ; 设定最小位移
        if Abs(KDE_X2) < 20 and Abs(KDE_Y2) < 20
            continue
        ; 如果横向位移 小于 纵向位移，则忽略横向位移
        if (Abs(KDE_X2) < Abs(KDE_Y2)) {
            KDE_X2 := 0
        } else {
            KDE_Y2 := 0
        }

        ; Then, act according to the defined region.
        WinMove KDE_WinX1 + KDE_X2 * (KDE_WinLeft + 1) / 2 ; X of resized window
              , KDE_WinY1 + KDE_Y2 * (KDE_WinUp + 1) / 2   ; Y of resized window
              , KDE_WinW  - KDE_X2 *        KDE_WinLeft    ; W of resized window
              , KDE_WinH  - KDE_Y2 *           KDE_WinUp   ; H of resized window
              , KDE_id
        KDE_X1 := (KDE_X2 + KDE_X1) ; Reset the initial position for the next iteration.
        KDE_Y1 := (KDE_Y2 + KDE_Y1)
    }
}
