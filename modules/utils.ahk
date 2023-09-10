; 鼠标移动到屏幕左或上边缘 或 任务栏上
mouseIsOverTaskBarOrEdge() {
    MouseGetPos &OutputVarX, &OutputVarY, &Win
    return OutputVarX == 0 or OutputVarX == 1 or OutputVarX == 2
           or OutputVarY == 0 or OutputVarY == 1 or OutputVarY == 2
           or WinExist("ahk_class Shell_TrayWnd" " ahk_id " Win)
}

findPathByHk(appList, hk) {
    for value in appList {
        if value.hk == hk
            return value.path
    }
}

; 根据 title 添加 “-类型” 的后缀
quickTitle(value) {
    return  value.title "-" value.type
}

; 根据显示内容反向查询路径
appFindPathByListBoxText(appList, listBoxText) {
    if StrLen(listBoxText) > 0 {
        split := StrSplit(listBoxText, '-')
        if split.Length == 2 {
            type := split[2]
            if type == 'app' or type == 'web' {
                title := split[1]
                for value in appList {
                    if StrLen(value.title) > 0 and title == value.title and type == value.type                            
                        return value.path                    
                }
            }
        }
    }
}

webFindPathByHs(appList, hs) {
    for value in appList {
        if value.type == 'web' and value.hs == hs
            return value.path
    }
}

; 复杂启动
appStartByHk(hk) {
    for value in appList {
        if value.hk == hk {
            if value.type == 'web' or value.type == 'file' {
                Run value.path
            } else if value.type == 'app' {
                ; 如果未启动则启动,否则激活
                if WinExist("ahk_exe " value.path)

                    WinActivate
                else Run value.path
            }
            return
        }            
    }
}

; 获取屏幕高度
;ScreenHeight := A_ScreenHeight
; 获取任务栏高度
;WinGetPos , , , &TaskbarHeight, "ahk_class Shell_TrayWnd"
