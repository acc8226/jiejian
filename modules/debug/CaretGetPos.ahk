SetTimer WatchCaret, 150
; 查看光标是否在编辑框上
WatchCaret() {
    if CaretGetPos(&x, &y)
        ToolTip "X" x " Y" y, x, y - 20
    else
        ToolTip "No caret"
}
