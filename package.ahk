base := ".\compiler\"
Ahk2Exe := base . "Ahk2Exe.exe"

jiejian := "jiejian"
jiejianAhk := jiejian ".ahk"

aAutoHotkey := "AutoHotkey"
a64exe := "64.exe"
a32exe := "32.exe"

; 先构建 64 位
if A_Is64bitOS {
    RunWait Ahk2Exe
     . ' /in ' . jiejianAhk
     . ' /out ' . jiejian . a64exe
     . ' /base ' . base . aAutoHotkey . a64exe
     . ' /compress 2'
}

; 再构建 32 位
RunWait Ahk2Exe
 . ' /in ' . jiejianAhk
 . ' /out ' . jiejian . a32exe
 . ' /base ' . base . aAutoHotkey . a32exe
 . ' /compress 2'

MsgBox '打包完成'
