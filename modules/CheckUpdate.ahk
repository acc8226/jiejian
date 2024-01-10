doGet() {
    req := ComObject("Msxml2.XMLHTTP")
    ; 打开启用异步的请求.
    req.open("GET", "https://raw.gitcode.com/acc8226/jiejian/raw/main/version.txt", true)
    ; 设置回调函数.
    req.onreadystatechange := Ready
    ; 发送请求. Ready() 将在其完成后被调用.
    req.send()
    /*
    ; 如果你要一直等待到下载完毕, 就不需要 onreadystatechange 了.
    ; 设置 async=true 和像这样等待, 可以在下载过程中允许脚本保留响应
    ; 而 async=false 将使脚本无响应.
    while req.readyState != 4
        sleep 100
    */
    Ready() {
        if (req.readyState != 4)  ; 没有完成
            return
        if (req.status == 200) {
            serverVersion := req.responseText
            if VerCompare(CodeVersion, serverVersion) < 0 {
                if MsgBox("当前版本 " CodeVersion " 不是最新，是否升级到 " serverVersion, "升级提醒", "YesNo") = "Yes"
                    Run "https://gitcode.com/acc8226/jiejian/releases/"
            }
        }
        else
            MsgBox "检测升级失败 " req.status,, 16
    }
}

doGet()
