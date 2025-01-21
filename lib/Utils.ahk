/**
 * 自动关闭的提示窗口
 * @param message 要提示的文本
 * @param {number} time 超时后关闭
 */
Tip(message, time := -1299, X := unset, Y := unset) {
  ; 不喜欢不吉利的🔢🌶
  if IsSet(X) {
    ToolTip(message, X, Y)
  } else {
    ToolTip(message)
  }
  SetTimer(() => ToolTip(), time)
}

OpenURLOrSearch(text) {
  ; 如果是网址
  if RegExMatch(text, 'i)^\s*((?:https?://)?(?:[\w-]+\.)+[\w-]+(?:/[\w-./?%&=]*)?\s*)$', &regExMatchInfo) {
    text := regExMatchInfo.1
    if NOT InStr(text, 'http')
        text := ('http://' . text)
    Run text
  } else if (FileExist(text)) {
    Sleep 200
    Run text
  } else {
    Run('https://www.baidu.com/s?wd=' . text)
  }
}

/**
 * 没有获取到文字直接返回,否则若选中的是网址则打开，否则进行百度搜索。这个功能可以暴露出去作为服务 export
 * 
 * @param text 
 */
OpenSelectedText() {
    text := GetSelectedText()
    if text
        OpenURLOrSearch text
}
