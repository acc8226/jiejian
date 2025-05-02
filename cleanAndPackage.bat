@REM author acc8226
@REM updateDate: 2025
@REM 双击即可打包，可以直接调用

RMDIR /S /Q out\
compiler\AutoHotkey32.exe package\Package.ahk

@REM 清理现场
DEL /Q jiejian32.exe jiejian64.exe
