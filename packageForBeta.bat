@REM author: kai
@REM updateDate: 2023-12-31

rd /S /Q out\jiejian-beta\
MKDIR out\jiejian-beta\extra\
xcopy /s  extra\       out\jiejian-beta\extra\
copy app.csv           out\jiejian-beta\
copy template\data.csv out\jiejian-beta\
copy *.url             out\jiejian-beta\
copy *.exe             out\jiejian-beta\
