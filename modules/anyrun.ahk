#Include "Sort.ahk"

; 正则匹配最大支持长度默认为 32 位
Support_Length := 32

Anyrun() {
    guiTitle := "快捷启动"
    ; 检查窗口是否已经存在，如果窗口已经存在，如果窗口不存在，则创建新窗口 
    If WinExist(guiTitle)
        WinClose ; 使用由 WinExist 找到的窗口
    else {
        width := 430
        ; S: 尺寸(单位为磅)
        fontSize := "s21"
        ; AlwaysOnTop 使窗口保持在所有其他窗口的顶部
        ; Owner 可以让当前窗口从属于另一个窗口. 从属的窗口默认不显示在任务栏, 并且它总是显示在其父窗口的上面. 当其父窗口销毁时它也被自动销毁
        ; -Caption 移除背景透明的窗口的边框和标题栏
        ; -Resize 禁止用户重新调整窗口的大小
        myGui := Gui("AlwaysOnTop Owner -Caption -Resize", guiTitle)
        ; 横向窄边框 纵向无边框
        myGui.MarginX := 1
        myGui.MarginY := 0
        myGui.SetFont(fontSize, "Consolas") ; 设置字体(24 磅) 和 Consolas
        myGui.SetFont(fontSize, "Microsoft YaHei") ; 设置优先字体(24 磅) 和 微软雅黑
        myEdit := myGui.AddEdit(Format("vMyEdit w{1}", width))
        ; listBox 做到贴边 默认只显示 5 行、宽度 400 位置
        ; Hidden: 让控件初始为隐藏状态
        listBox := myGui.AddListBox(Format("R5 vMyChoice w{1} XM+0 Y+0 BackgroundF0F0F0 Hidden", width), [])
        button := myGui.Add("Button", "default X0 Y0 Hidden", "OK")

        myEdit.OnEvent("Change", editOnChange)

        editOnChange(thisGui, *) {  ; 声明中 this 参数是可选的
            ; 获取输入内容
            input := thisGui.Value
            ; 若为空则清空列表 或 大于设定长度 或 非字母和数字组合则退出
            if input == "" OR StrLen(input) > Support_Length
                  OR (NOT RegExMatch(input, '^[a-zA-Z0-9一-龥]+$') ; \u4e00-\u9fa5 可以表示为 一-龥
            ) {
                listBox.Delete()
                listBox.Visible := false
                myGui.Show("AutoSize")
                return
            }
            ; 精确匹配失败则转到模糊匹配
            needleRegEx := ''
            Loop Parse, input {
                needleRegEx .= '(' . A_LoopField . ").*"
            }
            needleRegEx := 'i)' . needleRegEx
            
            listBox.Delete()
            dataArray := Array()
            for it in dataList {
                ; 只处理 app 和 web 这两种类型
                if it.type = 'app' or it.type = 'web' {
                    if Type(it.alias) == "Array" {
                        ; 如果有则选出最匹配的 array
                        ; 最佳匹配对象
                        maxData := unset
                        Loop it.alias.Length {
                            if RegExMatch(it.alias[A_Index], needleRegEx, &regExMatchInfo) {
                                data := {degree: computeDegree(regExMatchInfo) ; 匹配度
                                        , title: it.title ; 标题
                                        , type: it.type ; 类型
                                }
                                if !IsSet(maxData)
                                    maxData := data
                                else if dataArrayCompare(maxData, data) < 0
                                    maxData := data
                            }
                        }
                        if IsSet(maxData)
                            dataArray.Push(maxData)
                    } else if RegExMatch(it.alias, needleRegEx, &regExMatchInfo) {
                        dataArray.Push({degree: computeDegree(regExMatchInfo)
                                        , title: it.title
                                        , type: it.type
                        })
                    }
                }                
            }
            if dataArray.Length > 0 {
                dataArraySort(dataArray)
                listBox.Add(listBoxData(dataArray))
                listBox.Choose(1)
            } 
            listBox.Visible := dataArray.Length > 0
            myGui.Show("AutoSize")
        }
        ; 若两个关键控件都失去焦点则关闭窗口
        myEdit.OnEvent("LoseFocus", onEditLoseFocus)
        listbox.OnEvent("LoseFocus", onListboxLoseFocus)

        listbox.OnEvent("DoubleClick", onListBoxDoubleClick)
        button.OnEvent("Click", onButtonClick)
        ; 按住 esc 销毁 窗口
        myGui.OnEvent("Escape", (*) => myGui.Destroy())

        ; 居中但是稍微往上偏移些
        myGui.Show(Format("xCenter y{1} AutoSize", A_ScreenHeight / 2 - 300))

        onEditLoseFocus(*) {
            if not listBox.Focused
                myGui.Destroy()
        }

        onListboxLoseFocus(*) {
            if not myEdit.Focused
                myGui.Destroy()
        }

        onListBoxDoubleClick(*) {
            ; 此时 listbox 必定有焦点，则根据 title 反查 path
            it := appFindPathByListBoxText(dataList, listBox.Text)
            if it.type = 'app' {
                ; 自动登录微信
                if it.title == '微信' {
                    try {
                        Run it.path,,, &pid
                        WinWaitActive "ahk_pid " pid
                        ; 手动等待 1.1 秒，否则可能会跳到扫码页
                        Sleep 1100
                        Send "{Space}"
                    } catch {
                        MsgBox "找不到目标应用"
                    }
                } else
                    ActivateOrRun(it.winTitle, it.path)           
            } else
                Run it.path
            MyGui.Destroy()
        }

        onButtonClick(*) {
            ; 如果 listbox 有焦点
            if listBox.Focused
                onListBoxDoubleClick()
            else {
                ; 焦点在 edit，则获取编辑框文本内容，如果为空则啥都不干
                ; 匹配的时候用的是 全拼 ,显示的是真实名称
                editValue := Trim(myEdit.Value)
                if editValue == '' {
                    MsgBox('输入内容不能为空')
                    return
                }
                ; 如果列表有匹配项
                if listBox.Value > 0 {
                    onListBoxDoubleClick()
                } else {
                    ; 动作
                    switch editValue, 'Off' {
                        case 'IP': ; 查看 本机 IP
                            addresses := SysGetIPAddresses()
                            msg := "IP 地址:`n"
                            for address in addresses
                                msg .= address "`n"
                            MsgBox msg
                            MyGui.Destroy()
                            return
                    }
                    ; 打开搜索
                    RegExMatch(editValue, "i)^(bd|bi|ip|bl)(.*)", &regExMatchInfo)
                    ; IsObject 可判断非空
                    if IsObject(regExMatchInfo) and regExMatchInfo.Count == 2 {
                        switch regExMatchInfo[1], 'Off' {
                            case 'bd':
                                Tip('百度 ' . regExMatchInfo[2])
                                Run "https://www.baidu.com/s?wd=" . Trim(regExMatchInfo[2])
                            case 'bi': ; bing 搜索
                                Tip('必应 ' . regExMatchInfo[2])
                                Run "https://cn.bing.com/search?q=" . Trim(regExMatchInfo[2])
                            case 'ip': ; IP 归属地查询
                                Tip('IP 查询 ' . regExMatchInfo[2])
                                Run "https://www.ip138.com/iplookup.php?ip=" . Trim(regExMatchInfo[2])
                            case 'bl': ; bilibili
                                Tip('b 站 ' . regExMatchInfo[2])
                                Run "https://search.bilibili.com/all?keyword=" . Trim(regExMatchInfo[2])
                        }
                        MyGui.Destroy()
                        return
                    }
                    ; 打开网址 
                    if editValue ~= "i)^(?:https?://)?([\w-]+\.)+[\w-]+(/[\w-./?%&=]*)?$" {
                        if not InStr(editValue, 'http') {
                            editValue := "http://" . editValue
                        }
                        Tip "打开网址 " . editValue
                        Run editValue
                        MyGui.Destroy()
                        return
                    }
                    ; 打开文件/程序
                    if FileExist(editValue) {
                        Tip "打开 " . editValue
                        Run editValue
                        MyGui.Destroy()
                        return
                    }
                    MsgBox('匹配失败')
                }
            }
        }
    }
}

/**
 * 计算匹配度
 * 
 * @param regExMatchInfo
 * @returns {number} 
 */
computeDegree(regExMatchInfo) {
    degree := 0
    loop regExMatchInfo.Count {
        item := Support_Length - regExMatchInfo.Pos[A_Index]
        if item < 0
            break
        degree += 2 ** item
    }
    return degree
}
