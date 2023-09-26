CoordMode "Mouse", "Screen" ; 坐标相对于桌面(整个屏幕)

SetTimer WatchCursor, 150
WatchCursor() {
    MouseGetPos &x, &y, &id, &control
    ToolTip
    (
        "x " x 
        "`ny " y
        "`nid " id
        "`ncontrol " control
    )
}
