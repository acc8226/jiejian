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
            if StrLen(editValue) <= Support_Length AND RegExMatch(editValue, '^[a-zA-Z一-龥\d]+$') {
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
                        if 'Array' == Type(it.alias) {
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
            } else listBoxDataArray := []

            for action in MyActionArray {
                if (action.type == 'list' and action.fuhe.Call(editValue)) {
                    if action.HasOwnProp('fuheThen')
                        listBoxDataArray.push(action.title . action.fuheThen.Call(editValue))
                    else listBoxDataArray.push(action.title)
                }
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
            if (not listBox.Focused)
                myGui.Destroy()
        }

        onListboxLoseFocus(*) {
            if (not myEdit.Focused)
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
                for action in MyActionArray {
                    if (action.type == 'list') {
                        if 1 == InStr(listBox.Text, action.title) {
                            action.pao.Call(editValue)
                            break
                        }
                    } else if (action.type == 'edit') {
                        if (editValue = action.title) {
                            action.pao.Call()
                            break
                        }
                    }
                }
            } else if (item.type = 'app') {
                ; 微信的特殊处理：自动登录微信
                if (item.title == '微信') {
                    try {
                        Run item.path,,, &pid
                        WinWaitActive "ahk_pid " pid
                        ; 手动等待 1.1 秒，否则可能会跳到扫码页
                        Sleep(1100)
                        Send "{Space}"
                    } catch {
                        MsgBox("找不到目标应用")
                    }
                } else ActivateOrRun(item.winTitle, item.path)
            } else Run(item.path)
            MyGui.Destroy()
        }

        onButtonClick(*) {
            ; 如果 listbox 有焦点
            if (listBox.Focused)
                onListBoxDoubleClick()
            else Trim(myEdit.Value) == '' ? MsgBox('输入内容不能为空') : onListBoxDoubleClick() ; 焦点在 edit，如果列表有匹配项 则获取编辑框文本内容
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
    __new(title, type, fuhe?, fuheThen?, pao?) {
        this.title := title
        this.type := type
        ; 是否符合匹配
        if IsSet(fuhe) {
            this.fuhe := fuhe
        }
        ; 匹配后对 title 的增强
        if IsSet(fuheThen) {
            this.fuheThen := fuheThen
        }
        ; 匹配后选定的行为
        if IsSet(pao) {
            this.pao := pao
        }
    }
}

MyActionArray := [
    MyAction('打开网址', 'list', k => k ~= 'i)^(?:https?://)?(?:[\w-]+\.)+[\w-]+(?:/[\w-./?%&=]*)?\s*$', titleTrans7, pao7) ; 是否提前些比较好
    , MyAction('百度搜索', 'list', k => k ~= 'i)^bd',, pao1)
    , MyAction('bing搜索', 'list', k => k ~= 'i)^bi',, pao2) 
    , MyAction('IP搜索', 'list', k => k ~= 'i)^ip',, pao3)
    , MyAction('b站搜索', 'list', k => k ~= 'i)^bl',, pao4)
    
    , MyAction('打开文件', 'list', k => FileExist(k) and not DirExist(k),, input => Run(input)) 
    , MyAction('前往文件夹', 'list', fuhe6,, pao6)
    , MyAction('睡眠', 'list', k => k == '睡' or k == '睡眠',, SystemSleep)
    , MyAction('锁屏', 'list', k => k == '锁' or k == '锁屏',, SystemLockScreen)
    , MyAction('关机', 'list', k => k == '关' or k == '关机',, SystemShutdown)

    , MyAction('本机IP', 'edit', ,, pao8)
    ; , MyAction('关机', 'edit', ,, () => Run('shutdown -s -t 0'))
]

fuhe6(key) {
    isMatch := unset
    if DirExist(key) {
        isMatch := true
    } else if FileExist(key) {
        ; 抽出文件夹
        RegExMatch(key, '(.*[\\/]).*', &regExMatchInfo)
        isMatch := DirExist(regExMatchInfo.1)
    } else {
        isMatch := false
    }
    return isMatch
}

