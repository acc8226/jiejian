@REM author: kai
@REM updateDate: 2023-12-31

rd /S /Q out\jiejian\
MKDIR out\jiejian\extra\
xcopy /s  extra\       out\jiejian\extra\
copy app.csv           out\jiejian\
copy template\data.csv out\jiejian\
copy *.url             out\jiejian\
copy *.exe             out\jiejian\
