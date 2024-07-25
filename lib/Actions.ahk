/**
 * 智能的关闭窗口，如果是桌面就 alt +f4
 */
smartCloseWindow() {
  if (WinExist('A')) {
    if (IsDesktop() or (WinGetClass("A") == "ApplicationFrameWindow" || GetProcessName() == "explorer.exe"))
      Send "!{F4}"
    else {
      try {
        PostMessage(0x112, 0xF060, , , "A")
      } catch Error as e {
        MsgBox '该程序暂时无法关闭，2 秒后弹窗自动关闭后请重试', , 'T2'      
      }
    }
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
    if !ReplaceSelectedText(&target, &args)
      return
  }

  ; 切换程序
  winTitle := Trim(winTitle)
  if winTitle && activateWindow(winTitle, isHide)
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
  if value
    Tip("已置顶当前窗口")
  else
    Tip("取消置顶")
}

; 关闭显示器:
SystemSleepScreen() {
  Sleep 1000 ; 让用户有机会释放按键(以防释放它们时再次唤醒显视器)
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
  if (FileExist(A_WinDir "\System32\SlideToShutDown.exe")) {
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
  Send("^c")
  if (!ClipWait(1)) {
    Tip("复制失败")
    return
  }
  A_Clipboard := A_Clipboard
  Tip("路径已复制")
}

copySelectedAsPlainTextQuiet() {
  A_Clipboard := ""
  Send "^c"
  if (!ClipWait(1)) {
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

  if WindowMaxOrMin()
    WinRestore("A")
  else
    WinMaximize("A")
}

/**
 * 窗口最小化
 */
minimizeWindow() {
  if NotActiveWin() || WinGetProcessName("A") = "Rainmeter.exe"
    return
  WinMinimize("A")
}

/**
 * 窗口居中并修改为指定大小
 * @param width 窗口宽度
 * @param height 窗口高度
 * @returns {void} 
 */
 CenterAndResizeWindow(width, height) {
  if NotActiveWin()
    return

  ; 在 mousemove 时需要 PER_MONITOR_AWARE (-3), 否则当两个显示器有不同的缩放比例时, mousemove 会有诡异的漂移
  ; 在 winmove 时需要 UNAWARE (-1), 这样即使写死了窗口大小为 1200x800, 系统会帮你缩放到合适的大小
  ; 不适用于 win 7 以下系统
  if VerCompare(A_OSVersion, "6.2") >= 0
    DllCall("SetThreadDpiAwarenessContext", "ptr", -1, "ptr")

  WinExist("A")
  if WindowMaxOrMin()
    WinRestore
  ; 返回监视器的数量
  monitorCount  := MonitorGetCount()
  if (monitorCount > 1) {
    ; 获取指定窗口的位置和大小
    WinGetPos(&x, &y, &w, &h)
    ; ms 为 监视器编号, 介于 1 和 MonitorGetCount 返回的数字之间
    monitorCount := GetMonitorAt(x + w / 2, y + h / 2)
  }
  ; 检查指定的监视器是否存在, 并可选地检索其工作区域的边界坐标。分别为左上右下
  MonitorGetWorkArea(monitorCount, &l, &t, &r, &b)
  ; 获得当前屏幕的宽度和高度
  w := r - l
  h := b - t

  ; 预设宽度 和 屏幕宽度的最小值
  finalWidth := Min(width, w)
  ; 预设高度 和 屏幕宽度的最小值
  finalHeight := Min(height, h)

  ; 设置最小宽度 和 高度
  if finalWidth < 160
    finalWidth := 160
  if finalHeight < 100
    finalHeight := 100
  
  ; 最终窗口的 x 值
  finalX := l + (w - finalWidth) / 2
  ; 最终窗口的 y 值
  finalY := t + (h - finalHeight) / 2

  WinMove(finalX, finalY, finalWidth, finalHeight)
  if VerCompare(A_OSVersion, "6.2") >= 0
    DllCall("SetThreadDpiAwarenessContext", "ptr", -3, "ptr")
}

; 我新加的 窗口按照屏幕的百分比 和 宽高比 8:5 进行显示
CenterAndResizeWindow_X_Percent(percent) {
  if NotActiveWin()
    return

  ; 在 mousemove 时需要 PER_MONITOR_AWARE (-3), 否则当两个显示器有不同的缩放比例时, mousemove 会有诡异的漂移
  ; 在 winmove 时需要 UNAWARE (-1), 这样即使写死了窗口大小为 1200x800, 系统会帮你缩放到合适的大小
  ; 不适用于 win 7 以下系统
  if VerCompare(A_OSVersion, "6.2") >= 0
    DllCall("SetThreadDpiAwarenessContext", "ptr", -1, "ptr")

  WinExist("A")
  if WindowMaxOrMin()
    WinRestore
  ; 返回监视器的数量
  monitorCount  := MonitorGetCount()
  if (monitorCount > 1) {
    ; 获取指定窗口的位置和大小
    WinGetPos(&x, &y, &w, &h)
    ; ms 为 监视器编号, 介于 1 和 MonitorGetCount 返回的数字之间
    monitorCount := GetMonitorAt(x + w / 2, y + h / 2)
  }
  ; 检查指定的监视器是否存在, 并可选地检索其工作区域的边界坐标。分别为左上右下
  MonitorGetWorkArea(monitorCount, &l, &t, &r, &b)

  ; 获得宽度和高度
  w := r - l
  h := b - t

  ; 高度作为基准
  finalHeight := h * percent
  ; 宽度按照 16:10 即 8:5，这样在超宽屏幕上显示正常
  finalWidth := finalHeight * 8 / 5
  ; 最终窗口的 x 值
  finalX := l + (w - finalWidth) / 2
  ; 最终窗口的 y 值
  finalY := t + (h - finalHeight) / 2

  WinMove(finalX, finalY, finalWidth, finalHeight)
  if VerCompare(A_OSVersion, "6.2") >= 0
    DllCall("SetThreadDpiAwarenessContext", "ptr", -3, "ptr")
}

; 我新加的 高度拓展至全屏
setWindowHeightToFullScreen() {
  if NotActiveWin()
    return

  ; 在 mousemove 时需要 PER_MONITOR_AWARE (-3), 否则当两个显示器有不同的缩放比例时, mousemove 会有诡异的漂移
  ; 在 winmove 时需要 UNAWARE (-1), 这样即使写死了窗口大小为 1200x800, 系统会帮你缩放到合适的大小
  if VerCompare(A_OSVersion, "6.2") >= 0
    DllCall("SetThreadDpiAwarenessContext", "ptr", -1, "ptr")

  WinExist("A")
  WinGetPos(&originX,,&originW)

  if (WindowMaxOrMin())
    WinRestore

  ; 获取指定窗口的位置和大小
  WinGetPos(&x, &y, &w, &h)
  ; ms 为 监视器编号, 介于 1 和 MonitorGetCount 返回的数字之间.
  ms := GetMonitorAt(x + w / 2, y + h / 2)

  ; 分别为左上右下
  MonitorGetWorkArea(ms,, &t,, &b)
  WinMove(originX, t, originW, b - t)

  if VerCompare(A_OSVersion, "6.2") >= 0
    DllCall("SetThreadDpiAwarenessContext", "ptr", -3, "ptr")
}

; 我新加的 宽度拓展至全屏
setWindowWeightToFullScreen() {
  if NotActiveWin()
    return

  ; 在 mousemove 时需要 PER_MONITOR_AWARE (-3), 否则当两个显示器有不同的缩放比例时, mousemove 会有诡异的漂移
  ; 在 winmove 时需要 UNAWARE (-1), 这样即使写死了窗口大小为 1200x800, 系统会帮你缩放到合适的大小

  if VerCompare(A_OSVersion, "6.2") >= 0
    DllCall("SetThreadDpiAwarenessContext", "ptr", -1, "ptr")

  WinExist("A")
  WinGetPos(, &originY, , &originH)

  if WindowMaxOrMin()
    WinRestore

  ; 获取指定窗口的位置和大小
  WinGetPos(&x, &y, &w, &h)

  ; 如果是 360 极速浏览器则特殊处理
  processName := WinGetProcessName("A")
  offset := 0
  if processName = '360ChromeX.exe'
    offset := 3

  ; ms 为 监视器编号, 介于 1 和 MonitorGetCount 返回的数字之间.
  ms := GetMonitorAt(x + w / 2, y + h / 2)
  ; 分别为左上右下
  MonitorGetWorkArea(ms, &l,, &r)
  WinMove(l + offset, originY, r - (l + offset) - offset, originH)

  if VerCompare(A_OSVersion, "6.2") >= 0
    DllCall("SetThreadDpiAwarenessContext", "ptr", -3, "ptr")
}

; 我新加的 窗口按照 指定像素进行缩放，例如 120 或者 -120
CenterAndResizeWindow_window_percent(step) {
  if NotActiveWin()
    return

  WinExist("A")
  ; 不适用于最大化和最小化的状态下
  if (WindowMaxOrMin()) {
    Tip("请在窗口模式下缩放")
    return
  }
  
  ; 在 mousemove 时需要 PER_MONITOR_AWARE (-3), 否则当两个显示器有不同的缩放比例时, mousemove 会有诡异的漂移
  ; 在 winmove 时需要 UNAWARE (-1), 这样即使写死了窗口大小为 1200x800, 系统会帮你缩放到合适的大小
  ; 不适用于 win 7 以下系统
  if VerCompare(A_OSVersion, "6.2") >= 0
    DllCall("SetThreadDpiAwarenessContext", "ptr", -1, "ptr")

  ; 获取指定窗口的位置和大小
  WinGetPos(&x, &y, &w, &h)

  ; 返回监视器的数量
  monitorCount  := MonitorGetCount()
  if (monitorCount > 1) {
    ; ms 为 监视器编号, 介于 1 和 MonitorGetCount 返回的数字之间
    monitorCount := GetMonitorAt(x + w / 2, y + h / 2)
  }
  ; 检查指定的监视器是否存在, 并可选地检索其工作区域的边界坐标。分别为 左上右下
  MonitorGetWorkArea(monitorCount, &l, &t, &r, &b)
  ; 获得监视器的宽度和高度
  monitorWidth := r - l
  monitorHeight := b - t

  ; 如果是扩大
  if (step > 0) {
    ; 只需要再当前窗口的基础上 x 和 y 轴拓展 二分之 step 长度即可
    finalWidth := w + step
    finalHeight := h + step
    if finalWidth > monitorWidth
      finalWidth := monitorWidth
    if finalHeight > monitorHeight
      finalHeight := monitorHeight

    finalX := x - step / 2.0
    if finalX < 0
      finalX := 0
    else if finalX + finalWidth > monitorWidth
      finalX := monitorWidth - finalWidth
    
    finalY := y - step / 2.0    
    if finalY < 0
      finalY := 0
    else if finalY + finalHeight > monitorHeight
      finalY := monitorHeight - finalHeight
  } else {
    ; 否则表示缩小
    myMinimumWidth := 400
    myMinimumHeight := 270

    ; 如果当前小于就免谈，否则说明还有缩小空间
    if (w <= myMinimumWidth and h <= myMinimumHeight) {
      if VerCompare(A_OSVersion, "6.2") >= 0
        DllCall("SetThreadDpiAwarenessContext", "ptr", -3, "ptr")
      return
    }
    if (w > myMinimumWidth) {
      ; 如果原有宽度大于最小宽度则还有操作空间
      if (w + step <= myMinimumWidth) {
        finalWidth := myMinimumWidth
        finalX := x + (w - myMinimumWidth) / 2.0
      } else {
        finalWidth := w + step
        finalX := x - step / 2.0
      }    
    } else {
      finalWidth := w
      finalX := x
    }

    if (h > myMinimumHeight) {
      if (h + step <= myMinimumHeight) {
        finalHeight := myMinimumHeight
        finalY := y + (h - myMinimumHeight) / 2.0
      } else {
        finalHeight := h + step
        finalY := y - step / 2.0
      }  
    } else {
      finalHeight := h
      finalY := y
    }
  }
  ; 记住上次的数值
  static prevW := unset
  static prevH := unset

  ; 如果 NOT (是缩小 且 两次数值相等且 非屏幕的宽度和高度)
  if (NOT (step < 0 and IsSet(prevW) and prevW == w and IsSet(prevH) and prevH == h and w !== monitorWidth and h !== monitorHeight)) {
    WinMove(finalX, finalY, finalWidth, finalHeight)
    prevW := w
    prevH := h
    if !A_IsCompiled
      tip 'x = ' x  ' y = ' y ' w = ' w  ' h = ' h '`n finalX = ' finalX  ' finalY = ' finalY ' w = ' finalWidth ' h = ' finalHeight '`n monitorWidth = ' monitorWidth  ' monitorHeight = ' monitorHeight
  }
  if VerCompare(A_OSVersion, "6.2") >= 0
    DllCall("SetThreadDpiAwarenessContext", "ptr", -3, "ptr")
}