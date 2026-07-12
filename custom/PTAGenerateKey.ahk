#Requires AutoHotkey v2.0
#SingleInstance

SECRET_KEY := "MySuperSecret2025!@#"

; ---------- MD5 哈希函数 ----------
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

; ---------- 获取本机机器码（复用用户端函数） ----------
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

; ---------- 主程序 ----------
; 获取本机机器码作为默认值
defaultCode := GetMachineCode()
if defaultCode == ""
    defaultCode := ""   ; 如果获取失败，默认留空

userInput := InputBox(
    "请粘贴用户发来的机器码（默认已填入本机机器码，可修改）：",
    "作者工具 - 生成激活码",
    "w350",
    defaultCode,        ; 第四个参数：默认值
)
if userInput.Result != "OK"
    ExitApp()

machineCode := Trim(userInput.Value)
if machineCode == "" {
    MsgBox("机器码不能为空！", "错误", 16)
    ExitApp()
}

activationCode := GenerateActivationCode(machineCode)
A_Clipboard := activationCode

MsgBox("激活码已复制到剪贴板！`n`n机器码：`n" machineCode "`n`n激活码：`n" activationCode, "生成成功", 64)
