checkUpdate(isNeedCallback := false) {
    regKeyName := "HKEY_CURRENT_USER\SOFTWARE\jiejian"
    regValueName := "lastCheckDate"
    localIsAlphaOrBeta := InStr(CodeVersion, "alpha") or InStr(CodeVersion, "beta")
    ; 检查更新时间为非调试阶段 或 检查间隔需大于 1 天
    if localIsAlphaOrBeta or DateDiff(A_NowUTC, RegRead(regKeyName, regValueName, 20000101000000), "days") > 0 {
        req := ComObject("Msxml2.XMLHTTP")
        ; 打开启用异步的请求.
        checkUrl := localIsAlphaOrBeta 
            ? "https://raw.gitcode.com/acc8226/jiejian/raw/main/CURRENT_VERSION" 
            : "https://raw.gitcode.com/acc8226/jiejian/raw/main/RELEASE"
        req.open("GET", checkUrl, true)

        ; 设置回调函数.
        req.onreadystatechange := ready
        ; 发送请求. Ready() 将在其完成后被调用
        req.send()  

        ready() {
            if req.readyState != 4 ; 没有完成
                return
            if req.status == 200 {
                serverVersion := req.responseText
                if not localIsAlphaOrBeta         
                    RegWrite A_NowUTC, "REG_SZ", regKeyName, regValueName
                if (VerCompare(CodeVersion, serverVersion) < 0
                    and MsgBox("捷键 " CodeVersion " 非最新，去下载最新版 " serverVersion "？", "检查更新", "YesNo") = "Yes")                
                    Run "https://gitcode.com/acc8226/jiejian/releases/"
                else {
                    if isNeedCallback
                        MsgBox "已是最新版本", '检查更新'
                }
            } else if req.status = 12007 {
                if isNeedCallback
                    MsgBox "请连接网络后重试", '检查更新'
                else
                    SetTimer checkUpdate, -25 * 60 * 60 ; 无网络则 25 分钟后重试
            } else                        
                MsgBox "检测升级失败 " req.status, "检查更新", 16
        }
    }
}

checkUpdate()
