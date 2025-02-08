; XOR 加密/解密函数
XOR_Crypt(str, key := "li") {
    encrypted := ""
    Loop Parse str {
        keyIndex := Mod(A_Index, StrLen(key)) + 1
        keyChar := SubStr(key, keyIndex, 1)
        encrypted .= Chr(Ord(A_LoopField) ^ Ord(keyChar))
    }
    return encrypted
}

IS_Crypt_String(originalStr) {
    return SubStr(originalStr, 1, 1) = "密"
}

; ; 加密
; originalStr := "1334598467"
; encryptedStr := '密' . XOR_Crypt(originalStr)
; MsgBox "加密后的字符串（可能不可见）:`n" encryptedStr
; A_Clipboard :=  encryptedStr

; ; 解密
; decryptedStr := XOR_Crypt(SubStr(encryptedStr, 2))
; MsgBox "解密后的字符串:`n" decryptedStr
