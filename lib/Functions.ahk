/**
 * 没有活动窗口或是桌面返回True 反之返回false
 */
NotActiveWin() {
  return IsDesktop() || not WinExist("A")
}

/**
 * 判断当前窗口是不是桌面
 */
IsDesktop() {
  return WinActive("Program Manager ahk_class Progman") || WinActive("ahk_class WorkerW")
}

/**
 * 获取当前程序名称
 * 自带的WinGetProcessName无法获取到uwp应用的名称
 * 来源：https://www.autohotkey.com/boards/viewtopic.php?style=7&t=112906
 * @returns {string} 
 */
GetProcessName() {
  fn := (winTitle) => (WinGetProcessName(winTitle) == 'ApplicationFrameHost.exe')

  winTitle := "A"
  if fn(winTitle) {
    for hCtrl in WinGetControlsHwnd(winTitle)
      bool := fn(hCtrl)
    until !bool && winTitle := hCtrl
  }

  return WinGetProcessName(winTitle)
}

/**
 * 托盘菜单被点击
 * @param ItemName 
 * @param ItemPos 
 * @param MyMenu 
 */
TrayMenuHandler(ItemName, ItemPos, MyMenu) {
  switch ItemName {
    case "暂停":
      jiejianToggleSuspend()
    case "重启程序":
      jiejianReload()
    case "检查更新":
      checkUpdate(true)
    case "帮助文档":
      Run "https://gitcode.com/acc8226/jiejian/overview"
    case "关于作者":
      Run "https://gitcode.com/acc8226/"
    case "查看窗口标识符":
      Run "extra/WindowSpyU32.exe"
    case "退出":
      jiejianExit()
  }
}

TrayMenuHandlerToRelease(*) {
  Run "https://gitcode.com/acc8226/jiejian/releases"
}

/**
 * 暂停
 */
jiejianToggleSuspend() {
  Suspend(!A_IsSuspended)
  if (A_IsSuspended) {
    ; TraySetIcon("./bin/icons/logo2.ico")
    A_TrayMenu.Check("暂停")
    Tip("  暂停捷键  ", -500)
  } else {
    ; TraySetIcon("./bin/icons/logo.ico")
    A_TrayMenu.UnCheck("暂停")
    Tip("  恢复捷键  ", -500)
  }
}

/**
 * 重启程序
 */
jiejianReload() {  
  Tip("Reload")
  Reload()
}

/**
 * 退出程序
 * @param ExitReason 退出原因
 * @param ExitCode 传递给 Exit 或 ExitApp 的退出代码.
 */
jiejianExit(ExitReason?, ExitCode?) {
  ExitApp
}