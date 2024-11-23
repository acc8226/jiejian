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
