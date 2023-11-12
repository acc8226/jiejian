CoordMode "Mouse", "Screen" ; 坐标相对于桌面(整个屏幕)

SetTimer WatchCursor, 150
WatchCursor() {
    title := WinGetTitle("A")
    class := WinGetClass("A") 
    pid := WinGetPID("A")  
    id := WinGetID("A")
    processName := WinGetProcessName("A")

    MouseGetPos &x, &y, &id, &control

    ToolTip
    (
        "title = " title
        "`nahk_class = " class
        "`nahk_exe = " processName
        "`nahk_pid = " pid
        "`nahk_id = " id

        "`n"
         
        "`nx " x 
        "`ny " y
        "`nid " id
        "`ncontrol " control
    )
}
