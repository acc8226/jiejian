checkUpdate(isNeedCallback := False) {
    localIsAlphaOrBeta := InStr(CODE_VERSION, "alpha") || InStr(CODE_VERSION, "beta")
    regValueName := 'last_check_date'
    ; 手动检查更新 或 本地为调试版本 或 正式版的检查间隔需大于 24 小时
    if (isNeedCallback || localIsAlphaOrBeta || DateDiff(A_NowUTC, RegRead(REG_KEY_NAME, regValueName, '20000101000000'), "days") >= 1) {
        req := ComObject("Msxml2.XMLHTTP")
        ; 打开启用异步的请求.
        checkUrl := 'https://acc8226.atomgit.net/jiejian/' . (localIsAlphaOrBeta ? "SNAPSHOT" : "RELEASE")
        req.open("GET", checkUrl, true)

        ; 设置回调函数
        req.onreadystatechange := ready
        ; 发送请求 Ready() 将在其完成后被调用
        req.send()

        ready() {
            if (req.readyState != 4) ; 没有完成
                return
            if (req.status == 200) {
                serverVersion := req.responseText
                ; 正式版需要写入当前日期信息
                if (not localIsAlphaOrBeta)
                    RegWrite(A_NowUTC, "REG_SZ", REG_KEY_NAME, regValueName)
                if VerCompare(CODE_VERSION, serverVersion) < 0 {
                    if MsgBox("捷键 " CODE_VERSION " 非最新，去下载最新版 " serverVersion "？", "检查更新", "YesNo") = "Yes"
                        Run('https://gitcode.com/acc8226/jiejian/releases/')
                } else if (isNeedCallback)
                    MsgBox('当前已是最新版本', '检查更新-捷键')
            } else if (isNeedCallback) {
                ; 0 表示安全证书的吊销信息不可用， 12007 表示没有网
                if (req.status = 0 || req.status = 12007) {
                    MsgBox("请连接网络后重试", '检查更新-捷键')
                    SetTimer(checkUpdate, -60 * 60 * 1000) ; 无网络则 60 分钟后重试
                } else if (req.status = 404)
                    MsgBox('升级页面找不到', '检查更新-捷键')
                else if (req.status = 12029)
                    MsgBox("网络连接错误，请稍候再试", '检查更新-捷键')
                else
                    MsgBox('检测升级失败，错误码为 ' . req.status . '，请稍候再试', '检查更新-捷键')
            }
        }
    }
}