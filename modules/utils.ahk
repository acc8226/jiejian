; 根据 title 添加 “-类型” 的后缀
quickTitle(value) {
    return value.title "-" value.type
}

; 根据显示内容反向查询路径
appFindPathByListBoxText(dataList, listBoxText) {
    if StrLen(listBoxText) > 0 {
        split := StrSplit(listBoxText, '-')
        if split.Length == 2 {
            type := split[2]
            if type = 'app' or type = 'web' {
                title := split[1]
                if StrLen(title) > 0 {
                    for it in dataList {
                        if title = it.title and type = it.type
                            return it
                    }
                }
            }
        }
    }
}

; 热键启动
startByHotKey(hk) {
    for it in dataList {
        if it.hk == hk {
            if it.type = 'web' or it.type = 'file' {
                Run it.path
                Tip("打开 " . it.title)
            } else if it.type = 'app' {
                ActivateOrRun(it.winTitle, it.path)
                ; ; 如果未启动则启动,否则激活
                ; if WinExist("ahk_exe " it.path)
                ;     WinActivate
                ; else {
                ;     try {
                ;         Run it.path
                ;         Tip("打开 " . it.title)
                ;     } catch {
                ;         MsgBox "程序启动失败，请确认 " it.path " 是否存在？"
                ;     }
                ; }
            }
            break
        }
    }
}

; 热串启动
startByHotString(hs) {
    myHs := StrReplace(hs, ":C*:")
    for it in dataList {
        if it.hs == myHs {
            if it.type = 'web' {
                Run it.path
                Tip("打开 " . it.title)
            }
            break
        }
    }
}

; 获取屏幕高度
;ScreenHeight := A_ScreenHeight
; 获取任务栏高度
;WinGetPos , , , &TaskbarHeight, "ahk_class Shell_TrayWnd"
