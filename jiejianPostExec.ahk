; 写入版本信息
version := A_Args[1]
localIsAlphaOrBeta := InStr(version, "alpha") or InStr(version, "beta")
fileObj := localIsAlphaOrBeta ? FileOpen("SNAPSHOT", "w") : FileOpen("RELEASE", "w")
fileObj.Write(version)
fileObj.Close()

; 文件夹命名为 jiejian-版本
Run A_ComSpec  " /c package.bat jiejian-" version, , "Min"

