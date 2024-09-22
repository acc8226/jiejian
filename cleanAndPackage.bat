@REM author: kai
@REM updateDate: 2023-12-31
@REM 双击即可打包，可以直接调用

DEL /Q jiejian32.ExE jiejian64.Exe
RMDIR /S /Q out\
compiler\AutoHotkey32.exe package\package.ahk
