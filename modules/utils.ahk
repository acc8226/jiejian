; 根据显示内容反向查询路径
appFindPathByListBoxText(title, type) {
    if (StrLen(title) > 0) {
        for (it in dataList)
            ; 两个条件的匹配更精确
            if (title = it.title and type = it.type)
                return it
    }
}

; 热键启动
startByHotKey(hotkey) {
    for (it in dataList) {
        if (it.hk == hotkey) {
            ; 如果是打开 web 或者 file 类型则会有友好提示
            if (it.type = DataType.web OR it.type = DataType.file) {
                Run it.path
                Tip("打开 " . it.title)
            } else if (it.type = DataType.app)
                ; 如果是 app 类型会频繁唤醒则不加提示
                ActivateOrRun(it.winTitle, it.path)
            break
        }
    }
}

; 热串启动
startByHotString(hotstring) {
    myHs := StrReplace(hotstring, ":C*:")
    for (it in dataList) {
        if (it.hs == myHs) {
            if (it.type = DataType.web) {
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
