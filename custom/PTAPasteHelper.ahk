#Requires AutoHotkey v2.0
#SingleInstance

; ---------- 你的主功能（MButton 热键等） ----------
MButton::{
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
