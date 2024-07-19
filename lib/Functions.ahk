/**
 * 没有活动窗口或是桌面返回 True 反之返回 false
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
 * 自带的 WinGetProcessName 无法获取到 uwp 应用的名称
 * 来源：https://www.autohotkey.com/boards/viewtopic.php?style=7&t=112906
 * 
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

/**
 *  将程序路径或参数中的{selected} 替换为选中的文字
 * @param target 程序路径的引用
 * @param args 参数的引用
 * @returns {void|number} 
 */
ReplaceSelectedText(&target, &args) {
  text := GetSelectedText()
  if not (text) {
    text := ""
  }

  if InStr(args, "://") || InStr(target, "://") {
    text := URIEncode(text)
  }
  args := strReplace(args, "{selected}", text)
  target := strReplace(target, "{selected}", text)

  return 1
}

/**
 * 获取选中的文字
 * @returns {void|string} 
 */
GetSelectedText() {
  temp := A_Clipboard
  ; 清空剪贴板
  A_Clipboard := ""

  Send("^c")
  if not (ClipWait(0.4)) {
    Tip("没有选中的文本或文件", -700)
    return
  }
  text := A_Clipboard

  A_Clipboard := temp
  return RTrim(text, "`r`n")
}

/**
 * url 编码
 * 来源: https://www.autohotkey.com/boards/viewtopic.php?t=112741
 * @param Uri 需要编码的文本
 * @param {string} encoding 编码格式
 * @returns {string} 
 */
URIEncode(Uri, encoding := "UTF-8") {
  var := Buffer(StrPut(Uri, encoding), 0)
  StrPut(Uri, var, encoding)
  pos := 1
  ; 按字节遍历 buffer 中的 utf-8 字符串, 注意字符串有  null-terminator
  While pos < var.Size {
    code := NumGet(var, pos - 1, "UChar")
    if (code >= 0x30 && code <= 0x39) || (code >= 0x41 && code <= 0x5A) || (code >= 0x61 && code <= 0x7A)
      res .= Chr(code)
    else
      res .= "%" . Format("{:02X}", code)
    pos++
  }
  return res
}

/**
 * 激活窗口
 * @param winTitle AHK中的WinTitle
 * @param {number} isHide 窗口是否为隐藏窗口
 * @returns {number} 
 */
ActivateWindow(winTitle := "", isHide := false) {
  ; 如果匹配不到窗口且认为窗口为隐藏窗口时查找隐藏窗口
  hwnds := FindWindows(winTitle, (hwnd) => WinGetTitle(hwnd) != "")
  if ((!hwnds.Length) && isHide) {
    hwnds := FindHiddenWindows(winTitle)
    if hwnds.Length {
      WinShow(hwnds.Get(1))
      WinActivate(hwnds.Get(1))
      return true
    }
  }

  ; 如果匹配到则跳转，匹配不到返回0
  if (!hwnds.Length) {
    return false
  }

  ; 只有一个窗口为最小化则切换否则最小化
  if (hwnds.Length = 1) {
    hwnd := hwnds.Get(1)
    ; 指定不为活动窗口或窗口被缩小则显示出来
    if (WinExist("A") != hwnd || WinGetMinMax(hwnd) = -1) {
      WinActivate(hwnd)
    } else {
      WinMinimize(hwnd)
    }
  } else {
    ; 如果多个窗口则来回切换
    LoopRelatedWindows(winTitle, hwnds)
  }
  return true
}

/**
 * 返回与指定条件匹配的所有窗口
 * @param winTitle AHK中的WinTitle
 * @param predicate 过滤窗口方法，传过Hwnd，返回bool
 * @returns {array} 
 */
FindWindows(winTitle, predicate?) {
  temps := WinGetList(winTitle)
  ; 不需要做任何匹配直接返回
  if not (IsSet(predicate)) {
    return temps
  }

  hwnds := []
  for i, hwnd in temps {
    ; 当有谓词条件且满足时添加这个hwnd
    if predicate(hwnd) {
      hwnds.Push(hwnd)
    }
  }
  return hwnds
}

/**
 * 查找隐藏窗口返回窗口的Hwnd 
 * @param winTitle AHK中的WinTitle
 * @returns {array} 
 */
FindHiddenWindows(winTitle) {
  WS_MINIMIZEBOX := 0x00020000
  WS_MINIMIZE := 0x20000000

  ; 窗口过滤条件
  ; 标题不为空、包含最小化按钮
  Predicate(hwnd) {
    if (WinGetTitle(hwnd) = "")
      return false

    style := WinGetStyle(hwnd)
    return style & WS_MINIMIZEBOX
  }

  ; 开启可以查找到隐藏窗口
  DetectHiddenWindows true
  hwnds := FindWindows(winTitle, Predicate)
  DetectHiddenWindows false

  return hwnds
}

/**
 * 轮换程序窗口
 * @param winTitle AHK中的WinTitle
 * @param hwnds 活动窗口的句柄数组
 * @returns {void|number} 
 */
LoopRelatedWindows(winTitle?, hwnds?) {
  ; 如果没有传句柄数组则获取当前窗口的
  if not (IsSet(hwnds)) {
    predicate := (hwnd) => WinGetTitle(hwnd) != ""
    if (GetProcessName() == "explorer.exe") {
      predicate := (hwnd) => WinGetClass(hwnd) = "CabinetWClass"
    }
    hwnds := FindWindows("ahk_pid " WinGetPID("A"), predicate)
  }

  ; 只有一个窗口显示出来就行
  if (hwnds.Length = 1) {
    WinActivate(hwnds.Get(1))
    return
  }

  ; 没有传 winTitle 时，则获取当前程序的名称
  if not (IsSet(winTitle)) {
    class := WinGetClass("A")
    if (class == "ApplicationFrameWindow") {
      winTitle := WinGetTitle("A") "  ahk_class ApplicationFrameWindow"
    } else {
      winTitle := "ahk_exe " GetProcessName()
    }
  }
  winTitle := Trim(winTitle)

  static winGroup, lastWinTitle := "", lastHwnd := "", gi := 0
  if (winTitle != lastWinTitle || lastHwnd != WinExist("A")) {
    lastWinTitle := winTitle
    winGroup := "AutoName" gi++
  }

  ; 将所有的hwnd都添加到组里
  for hwnd in hwnds {
    GroupAdd(winGroup, "ahk_id" hwnd)
  }

  ; 切换
  lastHwnd := GroupActivate(winGroup, "R")
  return lastHwnd
}

