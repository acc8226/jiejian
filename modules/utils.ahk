; 根据显示内容反向查询路径
appFindPathByListBoxText(title, type) {
    if StrLen(title) > 0 {
        for it in dataList {
            ; 两个条件的匹配更精确
            if title = it.title and type = it.type
                return it
        }
    }
}

; 热键启动
startByHotKey(hotkey) {
    for it in dataList {
        if it.hk == hotkey {
            if it.type = 'web' or it.type = 'file' {
                Run it.path
                Tip("打开 " . it.title)
            } else if it.type = 'app' {
                ActivateOrRun(it.winTitle, it.path)
            }
            break
        }
    }
}

; 热串启动
startByHotString(hotstring) {
    myHs := StrReplace(hotstring, ":C*:")
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
