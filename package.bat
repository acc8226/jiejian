@REM author: kai
@REM updateDate: 2023-12
@REM 新建文件夹 拷贝鼠标手势 拷贝两个表格 拷贝主程序

rd /S /Q out
mkdir out
mkdir out\extra
copy "extra\WGestures 1.8.5.0.wgb" out\extra\
copy "extra\WGestures 2.9.1.wg28bw" out\extra\
copy app.csv             out\
copy template\data.csv   out\
copy favicon.ico         out\
copy index.html          out\README.html
copy shortcut.exe        out\
