@REM author: kai
@REM updateDate: 2023-12-31

rd /S /Q out
mkdir out
mkdir out\extra
copy extra\*           out\extra\
copy app.csv           out\
copy template\data.csv out\
copy favicon.ico       out\
copy *.pdf             out\
copy shortcut.exe      out\
