@REM author: kai
@REM updateDate: 2023-12-31
@REM 需要一个入参哦，不能直接调用，而是被 jiejianPostExec.ahk 调用

echo %1
rd /S /Q out\%1\
MKDIR out\%1\extra\
MKDIR out\%1\custom\
XCOPY extra            out\%1\extra\ /S
XCOPY custom           out\%1\custom\ /S
copy app.csv           out\%1\
copy template\data.csv out\%1\
move jiejian32.exe out\%1\
move jiejian64.exe out\%1\
