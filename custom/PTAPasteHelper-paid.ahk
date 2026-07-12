#Requires AutoHotkey v2.0
#SingleInstance

; ---------- 密钥（只有你知道，绝对保密） ----------
global SECRET_KEY := "MySuperSecret2025!@#"

; ---------- MD5 哈希函数（用 Windows API） ----------
MD5(data) {
    dataBytes := Buffer(StrPut(data, "UTF-8") - 1)
    StrPut(data, dataBytes, "UTF-8")
    hProv := 0
    if !DllCall("advapi32\CryptAcquireContext", "Ptr*", &hProv, "Ptr", 0, "Ptr", 0, "UInt", 1, "UInt", 0xF0000000)
        throw OSError()
    hHash := 0
    if !DllCall("advapi32\CryptCreateHash", "Ptr", hProv, "UInt", 0x8003, "Ptr", 0, "UInt", 0, "Ptr*", &hHash)
        throw OSError()
    if !DllCall("advapi32\CryptHashData", "Ptr", hHash, "Ptr", dataBytes, "UInt", dataBytes.Size, "UInt", 0)
        throw OSError()
    hashBytes := Buffer(16, 0)
    size := 16
    if !DllCall("advapi32\CryptGetHashParam", "Ptr", hHash, "UInt", 2, "Ptr", hashBytes, "UInt*", &size, "UInt", 0)
        throw OSError()
    DllCall("advapi32\CryptDestroyHash", "Ptr", hHash)
    DllCall("advapi32\CryptReleaseContext", "Ptr", hProv, "UInt", 0)
    hex := ""
    Loop 16
        hex .= Format("{:02x}", NumGet(hashBytes, A_Index - 1, "UChar"))
    return SubStr(StrUpper(hex), 1, 16)
}

GenerateActivationCode(machineCode) {
    return MD5(machineCode . SECRET_KEY)
}

; ---------- 机器码获取（不变） ----------
GetMachineCode() {
    try {
        wmi := ComObject("WbemScripting.SWbemLocator").ConnectServer(".")
        items := wmi.ExecQuery("SELECT SerialNumber FROM Win32_DiskDrive")
        for item in items
            if (serial := Trim(item.SerialNumber)) != ""
                return serial
    }
    try {
        wmi := ComObject("WbemScripting.SWbemLocator").ConnectServer(".")
        items := wmi.ExecQuery("SELECT MACAddress FROM Win32_NetworkAdapterConfiguration WHERE IPEnabled=True")
        for item in items
            if (mac := Trim(item.MACAddress)) != ""
                return StrReplace(mac, ":")
    }
    return ""
}

; ---------- 激活状态检查 ----------
IsActivated() {
    savedCode := RegRead("HKEY_CURRENT_USER\Software\PTAPasteHelper", "ActivationCode", "")
    if savedCode == ""
        return false
    machineCode := GetMachineCode()
    if machineCode == ""
        return false
    correctCode := GenerateActivationCode(machineCode)
    return (savedCode == correctCode)
}

; ---------- 主入口 ----------
if !IsActivated() {
    machineCode := GetMachineCode()
    if machineCode == "" {
        MsgBox("无法获取硬件信息，请右键以管理员身份运行。", "错误", 16)
        ExitApp()
    }

    ; ---------- 显示机器码并让用户复制 ----------
    myGui := Gui()
    myGui.Title := "机器码获取"
    myGui.Add("Text", "w300", "请将下面的机器码发给作者获取激活码：")
    myGui.Add("Edit", "w300 ReadOnly", machineCode)   ; 只读显示
    copyBtn := myGui.Add("Button", "w100", "复制机器码")
    copyBtn.OnEvent("Click", (*) => (A_Clipboard := machineCode, MsgBox("已复制到剪贴板！", "提示", 64)))
    myGui.Add("Button", "w100 x+m", "下一步继续").OnEvent("Click", (*) => myGui.Destroy())
    myGui.Show()
    ; 等待窗口关闭（不依赖于 WaitClose 或 Wait 选项）
	WinWaitClose("机器码获取")   ; 等待标题为“机器码获取”的窗口关闭

    ; ---------- 输入激活码 ----------
    inputCode := InputBox(
        "请粘贴作者回复的激活码：",
        "软件激活",
        "h120",
        ""
    )
    if inputCode.Result != "OK"
        ExitApp()

    correctCode := GenerateActivationCode(machineCode)
    if inputCode.Value != correctCode {
        MsgBox("激活码错误！", "错误", 16)
        ExitApp()
    }
	RegWrite(inputCode.Value, "REG_SZ", "HKCU\Software\PTAPasteHelper", "ActivationCode")
    MsgBox("激活成功！", "提示", 64)
}

; ---------- 你的主功能（MButton 热键等） ----------
MButton::{
    KeyWait("Shift")
    KeyWait("Alt")

    text := A_Clipboard
    if (text = "")
        return

    Loop Parse, text, "`n", "`r"
    {
        if (A_Index > 1)
            Send("{Enter}")

        ; 清除每行开头空格/Tab，避免和编辑器自动缩进叠加偏右
        currentLine := LTrim(A_LoopField, A_Space A_Tab)

        Loop Parse, currentLine
        {
            c := A_LoopField
            SendText(c)
            
            if c == "{" {
                Sleep(80)        ; 等待网页完成自动补全{}
                Send("{Delete}") ; 删除光标右侧自动多出的 }
            }
            Sleep(Random(20, 27))
        }
    }
}
