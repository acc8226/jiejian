; 写入版本信息
if (A_Args.Length = 0) {
    MsgBox '写入版本信息失败，参数个数为 0'
    return
}

version := A_Args[1]
localIsAlphaOrBeta := InStr(version, "alpha") || InStr(version, "beta")
fileObj := FileOpen(localIsAlphaOrBeta ? 'SNAPSHOT' : 'RELEASE', "w")
fileObj.Write(version)
fileObj.Close()

; 拷贝文件 + 并最终生成在 out 目录下生成 jiejian-版本 的文件夹
RunWait("CopyFilesForPackage.bat jiejian-" . version, , "Hide")
; 使用 7z 进行压缩
RunWait('..\package\7z2404-extra\7za.exe a jiejian-' . version . '.7z jiejian-' . version, 'out', "Hide")
