@REM 新建文件夹 拷贝鼠标手势 拷贝两个表格 拷贝主程序 压缩
rd /S /Q out
mkdir out
mkdir out\extra
copy app.csv           out\
copy favicon.ico       out\
copy shortcut.exe      out\
copy template\data.csv out\
copy template\README.pdf out\
copy "extra\WGestures 1.8.5.0.wgb" out\extra\
