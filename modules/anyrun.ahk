#Include "Sort.ahk"

; 正则匹配最大支持长度默认为 32 位
Support_Length := 32

Anyrun() {
    guiTitle := "快捷启动"
    ; 检查窗口是否已经存在，如果窗口已经存在，如果窗口不存在，则创建新窗口 
    If WinExist(guiTitle) {
        WinClose ; 使用由 WinExist 找到的窗口
    } else {
        width := 430
        ; S: 尺寸(单位为磅)
        fontSize := 's21'
        ; AlwaysOnTop 使窗口保持在所有其他窗口的顶部
        ; Owner 可以让当前窗口从属于另一个窗口. 从属的窗口默认不显示在任务栏, 并且它总是显示在其父窗口的上面. 当其父窗口销毁时它也被自动销毁
        ; -Caption 移除背景透明的窗口的边框和标题栏
        ; -Resize 禁止用户重新调整窗口的大小
        myGui := Gui('AlwaysOnTop Owner -Caption -Resize', guiTitle)
        ; 横向窄边框 纵向无边框
        myGui.MarginX := 1
        myGui.MarginY := 0
        myGui.SetFont(fontSize, 'Consolas') ; 设置兜底字体(24 磅) Consolas
        myGui.SetFont(fontSize, 'Microsoft YaHei') ; 设置优先字体(24 磅) 微软雅黑
        myEdit := myGui.AddEdit(Format("vMyEdit w{1}", width))
        ; listBox 做到贴边 默认只显示 5 行、宽度 400 位置
        ; Hidden: 让控件初始为隐藏状态
        listBox := myGui.AddListBox(Format("R5 vMyChoice w{1} XM+0 Y+0 BackgroundF0F0F0 Hidden", width), [])
        button := myGui.Add('Button', "default X0 Y0 Hidden", 'OK')

        myEdit.OnEvent('Change', onEditChange)

        ; 若两个关键控件都失去焦点则关闭窗口
        myEdit.OnEvent('LoseFocus', onEditLoseFocus)
        listbox.OnEvent('LoseFocus', onListboxLoseFocus)

        ; 两个点击事件
        listbox.OnEvent('DoubleClick', onListBoxDoubleClick)
        ; 按回车会触发该 click 事件
        button.OnEvent('Click', onButtonClick)

        ; 按住 esc 销毁 窗口
        myGui.OnEvent('Escape', (*) => myGui.Destroy())

        ; 居中但是稍微往上偏移些
        myGui.Show(Format("xCenter y{1} AutoSize", A_ScreenHeight / 2 - 300))

        onEditChange(thisGui, *) {
            ; 获取输入内容
            editValue := thisGui.Value
            if (editValue == '') {
                listBox.Delete()
                listBox.Visible := false
                myGui.Show('AutoSize')
                return
            }
            listBoxDataArray := unset
            dataArray := unset
            ; 若为空则清空列表 或 大于设定长度 或 非字母和数字汉子和空格的组合则退出 \u4e00-\u9fa5 可以表示为 一-龥
            if (StrLen(editValue) <= Support_Length AND RegExMatch(editValue, '^[a-zA-Z一-龥\d]+$')) {
                ; 精确匹配失败则转到模糊匹配
                needleRegEx := ''
                Loop Parse, editValue {
                    needleRegEx .= '(' . A_LoopField . ").*"
                }
                needleRegEx := 'i)' . needleRegEx
                
                dataArray := Array()
                for it in dataList {
                    ; 只处理 app 和 web 这两种类型
                    if (it.type ~= 'i)^(?:app|web|file)$') {
                        if (Type(it.alias) == 'Array') {
                            ; 如果有则选出最匹配的 array
                            ; 最佳匹配对象
                            maxData := unset
                            Loop it.alias.Length {
                                if RegExMatch(it.alias[A_Index], needleRegEx, &regExMatchInfo) {
                                    data := {degree: computeDegree(regExMatchInfo) ; 匹配度
                                            , title: it.title ; 标题
                                            , type: it.type ; 类型
                                    }
                                    if !IsSet(maxData) {
                                        maxData := data
                                    } else if (dataArrayCompare(maxData, data) < 0)
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
            }
            if (IsSet(dataArray) AND dataArray.Length > 0) {
                dataArraySort(dataArray)
                listBoxDataArray := listBoxData(dataArray)
            } else {
                listBoxDataArray := []
            }

            ; 打开网址
            if (editValue ~= 'i)^(?:https?://)?(?:[\w-]+\.)+[\w-]+(?:/[\w-./?%&=]*)?\s*$') {
                ; 从 dava.csv 中抽取符合条件的 b 列 (http 网址)，若满足则赋值 d 列
                match := ''
                for it in dataList {
                    if (it.type == 'web' and (editValue == it.path 
                                               or editValue == SubStr(it.path, InStr(it.path, '://') + StrLen('://'))
                                               or editValue == SubStr(it.path, InStr(it.path, '://www.') + StrLen('://www.'))  
                                            )
                        ) {
                        match .= '-' . it.title
                        break
                    }
                }
                if (match == '') {
                    if (editValue ~= 'i)^(?:https?://)?im.qq.com') {
                        match .= '-' . 'QQ-轻松做自己'
                    }
                    else if (editValue ~= 'i)^(?:https?://)?(?:www.)?zhihu.com') {
                        match .= '-' . '知乎'
                    }
                    else if (editValue ~= 'i)^(?:https?://)?(?:www.)?zhipin.com') {
                        match .= '-' . 'BOSS直聘'
                    }
                }
                listBoxDataArray.push(MyActionArray[7].title . match)
            }

            if MyActionArray[1].fuhe.Call(editValue) {
                listBoxDataArray.push MyActionArray[1].title
            }
            if MyActionArray[2].fuhe.Call(editValue) {
                listBoxDataArray.push MyActionArray[2].title
            }
            if MyActionArray[3].fuhe.Call(editValue) {
                listBoxDataArray.push MyActionArray[3].title
            }
            if MyActionArray[4].fuhe.Call(editValue) {
                listBoxDataArray.push MyActionArray[4].title
            }
            if MyActionArray[5].fuhe.Call(editValue) {
                listBoxDataArray.push MyActionArray[5].title
            }

            ; 前往文件夹
            if DirExist(editValue) {
                listBoxDataArray.push MyActionArray[6].title
            }
            else if FileExist(editValue) {
                ; 抽出文件夹
                RegExMatch(editValue, '(.*[\\/]).*', &regExMatchInfo)
                if DirExist(regExMatchInfo.1)
                    listBoxDataArray.push MyActionArray[6].title
            }

            ; 显示出来
            listBox.Delete()
            listBox.Visible := listBoxDataArray.Length > 0
            if (listBox.Visible) { 
                listBox.Add(listBoxDataArray)
                listBox.Choose(1)
            }
            myGui.Show("AutoSize")
        }

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
            item := unset
            if (StrLen(listBox.Text) > 0) {
                split := StrSplit(listBox.Text, '-')
                if split.Length == 2 {
                    title := split[1]
                    type := split[2]
                    item := appFindPathByListBoxText(title, type)
                }
            }
            editValue := myEdit.Value
            ; 如果 条目 未匹配 则啥事都不做
            if (!IsSet(item) OR item == '') {
                switch {
                    case listBox.Text = MyActionArray[1].title: ; 百度搜索
                        RegExMatch(editValue, 'i)^bd(.*)', &regExMatchInfo)
                        Run 'https://www.baidu.com/s?wd=' . Trim(regExMatchInfo[1])
                    case listBox.Text = MyActionArray[2].title: ; bing 搜索
                        RegExMatch(editValue, "i)^bi(.*)", &regExMatchInfo)
                        Run 'https://cn.bing.com/search?q=' . Trim(regExMatchInfo[1])
                    case listBox.Text = MyActionArray[3].title: ; IP 搜索
                        RegExMatch(editValue, "i)^ip(.*)", &regExMatchInfo)
                        Run 'https://www.ip138.com/iplookup.php?ip=' . Trim(regExMatchInfo[1])
                    case listBox.Text = MyActionArray[4].title: ; b 站搜索
                        RegExMatch(editValue, 'i)^bl(.*)', &regExMatchInfo)
                        Run 'https://search.bilibili.com/all?keyword=' . Trim(regExMatchInfo[1])
                    case listBox.Text = MyActionArray[5].title: ; 打开文件
                        Run editValue
                    case listBox.Text = MyActionArray[6].title: ; 前往文件夹
                        if DirExist(editValue) {
                            Run editValue
                        } else {
                            RegExMatch(editValue, '(.*[\\/]).*', &regExMatchInfo)
                            Run regExMatchInfo.1
                        }
                    case 1 == InStr(listBox.Text, MyActionArray[7].title): ; 打开网址
                        if not InStr(editValue, 'http')
                            editValue := "http://" . editValue
                        Run editValue
                    case MyActionArray[8].title = editValue: ; 如果输入的是 本机IP 则弹窗
                        addresses := SysGetIPAddresses()
                            msg := "IP 地址:`n"
                            for address in addresses
                                msg .= address "`n"
                            MsgBox msg
                }                
            } else if (item.type = 'app') {
                ; 微信的特殊处理：自动登录微信
                if (item.title == '微信') {
                    try {
                        Run item.path,,, &pid
                        WinWaitActive "ahk_pid " pid
                        ; 手动等待 1.1 秒，否则可能会跳到扫码页
                        Sleep 1100
                        Send "{Space}"
                    } catch {
                        MsgBox("找不到目标应用")
                    }
                } else {
                    ActivateOrRun(item.winTitle, item.path)
                }
            } else {
                Run(item.path)
            }
            MyGui.Destroy()
        }

        onButtonClick(*) {
            ; 如果 listbox 有焦点
            if (listBox.Focused) {
                onListBoxDoubleClick()
            } else {
                ; 焦点在 edit，如果列表有匹配项 则获取编辑框文本内容
                Trim(myEdit.Value) == '' ? MsgBox('输入内容不能为空') : onListBoxDoubleClick()
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
        if (item < 0)
            break
        degree += 2 ** item
    }
    return degree
}

class MyAction {
    __new(title, regex, fuhe?) {
        this.title := title
        this.regex := regex
        if IsSet(fuhe) {
            this.fuhe := fuhe
        }
    }
}

MyActionArray := [
    MyAction('百度搜索', '我', k => k ~= 'i)^bd')
    , MyAction('bing搜索', '人', k => k ~= 'i)^bi')
    , MyAction('IP搜索', '性', k => k ~= 'i)^ip')
    , MyAction('b站搜索', '防诈', k => k ~= 'i)^bl')
    , MyAction('打开文件', '不要', k => FileExist(k) and not DirExist(k))

    , MyAction('前往文件夹', '骗人')
    , MyAction('打开网址', '防着')
    , MyAction('本机IP', '别有目的')
]
