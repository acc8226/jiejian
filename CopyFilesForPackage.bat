@REM author: kai
@REM updateDate: 2023-12-31
@REM 需要一个入参哦，不能直接调用，而是被 jiejianPostExec.ahk 调用

echo %1
rd /S /Q out\%1\
MKDIR out\%1\extra\
xcopy /s  extra        out\%1\extra\
copy app.csv           out\%1\
copy template\data.csv out\%1\
copy *.url             out\%1\
copy jiejian3*.exe     out\%1\
copy jiejian6*.exe     out\%1\
