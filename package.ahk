Ahk2Exe := ".\Compiler\Ahk2Exe.exe"
jiejian := "jiejian"
jiejianAhk := jiejian ".ahk"
base := ".\exe\"

; 先构建 64 位
RunWait Ahk2Exe
 . ' /in ' . jiejianAhk
 . ' /out ' . jiejian . "64.exe"
 . ' /base ' . base . "AutoHotkey64V2.0.11.exe"
 . ' /compress 2'

; 再构建 32 位
RunWait Ahk2Exe
 . ' /in ' . jiejianAhk
 . ' /out ' . jiejian . "32.exe"
 . ' /base ' . base . "AutoHotkey32V2.0.11.exe"
 . ' /compress 2'

MsgBox '打包完成'
