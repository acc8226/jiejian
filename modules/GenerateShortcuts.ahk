﻿#Requires AutoHotkey v2.0
#SingleInstance Force
#NoTrayIcon

SetWorkingDir(A_ScriptDir . "\..")

; 注：每次更新代码后需要覆盖 extra 下的 GenerateShortcuts.exe

; 由于 windows 系统不允许存在同名文件和文件夹，故预先删除之
try FileDelete "shortcuts"
try DirDelete "shortcuts", true
; 休息 0.05 s，防止 delete 操作未完成引起的 shortcuts 目录被占用问题
Sleep 50
try DirCreate "shortcuts"

; 排除特定的快捷方式
; 不能包含特定关键字
useless := "i)uninstall|卸载|help|iSCSI 发起程序|ODBC 数据源|Data Sources \(ODBC\)"
. "|ODBC Data|Windows 内存诊断|恢复驱动器|组件服务|碎片整理和优化驱动器|Office 语言首选项"
. "|手册|更新|帮助|Tools Command Prompt for|license|Website|设置向导|More Games from Microsoft"
. "|细胞词库|意见反馈|输入法管理器|输入法修复器|皮肤下载|官方网站| 网站|火绒日志"
. "|Welcome Center|\(安全模式\)|on the Web"
; 不能以 开头
. "|^(?:Windows Easy Transfer Reports|皮肤盒子|打字入门"
. "|Microsoft Office 文档关联中心|Internet Explorer \(No Add-ons\)|Windows Easy Transfer Reports"
. "|Microsoft Office 2007 控制中心|Microsoft Office 语言设置|iSCSI Initiator"
. "|Add to archive|Backup and Restore Center|Configure PeaZip|Extract here|网页按键精灵|遥测日志|遥测仪表板"
. ")"
; 不能是
. "|^(?:"
Loop Files A_StartupCommon . "\*.lnk*"
    useless .= "|" . A_LoopFileName
Loop Files A_Startup . "\*.lnk*"
    useless .= "|" . A_LoopFileName
useless .= ')$'

; 把开始菜单中的快捷方式都拷贝到 shortcuts 目录 
CopyFiles(A_ProgramsCommon "\*.lnk", "shortcuts\", useless)
CopyFiles(A_Programs "\*.lnk", "shortcuts\", useless)
; 然后再生成 UWP 相关的快捷方式
oFolder := ComObject("Shell.Application").NameSpace("shell:AppsFolder")
if Type(oFolder) = 'ComObject'
    for item in oFolder.Items
        if NOT(FileExist("shortcuts\" item.Name ".lnk") || item.Name . '.lnk' ~= useless)
            try FileCreateShortcut("shell:appsfolder\" item.Path, "shortcuts\" item.Name ".lnk")

CopyFiles(pattern, dest, ignore := "") {
    Loop Files pattern, "R" {
      if A_LoopFileName ~= ignore
        continue
      try FileCopy(A_LoopFilePath, dest, true)
    }
}
  