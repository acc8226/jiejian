global radius := 230	 ; Starting radius of the hole.
global inverted := false ; If false, the region is see-throughable. 默认是 false，表示穿透该区域，否则表示不穿透，保留该区域
global rate := 80		 ; The period (ms) of the timer. 40 ms is 25 "fps" 如果是 80 则是 12.5 fps

global toggle := false		 ; 切换窗口的显示状态

CoordMode 'Mouse'

; Make the region
region := makeCircle(radius)
F1::{
	global toggle := !toggle
	timer(toggle, region, inverted, rate) ; Toggle on/off
}

/**
 * timer 函数根据state参数控制定时器的开启、关闭和暂停，以及窗口区域的更新
 * 
 * @param state Call with state=0 to restore window and stop timer, state=-1 stop timer but do not restore 0 表示停止和退出 -1 表示停止但是不还原
 * @param {String} region see WinSetRegion()
 * @param {Integer} inverted see WinSetRegion()
 * @param {Integer} rate the period of the timer.
 * @returns {Integer} 
 */
timer(state, region := "", inverted := false, rate := 50) {
	static timerFn, paused, hWin, aot
	; Restore window and turn off timer
	if (state = 0 ) {
		if timerFn
			SetTimer timerFn, false
		if !hWin
			return
		WinSetRegion , hWin
		if !aot									      ; Restore not being aot if appropriate.
			WinSetAlwaysOnTop false, hWin
		timerFn := ""
		paused := 0
		hWin := ""
		aot := ""
		return
	} else if (IsSet(timerFn) && timerFn) {			  ; Pause/unpause or...
		if (state = -1) {
			SetTimer timerFn, false
			return paused := 1
		}
		; 隐式表示 state 为 1
		else if (IsSet(paused) && paused) {
			SetTimer timerFn, true
			return paused := 0
		} else {										  ; ... stop timer before starting a new one.
			SetTimer timerFn, false
		}
	}
	; 隐式表示 state 为 1
	if !(IsSet(hWin) && hWin) {			                  ; Get the window under the mouse. 确定窗口是否具有 WS_EX_TOPMOST 样式(置顶).
		MouseGetPos ,, &hWin
		aot := WinGetExStyle(hWin) & 0x8 				  ; Get always-on-top state, to preserve it.
		if !aot
			WinSetAlwaysOnTop true, hWin                  ; 必须指定当前窗口，防止后面的窗口获取焦点
	}
	timerFn := timerFunction.Bind(hWin, region, inverted) ; Initialise the timer.
	timerFn.Call(1)										  ; For better responsiveness, 1 is for reset static
	SetTimer timerFn, rate
}

/**
 * 负责获取鼠标位置，并根据这个位置更新窗口区域，使其跟随鼠标移动
 * 
 * @param hWin handle to the window to apply region to.
 * @param region should be on the form, region:=[{x:x0,y:y0},{x:x1,y:y1},...,{x:xn,y:yn},{x:x0,y:y0}]
 * @param inverted inverted=true, make the region the only part visible, vs the only part see-throughable for inverted=false 布尔值，决定区域是可见部分还是透明部分
 * @param {Integer} resetStatic 
 */
timerFunction(hWin, region, inverted, resetStatic := 0) {
	; Get mouse position and convert coords to win coordinates, for displacing the circle
	static px, py
	; 当前窗口的 x 和 y 坐标
	WinGetPos &wx,&wy,,, hWin
	; 当前鼠标的坐标
	MouseGetPos &x, &y
	; 位移量
	x -= wx, y -= wy
	if (IsSet(px) && x = px && y = py && !resetStatic)
		return
	else 
		px:=x , py:=y
	setRegion(hWin, region, x, y, inverted)
	return
}

/**
 *  设置窗口的区域
 * 
 * @param hWin handle to the window to apply region to.
 * @param region should be on the form, region:=[{x:x0,y:y0},{x:x1,y:y1},...,{x:xn,y:yn},{x:x0,y:y0}]
 * @param {Integer} dx displacing the the region by fixed amount in x and y direction, respectively.
 * @param {Integer} dy displacing the the region by fixed amount in x and y direction, respectively.
 * @param {Integer} inverted inverted=true, make the region the only part visible, vs the only part see-throughable for inverted=false 布尔值，决定区域是可见部分还是透明部分
 */
setRegion(hWin, region, dx:=0, dy:=0, inverted := false) {
	if !inverted {
		WinGetPos ,, &w, &h, hWin
		regionDefinition .= "0-0 0-" . h . " " . w . "-" . h . " " . w . "-0 0-0 " ; 0-0 0-h w-h w-0 0-0 
	}
	for k, pt in region
		regionDefinition .= dx + pt.x "-" dy + pt.y " " ; regionDefinition 字符串包含了定义区域的所有点
	WinSetRegion regionDefinition, hWin
}

makeCircle(r := 100 , n := -1){
	; r is the radius.
	; n is the number of points, let n=-1 to set automatically (highest quality).
	static pi := atan(1) * 4
	pts := []
	n:= n=-1 ? Ceil(2*r*pi) : n
	n:= n>=1994 ? 1994 : n			; There is a maximum of 2000 points for WinSet,Region,...
	loop n + 1
		t := 2 * pi * (A_Index - 1) / n, pts.push({x:round(r * cos(t)), y:round(r * sin(t))})
	return pts
}

makeTriangle(side:=100) {
	; 使用等边三角形高的公式计算高
	heigth := Round(side * sqrt(3) / 2)
	; 初始化顶点坐标：顶点 右下角 左下角
	region := [{x:0,y:0}, {x:side//2, y:heigth}, {x:-side//2, y:heigth}, {x:0,y:0}]
	oY := -heigth // 2			; Make center, note: oX:=0
	; 调整顶点坐标以使三角形居中：需要整体下移
	for k, pt in region {
		pt.y += oY			; Make correction for center, note: pt.x+=oX
	}
	return region
	; 0 . -65
	; 75 65
	; -75 65
	; 0 . -65
}
