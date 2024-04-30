/**
 * 智能的关闭窗口
 */
smartCloseWindow() {
  if WinExist('A') {
    if IsDesktop()
      return
    if (WinGetClass("A") == "ApplicationFrameWindow" || GetProcessName() == "explorer.exe")
      Send "!{F4}"
    else
      PostMessage(0x112, 0xF060, , , "A")
  } else {
    MsgBox '无活动窗口，2 秒后弹窗自动关闭后请重试', , 'T2'
  }
}

/**
 * 启动程序或切换到程序
 * @param {string} winTitle AHK 中的 WinTitle
 * 
 * @param {string} target 程序的路径
 * @param {string} args 参数
 * @param {string} workingDir 工作文件夹
 * @param {bool} admin 是否为管理员启动
 * @param {bool} isHide 窗口是否为隐藏窗口
 * @returns {void} 
 */
ActivateOrRun(winTitle := "", target := "", args := "", workingDir := "", admin := false, isHide := false, runInBackground := false) {
  ; 如果是程序或参数中带有“选中的文件” 则通过该程序打开该连接
  if (InStr(target, "{selected}") || InStr(args, "{selected}")) {
    ; 没有获取到文字直接返回
    if not (ReplaceSelectedText(&target, &args))
      return
  }

  ; 切换程序
  winTitle := Trim(winTitle)
  if (winTitle && activateWindow(winTitle, isHide))
    return

  ; 程序没有运行，运行程序
  workingDir := workingDir ? workingDir : A_WorkingDir
  RunPrograms(target, args, workingDir, admin, runInBackground)
}

/**
 * 窗口置顶
 */
ToggleWindowTopMost() {
  value := !(WinGetExStyle("A") & 0x8)
  WinSetAlwaysOnTop(value, "A")
  if value {
    Tip("已置顶当前窗口")
  } else {
    Tip("取消置顶")
  }
}

; 关闭显示器:
SystemSleepScreen() {
  Sleep 1000  ; 让用户有机会释放按键(以防释放它们时再次唤醒显视器).
  ; 关闭显示器:
  SendMessage 0x0112, 0xF170, 2,, "Program Manager"  ; 0x0112 is WM_SYSCOMMAND, 0xF170 is SC_MONITORPOWER.
}

/**
 * 锁屏
 */
SystemLockScreen() {
  Sleep 300
  DllCall("LockWorkStation")
}

/**
 * 注销
 */
 SystemLogoff() {
  Shutdown(0)
}

/**
 * 关机
 */
 SystemShutdown() {
  ; 如果存在 SlideToShutDown.exe 则使用滑动关机，否则使用普通关机
  if FileExist(A_WinDir "\System32\SlideToShutDown.exe") {
    Run("SlideToShutDown.exe")
    sleep(1300)
    CoordMode("Mouse", "Screen")
    MouseClick("Left", 100, 100)
  } else {
    Shutdown(1)
  }
}

/**
 * 重启
 */
 SystemReboot() {
  Shutdown(2)
}

/**
 * 睡眠
 */
SystemSleep() {
  ; 调用 Windows API 函数 "SetSuspendState" 来让系统挂起或休眠. 注意, 第二个参数对较新的系统可能没有任何影响
  ; 参数 #1: 使用 1 代替 0 来进行休眠而不是挂起
  ; 参数 #2: 使用 1 代替 0 来立即挂起而不询问每个应用程序以获得许可
  ; 参数 #3: 使用 1 而不是 0 来禁止所有的唤醒事件
  DllCall("PowrProf\SetSuspendState", "Int", 0, "Int", 0, "Int", 0)
}

copySelectedAsPlainText() {
  A_Clipboard := ""
  Send "^c"
  if !ClipWait(1) {
    Tip("复制失败")
    return
  }
  A_Clipboard := A_Clipboard
  Tip("路径已复制")
}

copySelectedAsPlainTextQuiet() {
  A_Clipboard := ""
  Send "^c"
  if !ClipWait(1) {
    Tip("复制失败")
    return
  }
  A_Clipboard := A_Clipboard
}

/**
 * 窗口最大化
 */
MaximizeWindow() {
  if NotActiveWin()
    return

  if WindowMaxOrMin() {
    WinRestore("A")
  } else {
    WinMaximize("A")
  }
}

/**
 * 窗口最小化
 */
minimizeWindow() {
  if (NotActiveWin() || WinGetProcessName("A") == "Rainmeter.exe")
    return

  WinMinimize("A")
}

/**
 * 移动活动窗口位置
 */
makeWindowDraggable() {
  hwnd := WinExist("A")
  if (WindowMaxOrMin())
    WinRestore("A")

  PostMessage("0x0112", "0xF010", 0)
  Sleep 50
  SendInput("{Right}")
}
