@REM author: kai
@REM updateDate: 2023-12-31

rd /S /Q out
MKDIR out\shortcut\extra\
xcopy /s  extra\       out\shortcut\extra\
copy app.csv           out\shortcut\
copy template\data.csv out\shortcut\
copy favicon.ico       out\shortcut\
copy *.url             out\shortcut\
copy shortcut.exe      out\shortcut\shortcut64.exe
