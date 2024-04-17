#Include "Sort.ahk"

; 正则匹配最大支持长度默认为 32 位
Support_Length := 32
DataFilterReg := 'i)^(?:' . DataType.app . '|' . DataType.file . '|' . DataType.web . '|' . DataType.inner . '|' . DataType.ext . ')$'

; 设置监听
#HotIf WinActive("快捷启动 ahk_class AutoHotkeyGUI")
~Down::{
    ; 当前焦点在 edit 上
    if myGui.FocusedCtrl.type = 'Edit' {
        ; 且如果 listbox 有东西 则 焦点移动到 listbox
        if (StrLen(myGui['listbox1'].Text) > 0) {
            ControlFocus 'listbox1'
        }
    }
}
~UP::{
    ; 如果焦点在 listbox 首项 再向上则焦点移动到 edit
    if myGui.FocusedCtrl.type = 'ListBox' {
        if (myGui['listbox1'].value) == 1 {
            ControlFocus 'Edit1'
        }
    }
}
#HotIf

Anyrun() {
    global myGui

    guiTitle := "快捷启动"
    ; 检查窗口是否已经存在，如果窗口已经存在，如果窗口不存在，则创建新窗口 
    if WinExist(guiTitle)
        WinClose ; 使用由 WinExist 找到的窗口
    else {
        width := 432
        ; S: 尺寸(单位为磅)
        ; AlwaysOnTop 使窗口保持在所有其他窗口的顶部
        ; Owner 可以让当前窗口从属于另一个窗口。从属的窗口默认不显示在任务栏, 并且它总是显示在其父窗口的上面. 当其父窗口销毁时它也被自动销毁
        ; -Caption 移除背景透明的窗口的边框和标题栏
        ; -Resize 禁止用户重新调整窗口的大小
        myGui := Gui('AlwaysOnTop Owner -Caption -Resize', guiTitle)
        ; 横向和纵向边框收窄
        myGui.MarginX := 3.9
        myGui.MarginY := 3.2
        fontSize := 's21'
        myGui.SetFont(fontSize, 'Consolas') ; 设置兜底字体(21 磅) Consolas
        myGui.SetFont(fontSize, 'Microsoft YaHei') ; 设置优先字体(21 磅) 微软雅黑
        myEdit := myGui.AddEdit(Format("w{1}", width))
        ; R5 做到贴边 默认只显示 5 行
        ; Hidden: 让控件初始为隐藏状态
        listBox := myGui.AddListBox(Format("R5 w{1} XM+0 Y+0 BackgroundF0F0F0 Hidden", width))
        button := myGui.Add('Button', "default X0 Y0 Hidden", 'OK')

        myEdit.OnEvent('Change', onEditChange)

        ; 若两个关键控件都失去焦点则关闭窗口
        myEdit.OnEvent('LoseFocus', onEditLoseFocus)
        listbox.OnEvent('LoseFocus', onListboxLoseFocus)

        ; 双击列表条目 触发事件
        listbox.OnEvent('DoubleClick', onListBoxDoubleClick)
        ; 按回车触发 点击事件
        button.OnEvent('Click', onButtonClick)

        ; 按住 esc 销毁 窗口
        myGui.OnEvent('Escape', (*) => myGui.Destroy())

        ; 居中但是稍微往上偏移些
        myGui.Show(Format("xCenter y{1} AutoSize", A_ScreenHeight / 2 - 300))

        onEditChange(thisGui, *) {
            ; 一旦文本框有变化立即清空
            listBox.Delete()
            ; 获取输入内容
            editValue := thisGui.Value
            if (editValue == '') {
                listBox.Visible := false
                myGui.Show('AutoSize')
                return
            }
            listBoxDataArray := unset
            dataArray := unset
            ; 精确匹配失败 将 转到模糊匹配
            ; 若为空则清空列表 或 大于设定长度 或 非字母和数字汉子和空格的组合则退出 \u4e00-\u9fa5 可以表示为 一-龥
            if (StrLen(editValue) <= Support_Length AND editValue ~= '^[a-zA-Z一-龥\d]+$') {
                needleRegEx := ''
                Loop Parse, editValue
                    needleRegEx .= '(' . A_LoopField . ").*"
                needleRegEx := 'i)' . needleRegEx
                
                dataArray := Array()
                for it in dataList {
                    if (it.type ~= DataFilterReg) {
                        if 'Array' == Type(it.alias) {
                            ; 如果有则选出最匹配的 array
                            ; maxData 为 最佳匹配对象
                            maxData := unset
                            Loop it.alias.Length {
                                ; 如果能匹配
                                if RegExMatch(it.alias[A_Index], needleRegEx, &regExMatchInfo) {
                                    data := {degree: computeDegree(regExMatchInfo) ; 匹配度
                                            , title: it.title ; 标题
                                            , type: it.type ; 类型
                                    }
                                    if !IsSet(maxData)
                                        maxData := data
                                    else if (dataArrayCompare(maxData, data) < 0)
                                        maxData := data
                                }
                            }
                            if IsSet(maxData)
                                dataArray.Push(maxData)
                        } else if RegExMatch(it.alias, needleRegEx, &regExMatchInfo)
                            ; 如果能匹配
                            dataArray.Push({degree: computeDegree(regExMatchInfo)
                                            , title: it.title
                                            , type: it.type
                            })
                    }
                }
            }
            if (IsSet(dataArray) AND dataArray.Length > 0) {
                dataArraySort(dataArray)
                listBoxDataArray := listBoxData(dataArray)
            } else
                listBoxDataArray := []

            ; 搜索匹配
            ; 查询出所有搜索，如果前缀满足则添加到列表
            for it in dataList
                if (it.type == '搜索')
                    if 1 = InStr(editValue, it.alias)
                        listBoxDataArray.push(it.title . '-' . it.type)
                
            ; 模糊匹配 按照顺序
            for action in MyActionArray {
                if (action.type == 'list' and action.fuhe.Call(editValue))
                    action.HasOwnProp('fuheThen') ? listBoxDataArray.push(action.title . action.fuheThen.Call(editValue)) : listBoxDataArray.push(action.title)
            }
            ; 显示出来
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

        ; listbox 和 序号（从 1 开始）
        onListBoxDoubleClick(listBoxObj?, info?) {
            ; 此时 listbox 必定有焦点，则根据 title 反查 path
            item := unset
            if (StrLen(listBox.Text) > 0) {
                split := StrSplit(listBox.Text, '-')
                ; 分离出类型 和 名称
                if split.Length == 2 {
                    title := split[1]
                    type := split[2]
                    item := findPathByListBoxText(title, type)
                    ; 能否根据序号直接找到 item 呢，而不是通过反查，综合评估感觉不高效所以不采用
                }
            }
            editValue := myEdit.Value

            ; 模糊匹配：（打开网址 打开文件 前往文件夹 等）如果 条目 不匹配 则啥事都不做
            if (!IsSet(item) OR item == '') {
                for action in MyActionArray {
                    ; 如果是 list 则表示必须在列表中存在
                    if (action.type = 'list') {
                        ; 必须满足匹配规则
                        if 1 == InStr(listBox.Text, action.title) {
                            action.pao.Call(editValue)
                            break
                        }
                    }
                    ; 不在列表中显示，但是依旧有作用
                    else if (action.type = 'edit') {
                        ; 没有匹配规则
                        if (editValue = action.title) {
                            action.pao.Call()
                            break
                        }
                    }
                }
            } else if (item.type = DataType.search) { ; 模糊处理：搜索
                ; 拿到 alias 例如为 bd
                ; 取出除 bd 开头的字符串
                ; 进行拼接
                Run(item.path . SubStr(editValue, StrLen(item.alias) + 1))
            } else if (item.type = DataType.inner) { ; 精确处理：内部
                switch item.title {
                    case '锁屏': SystemLockScreen()
                    case '睡眠': SystemSleep()
                    case '关机': 
                        if MsgBox("是否现在关机?",, "YesNo") = "Yes"
                            SystemShutdown()
                    case '息屏': SystemSleepScreen()
                    case '重启': 
                        if MsgBox("是否现在重启?",, "YesNo") = "Yes"
                            SystemReboot()
                    case '屏幕保护程序': SendMessage 0x0112, 0xF140, 0,, "Program Manager" ; 0x0112 为 WM_SYSCOMMAND, 而 0xF140 为 SC_SCREENSAVE.
                    case '清空回收站': FileRecycleEmpty()
                    case '注销': SystemLogoff()

                    case '静音': Send '{Volume_Mute}'
                    case '暂停': Send '{Media_Play_Pause}'
                    case '上一曲': Send '{Media_Prev}'
                    case '下一曲': Send '{Media_Next}'

                    case '终端': Run(A_ComSpec) ; 在用户根目录打开文件夹
                    case '网络连接': Run("shell:ConnectionsFolder")
                    case '我的下载': Run("shell:downloads")
                    case '收藏夹': Run("shell:Favorites")
                    case '字体': Run("shell:Fonts")
                    case '打印机': Run("shell:PrintersFolder")
                    case '我的文档': Run("shell:Personal")
                    case '回收站': Run("shell:RecycleBinFolder")
                    case '我的图片': Run("shell:My Pictures")
                    case '我的视频': Run("shell:My Video")
                    case '我的音乐': Run("shell:My Music")
                    
                }
            } else if (item.type = DataType.ext) ; 精确处理：外部
                Run('jiejian' . (A_PtrSize == 4 ? '32' : '64') . '.exe /script ' . item.path)
            ; 兜底 精确处理：app file web 程序文件网址类型
            else {
                if (item.type = DataType.web)
                    jumpURL(item.path)
                else if (item.type = DataType.app and item.title == '微信') { ; 对微信特殊处理：自动登录微信
                    try {
                        Run item.path,,, &pid
                        WinWaitActive "ahk_pid " pid
                        ; 手动等待 1.1 秒，否则可能会跳到扫码页
                        Sleep(1100)
                        Send "{Space}"
                    } catch
                        MsgBox("找不到目标应用")
                } else
                    ; 启动逻辑为每次都新建应用，而非打开已有应用 ActivateOrRun('', item.path)
                    Run(item.path)
            }
            MyGui.Destroy()
        }

        onButtonClick(*) {
            ; 如果 listbox 有焦点
            if (listBox.Focused)
              onListBoxDoubleClick(listBox)
            else
              ; 如果焦点在 编辑框 且按下回车则会触发弹窗提示；否则表示焦点在 edit，如果列表有匹配项 则获取编辑框文本内容
              Trim(myEdit.Value) == '' ? MsgBox('输入内容不能为空') : onListBoxDoubleClick(listBox)
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
    ; 显示标题
    ; 类型 edit or list
    ; 过滤条件
    ; 拼接到栏目上
    ; 执行动作
    __new(title, type, fuhe?, fuheThen?, pao?) {
        this.title := title
        this.type := type
        ; 是否符合匹配
        if IsSet(fuhe)
            this.fuhe := fuhe

        ; 匹配后对 title 的增强
        if IsSet(fuheThen)
            this.fuheThen := fuheThen

        ; 匹配后选定的行为
        if IsSet(pao)
            this.pao := pao
    }
}

MyActionArray := [
    MyAction('在 bash 中打开', 'list', path => IsSet(MY_BASH) and FileExist(path),, openInBash)
    , MyAction('打开网址', 'list', path => path ~= 'i)^(?:https?://)?(?:[\w-]+\.)+[\w-]+(?:/[\w-./?%&=]*)?\s*$', getWebsiteName, jumpURL) ; 是否提前些比较好，不用了，兜底挺好
    , MyAction('打开文件', 'list', path => FileExist(path) AND NOT DirExist(path),, path => Run(path)) 
    , MyAction('前往文件夹', 'list', isDir,, openDir)
    , MyAction('查看属性', 'list', path => FileExist(path),, path => Run('properties "' . path . '"'))
    , MyAction('打印文件', 'list', path => FileExist(path) AND NOT DirExist(path) And path ~= 'i).+\.(?:BMP|GIF|png|jpe?g|pdf|docx?|pptx?|xlsx?)$',, path => Run('print "' . path . '"'))
    , MyAction('删除文件', 'list', path => FileExist(path),, delFileOrDir)
    , MyAction('在终端中打开', 'list', path => FileExist(path),, openInTerminal)
    ; 彩蛋 
    , MyAction('bjip', 'edit',,, getIPAddresses) ; 本机 IP
]

; 是否是文件夹，如果当前是文件则提取
isDir(key) {
    isMatch := unset
    if DirExist(key) {
        isMatch := true
    } else if FileExist(key) {
        ; 抽出文件夹
        if RegExMatch(key, '.*[\\/]', &regExMatchInfo)
            isMatch := DirExist(regExMatchInfo.0)
        else 
            isMatch := false
    } else
        isMatch := false
    return isMatch
}

getWebsiteName(editValue) {
    ; 对网址进行细化处理
    ; 从 dava.csv 中抽取符合条件的 b 列 (http 网址)，若满足则赋值 d 列
    match := ''
    for (it in dataList) {
        if (it.type == DataType.web) {
            ; 完全匹配
            if (editValue == it.path) {
                match := '-' . it.title
                break
            } else {
                ; 可以匹配 www.doubao.com doubao.com https://www.doubao.com http://www.doubao.com https://www.doubao.com/ http://www.doubao.com/a/b.html 但不能匹配 abc.doubao.com https://edf.doubao.com http://ghi.doubao.com
                ; 提取关键部位
                ; 去掉 www
                newUri := unset
                if 1 == InStr(it.path, 'http://www.') OR 1 == InStr(it.path, 'https://www.') OR 1 == InStr(it.path, 'www.') {
                    uri := SubStr(it.path, InStr(it.path, 'www.') + StrLen('www.'))
                    newUri := 'i)^(?:https?://)?(?:www\.)?' . StrReplace(uri, '.', "\.") . '(?:/.*)?$'
                }
                ; 去掉 ://
                else {
                    if InStr(it.path, '://')
                        uri := SubStr(it.path, InStr(it.path, '://') + StrLen('://'))
                    else
                        uri := it.path
                    ; 如果是顶级域名（简单认为分段数为 2）则加上 www
                    is_top_level_domain := 2 == StrSplit(uri, '.').Length
                    newUri := 'i)^(?:https?://)?' . (is_top_level_domain ? '(?:www\.)?' : '') . StrReplace(uri, '.', "\.") . '(?:/.*)?$'
                } 
                if (editValue ~= newUri) {
                    match := '-' . it.title
                    break
                }
            }
        }
    }
    return match
}

openDir(path) {
    if DirExist(path) {
        Run(path)
    } else {
        RegExMatch(path, '.*[\\/]', &regExMatchInfo)
        Run(regExMatchInfo.0)
    }
}

delFileOrDir(path) {
    if DirExist(path)
        DirDelete(path)
    else
        FileDelete (path)
}

openInTerminal(path) {
    ; 在终端中打开所在文件夹
    if DirExist(path) {
        ; 盘符根目录需要以 \ 结尾才生效
        endChar := SubStr(path, StrLen(path))
        addSomething := (endChar = '\' OR endChar = '/') ? "" : "\"
        Run(A_ComSpec, path . addSomething)
    } else {
        RegExMatch(path, '.*[\\/]', &regExMatchInfo)
        Run(A_ComSpec, regExMatchInfo.0)
    }
}

openInBash(path) {
    global MY_BASH

    ; 在 bash 中打开所在文件夹
    if DirExist(path) {
        ; 盘符根目录需要以 \ 结尾才生效
        endChar := SubStr(path, StrLen(path))
        addSomething := (endChar = '\' OR endChar = '/') ? "" : "\"
        Run(MY_BASH, path . addSomething)
    } else {
        RegExMatch(path, '.*[\\/]', &regExMatchInfo)
        Run(MY_BASH, regExMatchInfo.0)
    }
}

getIPAddresses() {
    addresses := SysGetIPAddresses()
    msg := "IP 地址:`n"
    for address in addresses
        msg .= address "`n"
    MsgBox(msg)
}
