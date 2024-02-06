/**
 * 智能的关闭窗口
 */
SmartCloseWindow() {
  if WinExist('A') {
    if IsDesktop()
      return
    if (WinGetClass("A") == "ApplicationFrameWindow" || GetProcessName() == "explorer.exe")
      Send "!{F4}"
    else
      PostMessage(0x112, 0xF060, , , "A")
  } else
    MsgBox '活动窗口未找到，请重试，3 秒后弹窗将自动关闭', , 'T3'
}

/**
 * 启动程序或切换到程序
 * @param {string} winTitle AHK 中的 WinTitle
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