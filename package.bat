@REM author: kai
@REM updateDate: 2023-12-31
@REM 需要一个入参哦，一般不直接调用，而是被 package.ahk 调用

echo %1
rd /S /Q out\%1\
MKDIR out\%1\extra\
xcopy /s  extra\       out\%1\extra\
copy app.csv           out\%1\
copy template\data.csv out\%1\
copy *.url             out\%1\
copy *.exe             out\%1\
