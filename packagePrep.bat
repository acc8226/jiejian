@REM author: acc8226
@REM updateDate: 2023
@REM 需要一个入参哦，不能直接调用，而是被 jiejianPostExec.ahk 调用

ECHO %1
RD /S /Q out\%1\
MKDIR out\%1\extra\
MKDIR out\%1\custom\
XCOPY extra            out\%1\extra\ /S
XCOPY custom           out\%1\custom\ /S
COPY app.csv           out\%1\
COPY template\data.csv out\%1\
COPY jiejian32.exe     out\%1\
COPY jiejian64.exe     out\%1\