titleTrans7(editValue) {
    ; 对网址进行细化处理
    ; 从 dava.csv 中抽取符合条件的 b 列 (http 网址)，若满足则赋值 d 列
    match := ''
    for (it in dataList) {
        if (it.type == 'web') {
            if (editValue == it.path) {
                match := '-' . it.title
            } else if (SubStr(editValue, -1) == '/') {
                if (editValue == SubStr(it.path, InStr(it.path, '://') + StrLen('://')) . '/' ; 匹配 www.soso.com/
                    OR editValue == SubStr(it.path, InStr(it.path, '://www.') + StrLen('://www.')) . '/' ; 匹配 soso.com/
                )
                    match := '-' . it.title
            } else {
                if (editValue == SubStr(it.path, InStr(it.path, '://') + StrLen('://')) ; 匹配 www.soso.com
                    OR editValue == SubStr(it.path, InStr(it.path, '://www.') + StrLen('://www.')) ; 匹配 soso.com
                )
                    match := '-' . it.title
            }
            if (match !== '') {
                break
            }
        }        
    }
    ; 预设匹配
    if (match == '') {
        if (editValue ~= 'i)^(?:https?://)?im.qq.com/?$') {
            match := '-QQ-轻松做自己'
        } else if (editValue ~= 'i)^(?:https?://)?(?:www.)?zhihu.com/?$') {
            match := '-知乎'
        } else if (editValue ~= 'i)^(?:https?://)?(?:www.)?zhipin.com/?$')
            match := '-BOSS直聘'
        ; 旅游
        else if (editValue ~= 'i)^(?:https?://)?(?:www.)?ctrip.com/?$')
            match := '-携程网'
        else if (editValue ~= 'i)^(?:https?://)?(?:www.)?mafengwo.cn/?$')
            match := '-马蜂窝'
        else if (editValue ~= 'i)^(?:https?://)?(?:www.)?cncn.com/?$')
            match := '-欣欣旅游'
        ; 小说
        else if (editValue ~= 'i)^(?:https?://)?book.qq.com/?$')
            match := '-QQ阅读'
        else if (editValue ~= 'i)^(?:https?://)?(?:www.)?jjwxc.net/?$')
            match := '-晋江文学城'
        else if (editValue ~= 'i)^(?:https?://)?(?:www.)?qidian.com/?$')
            match := '-起点中文网'
        ; 购物
        else if (editValue ~= 'i)^(?:https?://)?(?:www.)?apple.com.cn/?$')
            match := '-Apple (中国大陆) '
        ; 其他
        else if (editValue ~= 'i)^(?:https?://)?(?:www.)?doubao.com/?$')
            match := '-豆包 - 抖音旗下 AI 智能助手'
        else if (editValue ~= 'i)^(?:https?://)?(?:www.)?ithome.com/?$')
            match := '-IT之家'
        else if (editValue ~= 'i)^(?:https?://)?(?:www.)?ixigua.com/?$')
            match := '-西瓜视频'
        else if (editValue ~= 'i)^(?:https?://)?nav.feipig.fun/?$')
            match := '-ac网址导航'
        else if (editValue ~= 'i)^(?:https?://)?(?:www.)?iplaysoft.com/?$')
            match := '-异次元软件世界-软件改变生活！'
        else if (editValue ~= 'i)^(?:https?://)?(?:www.)?appinn.com/?$')
            match := '-小众软件 - 分享免费、小巧、实用、有趣、绿色的软件'
        else if (editValue ~= 'i)^(?:https?://)?(?:www.)?sspai.com/?$')
            match := '-少数派-高效工作，品质生活'
        else if (editValue ~= 'i)^(?:https?://)?(?:www.)?ruancan.com/?$')
            match := '-软餐-新鲜软件资讯'
        else if (editValue ~= 'i)^(?:https?://)?y.qq.com/?$')
            match := '-QQ音乐'
        else if (editValue ~= 'i)^(?:https?://)?filehelper.weixin.qq.com/?$')
            match := '-微信文件传输助手网页版'
        else if (editValue ~= 'i)^(?:https?://)?sj.qq.com/?$')
            match := '-应用宝'
        else if (editValue ~= 'i)^(?:https?://)?(?:www.)?wenshushu.com/?$')
            match := '-文叔叔-传文件，找文叔叔（大文件、永不限速）'    
    }
    return match
}

pao1(input) {
    RegExMatch(input, 'i)^bd(.*)', &regExMatchInfo)
    Run('https://www.baidu.com/s?wd=' . Trim(regExMatchInfo[1]))
}

pao2(input) {
    RegExMatch(input, "i)^bi(.*)", &regExMatchInfo)
    Run 'https://cn.bing.com/search?q=' . Trim(regExMatchInfo[1])
}

pao3(input) {
    RegExMatch(input, "i)^ip(.*)", &regExMatchInfo)
    Run 'https://www.ip138.com/iplookup.php?ip=' . Trim(regExMatchInfo[1])
}

pao4(input) {
    RegExMatch(input, 'i)^bl(.*)', &regExMatchInfo)
    Run('https://search.bilibili.com/all?keyword=' . Trim(regExMatchInfo[1]))
}

pao6(input) {
    if DirExist(input) {
        Run(input)
    } else {
        RegExMatch(input, '(.*[\\/]).*', &regExMatchInfo)
        Run(regExMatchInfo.1)
    }
}

pao7(input) {
    if not InStr(input, 'http')
        input := "http://" . input
    Run(input)
}

pao8() {
    addresses := SysGetIPAddresses()
    msg := "IP 地址:`n"
    for address in addresses
        msg .= address "`n"
    MsgBox(msg)
}
