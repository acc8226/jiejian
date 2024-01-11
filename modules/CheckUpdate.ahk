doGet() {
    ; 随机弹出是否要升级的提示
    regKeyName := "HKEY_CURRENT_USER\SOFTWARE\jiejian"
    regValueName := "lastCheckDate"
    if DateDiff(A_NowUTC, RegRead(regKeyName, regValueName, 20000101000000), "days") > 0 {
        req := ComObject("Msxml2.XMLHTTP")
        ; 打开启用异步的请求.
        localIsAlphaOrBeta := InStr(CodeVersion, "alpha") or InStr(CodeVersion, "beta")
        if localIsAlphaOrBeta        
            req.open("GET", "https://raw.gitcode.com/acc8226/jiejian/raw/main/CURRENT_VERSION", true)
        else
            req.open("GET", "https://raw.gitcode.com/acc8226/jiejian/raw/main/RELEASE", true)            
        ; 设置回调函数.
        req.onreadystatechange := ready
        ; 发送请求. Ready() 将在其完成后被调用
        req.send()  

        ready() {
            if req.readyState != 4 ; 没有完成
                return
            if req.status == 200 {
                serverVersion := req.responseText
                RegWrite A_NowUTC, "REG_SZ", regKeyName, regValueName
                if (VerCompare(CodeVersion, serverVersion) < 0
                    and MsgBox("捷键 " CodeVersion " 非最新，去下载最新版 " serverVersion "？", "升级提醒", "YesNo") = "Yes")                
                    Run "https://gitcode.com/acc8226/jiejian/releases/"
            } else {
                if not A_IsCompiled
                    MsgBox "检测升级失败 " req.status,, 16
            }
        }
    }
}

doGet()