/**
 * 运行程序或打开目录，用于解决打开的程序无法获取焦点的问题
 * @param target 程序路径
 * @param {string} args 参数
 * @param {string} workingDir 工作目录
 * @param {number} admin 是否为管理员启动
 * @returns {void} 
 */
RunPrograms(target, args := "", workingDir := "", admin := false, runInBackground := false) {
  ; 记录当前窗口的hwnd，当软件启动失败时还原焦点
  currentHwnd := WinExist("A")

  if !runInBackground {
    ActivateDesktop()
  }

  try {
    ; 补全程序路径
    programPath := CompleteProgramPath(target)

    ; 如果是文件夹直接打开
    if (InStr(FileExist(programPath), "D")) {
      Run(programPath)
      return
    }

    ; 避免在快捷方式无效，导致的程序卡住
    ShortcutTargetExist(programPath)

    if (admin) {
      runAsAdmin(programPath, args, workingDir, runInBackground ? "Hide" : "")
    } else {
      ; 直接 run "https://example.com" 会让 chrome 以管理员启动
      ; ShellRun 也支持 ms-setting: 或 shell: 或 http: 之类的链接
      ShellRun(programPath, args, workingDir, , runInBackground ? 0 : unset)
    }

  } catch Error as e {
    Tip(e.Message)
    ; 还原窗口焦点
    try WinActivate(currentHwnd)
    return
  }
}

ActivateDesktop() {
  tmp := A_DetectHiddenWindows
  DetectHiddenWindows true
  if WinExist("ahk_class ForegroundStaging") {
    WinActivate
  }
  DetectHiddenWindows tmp
}

/**
 * 从环境中补全程序的绝对路径
 * 来源: https://autohotkey.com/board/topic/20807-fileexist-in-path-environment/
 * @param target 程序路径 
 * @returns {string|any} 
 */
CompleteProgramPath(target) {
  ; 工作目录下的程序
  PathName := A_WorkingDir "\" target
  if FileExist(PathName)
    return PathName

  ; 本身便是绝对路径
  if FileExist(target)
    return target

  ; 从环境变量 PATH 中获取
  DosPath := EnvGet("PATH")
  loop parse DosPath, "`;" {
    if A_LoopField == ""
      continue

    if FileExist(A_LoopField "\" target)
      return A_LoopField "\" target
  }

  ; 从安装的程序中获取
  try {
    PathName := RegRead("HKLM", "SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\" target)
    if FileExist(PathName)
      return PathName
  }

  return target
}

/**
 * 快捷方式指向目标是否存在，不存在抛出异常
 * @param LnkPath 快捷方式路径
 */
ShortcutTargetExist(LnkPath) {
  if SubStr(LnkPath, -4) == ".lnk" {
    FileGetShortcut(LnkPath, &OutTarget)

    ; 没有获取到目标路径可能是因为是 uwp 应用的快捷方式
    ; 也有可能是 ms-setting: 或shell: 之类的连接
    if !OutTarget || SubStr(outTarget, 2, 2) != ":\"
      return

    if !FileExist(OutTarget)
      throw Error("快捷方式指向的目标不存在`n快捷方式: " LnkPath "`n指向目标: " OutTarget)
  }
}

/**
 * 以管理员权限打开软件
 * @param target 程序路径
 * @param args 参数
 * @param workingDir 工作目录
 */
RunAsAdmin(target, args, workingDir, options) {
  try {
    Run("*RunAs " target " " args, workingDir, options)
  } catch Error as e {
    Tip("使用管理启动失败 " target ", " e.Message)
  }
}

/**
 * 通过命令行去启动程序，防止会导致以管理员启动软件的问题
 * @param target 程序路径 
 * @param arguments 参数
 * @param directory 工作目录
 * @param operation 选项 (runas/open/edit/print
 * @param show 是否显示
 */
ShellRun(target, arguments?, directory?, operation?, show?) {
  static VT_UI4 := 0x13, SWC_DESKTOP := ComValue(VT_UI4, 0x8)
  ComObject("Shell.Application").Windows.Item(SWC_DESKTOP).Document.Application
    .ShellExecute(target, arguments?, directory?, operation?, show?)
}

/**
 * 当前窗口是最大化还是最小化
 * @param {string} winTitle AHK中的WinTitle
 * @returns {number} 
 */
WindowMaxOrMin(winTitle := "A") {
  return WinGetMinMax(winTitle)
}

/**
 * 获取当前焦点在哪个显示器上
 * @param x 窗口X轴的长度
 * @param y 窗口y轴的长度
 * @param {number} default 显示器下标
 * @returns {string|number} 匹配的显示器下标
 */
GetMonitorAt(x, y, default := 1) {
  ; 80 SM_CMONITORS: 桌面上监视器数目(不包括 "不显示的伪监视器")
  m := SysGet(80)
  loop m {
    MonitorGet(A_Index, &l, &t, &r, &b)
    if (x >= l && x <= r && y >= t && y <= b)
      return A_Index
  }
  return default
}
