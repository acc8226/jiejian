; 先构建 64 位
RunWait "C:\Users\ferder\AppData\Local\Programs\AutoHotkey\Compiler\Ahk2Exe.exe"
 . ' /in ' "shortcut.ahk"
 . ' /out ' "jiejian64.exe"
;  . ' /icon ' "favicon.ico"
 . ' /base ' "C:\Users\ferder\AppData\Local\Programs\AutoHotkey\v2\AutoHotkey64.exe"
 . ' /compress 2'

; 再构建 32 位
RunWait "C:\Users\ferder\AppData\Local\Programs\AutoHotkey\Compiler\Ahk2Exe.exe"
 . ' /in ' "shortcut.ahk"
 . ' /out ' "jiejian32.exe"
;  . ' /icon ' "favicon.ico"
 . ' /base ' "C:\Users\ferder\AppData\Local\Programs\AutoHotkey\v2\AutoHotkey32.exe"
 . ' /compress 2'

MsgBox '打包完成'
