; 写入版本信息
if (A_Args.Length = 0) {
    MsgBox '写入版本信息失败，参数个数为 0'
    return
}
version := A_Args[1]
localIsAlphaOrBeta := InStr(version, "alpha") or InStr(version, "beta")
fileObj := localIsAlphaOrBeta ? FileOpen("SNAPSHOT", "w") : FileOpen("RELEASE", "w")
fileObj.Write(version)
fileObj.Close()

; 拷贝文件 + 并最终生成在 out 目录下生成 jiejian-版本 的文件夹
Run A_ComSpec  " /c CopyFilesForPackage.bat jiejian-" version, , "Min"
