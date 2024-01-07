/**
 * 智能的关闭窗口
 */
SmartCloseWindow() {
  if NotActiveWin() {
    return
  }

  if (WinActive("- Microsoft Visual Studio ahk_exe devenv.exe")) {
    Send("^{F4}")
  } else {
    if (WinGetClass("A") == "ApplicationFrameWindow" || GetProcessName() == "explorer.exe") {
      Send("!{F4}")
    } else {
      PostMessage(0x112, 0xF060, , , "A")
    }
  }
}
