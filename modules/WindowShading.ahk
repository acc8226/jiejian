﻿; Window Shading (based on the v1 script by Rajat)
; https://www.autohotkey.com
; This script reduces a window to its title bar and then back to its
; original size by pressing a single hotkey.  Any number of windows
; can be reduced in this fashion (the script remembers each).  If the
; script exits for any reason, all "rolled up" windows will be
; automatically restored to their original heights.

global shadingWinMap := Map()

shadingWindows() {
    ; Uncomment this next line if this subroutine is to be converted
    ; into a custom menu item rather than a hotkey. The delay allows
    ; the active window that was deactivated by the displayed menu to
    ; become active again:
    ;Sleep 200
    ActiveID := WinGetID("A")
    Height := shadingWinMap.Get(ActiveID, false)
    if (Height) {
        WinMove ,,, Height, ActiveID
        shadingWinMap.Delete(ActiveID)
    } else {
        WinGetPos ,,, &Height, "A"
        WinMove ,,, 25, ActiveID    
        shadingWinMap[ActiveID] := Height
    }
}

restoreWindows() {
    for ID, Height in shadingWinMap {
        WinMove ,,, Height, ID
    }
}