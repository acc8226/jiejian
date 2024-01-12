Ahk2Exe := "C:\Users\ferder\AppData\Local\Programs\AutoHotkey\Compiler\Ahk2Exe.exe"
jiejian := "jiejian"
jiejianAhk := jiejian ".ahk"
base := "C:\Users\ferder\AppData\Local\Programs\AutoHotkey\v2\AutoHotkey"

; 先构建 64 位
RunWait Ahk2Exe
 . ' /in ' jiejianAhk
 . ' /out ' jiejian "64.exe"
;  . ' /icon ' "favicon.ico"
 . ' /base ' base "64.exe"
 . ' /compress 2'

; 再构建 32 位
RunWait Ahk2Exe
 . ' /in ' jiejianAhk
 . ' /out ' jiejian "32.exe"
;  . ' /icon ' "favicon.ico"
 . ' /base ' base "32.exe"
 . ' /compress 2'

MsgBox '打包完成'
