; Note: Exit script with Esc::
OnExit("exit")

; Settings
radius := 150			; Starting radius of the hole.
increment := 25		; Amount to decrease/increase radius of circle when turning scroll wheel 每次的增量
inverted := false		; If false, the region is see-throughable.
rate := 80			; The period (ms) of the timer. 40 ms is 25 "fps" 如果是 80 则是 12.5 fps

; Make the region
region:=makeTriangle(radius)

; Script settings
SetWinDelay,-1
listlines, off ; Remove when debugging.

F1::timer(toggle:=!toggle, region, inverted, rate), pause:=0		; Toggle on/off

#if toggle
F2::timer(1,region,inverted:=!inverted,rate),pause:=0			; When on, toggle inverted setting
F3::timer((pause := !pause) ? -1 : 1)									; When on, toggle pause.
return

WheelUp::														; Increase the radius of the circle
WheelDown::														; Decrease 			-- "" --
	InStr(A_ThisHotkey, "Up") ? radius+=increment : radius-=increment
	radius<80 ? radius:=80 : ""									; Ensure greater than 0 radius
	region:=makeTriangle(radius)
	timer(1, region, inverted)
return
#if

esc::exit()														; Exit script with Esc::
exit(){
	timer(0) ; For restoring the window if region applied when script closes.
	ExitApp
	return
}

timer(state, region:="", inverted := false, rate := 50){
	; Call with state=0 to restore window and stop timer, state=-1 stop timer but do not restore
	; region, inverted, see WinSetRegion()
	; rate, the period of the timer.
	static timerFn, paused, hWin, aot
	if (state=0) {												; Restore window and turn off timer
		if timerFn
			SetTimer,% timerFn, Off
		if !hWin
			return												
		WinSet, Region,, % "ahk_id " hWin
		if !aot													; Restore not being aot if appropriate.
			WinSet, AlwaysOnTop, off, % "ahk_id " hWin
		hWin:="",timerFn:="",aot:="",paused:=0
		return
	} else if (timerFn) {										; Pause/unpause or...
		if (state=-1) {
			SetTimer,% timerFn, Off
			return paused:=1
		} else if paused {
			SetTimer,% timerFn, On
			return paused:=0
		} else {												; ... stop timer before starting a new one.
			SetTimer,% timerFn, Off
		}
	}
	if !hWin {													; Get the window under the mouse.
		MouseGetPos,,,hWin
		WinGet, aot, ExStyle, % "ahk_id " hWin 					; Get always-on-top state, to preserve it.
		aot&=0x8
		if !aot
			WinSet, AlwaysOnTop, On, % "ahk_id " hWin
	}
	timerFn:=Func("timerFunction").Bind(hWin,region,inverted)	; Initialise the timer.
	timerFn.Call(1)												; For better responsiveness, 1 is for reset static
	SetTimer, % timerFn, % rate
	return
}

timerFunction(hWin, region, inverted, resetStatic:=0) {
	; Get mouse position and convert coords to win coordinates, for displacing the circle
	static px,py
	WinGetPos,wx,wy,,, % "ahk_id " hWin
	CoordMode, Mouse, Screen
	MouseGetPos,x,y
	x-=wx,y-=wy
	if (x=px && y=py && !resetStatic)
		return
	else 
		px:=x,py:=y
	WinSetRegion(hWin,region,x,y,inverted)
	
	return
}

WinSetRegion(hWin,region,dx:=0,dy:=0,inverted:=false){
	; hWin, handle to the window to apply region to.
	; Region should be on the form, region:=[{x:x0,y:y0},{x:x1,y:y1},...,{x:xn,y:yn},{x:x0,y:y0}]
	; dx,dy is displacing the the region by fixed amount in x and y direction, respectively.
	; inverted=true, make the region the only part visible, vs the only part see-throughable for inverted=false
	if !inverted {
		WinGetPos,,,w,h, % "ahk_id " hWin
		regionDefinition.= "0-0 0-" h " " w "-" h " " w "-0 " "0-0 "
	}
	for k, pt in region
		regionDefinition.= dx+pt.x "-" dy+pt.y " "
	WinSet, Region, % regionDefinition, % "ahk_id " hWin
}

; Function for making the circle
makeCircle(r:=100,n:=-1){
	; r is the radius.
	; n is the number of points, let n=-1 to set automatically (highest quality).
	static pi:=atan(1)*4
	pts:=[]
	n:= n=-1 ? Ceil(2*r*pi) : n
	n:= n>=1994 ? 1994 : n			; There is a maximum of 2000 points for WinSet,Region,...
	loop, % n + 1
		t := 2 * pi * (A_Index - 1) / n, pts.push({x:round(r * cos(t)), y:round(r * sin(t))})
	return pts
}

heart4tidbit(r:=100)
{
	n:=r*4
	n:= n>=997 ? 997 : n			; There is a maximum of 2000 points for WinSet,Region,... Edit: Changed to 997, since there are two loops
	region:=[]
	oY:=-r//2
	Loop, % n
	{
		x:=-2+4*(A_Index-1)/(n-1)
		y:=-sqrt(1-(abs(x)-1)**2)
		region.push({x:x*r, y:y*r+oY})
	}
	Loop, % n
	{
		x:=2-4*(A_Index-1)/(n-1)
		y:=3*sqrt(1-sqrt(abs(x/2)))
		region.push({x:x*r, y:y*r+oY})
	}
	return region
}

makeTriangle(side:=100){
	; 使用等边三角形高的公式计算高
	heigth := round(side * sqrt(3) / 2)
	; 初始化顶点坐标：顶点 右下角 左下角
	region := [{x:0,y:0}, {x:side//2, y:heigth}, {x:-side//2, y:heigth}, {x:0,y:0}]
	oY := -heigth // 2			; Make center, note: oX:=0
	; 调整顶点坐标以使三角形居中：需要整体下移
	for k, pt in region {
		pt.y += oY			; Make correction for center, note: pt.x+=oX
		; MsgBox, % "Point " k ": (" pt.x ", " pt.y ")"
	}
	return region
	; 0 . -65
	; 75 65
	; -75 65
	; 0 . -65
}