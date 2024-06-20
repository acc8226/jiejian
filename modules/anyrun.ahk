#Include "Sort.ahk"

; 正则匹配最大支持长度默认为 32 位
global SUPPORT_LEN := 32
global DATA_FILTER_REG := 'i)^(?:' . DataType.app . '|' . DataType.file . '|' . DataType.web . '|' . DataType.inner . '|' . DataType.ext . '|' . DataType.dl . ')$'
; 端口判断过于简单 但是基本够用了
global IS_HTTP_Reg := 'i)^(?:https?://)?' ; 协议
                    ; local 或 ip地址 或 英文网址
                    . '(?:localhost'
                        . '|(?:\d{1,2}|1\d{2}|2[0-4]\d|25[0-5])\.(?:\d{1,2}|1\d{2}|2[0-4]\d|25[0-5])\.(?:\d{1,2}|1\d{2}|2[0-4]\d|25[0-5])\.(?:\d{1,2}|1\d{2}|2[0-4]\d|25[0-5])' 
                        . '|(?!(?:\d+\.)+\d+)(?:[\w-一-龥]+\.)+[\w-一-龥]+' ; 华为.网址
                        ; 警惕 中文.com 的网络诈骗：有些诈骗者可能会利用账户变更的名义来诱骗用户泄露个人信息。如果收到任何要求你提供账户信息的邮件或消息，务必通过官方客服渠道进行核实
                        ; .com 是全球最广泛认可和使用的顶级域名，而.网址是中国的国家级域名，但是在国内还是 .网址比较正规，因为要有备案。 我就知道 中文.com 的诈骗案例
                    . ')'
                    . '(:(?!0)(?![7-9]\d{4})\d{1,5})?' ; 端口
                    . '(?:/[\w-./?%&=#一-龻]*)?\s*$' ; 路径（可以包含中文）
global MY_GUI
global MY_GUI_WIDTH := 432
global MY_GUI_MARGINX_X := 2.8
global MY_GUI_TITLE := '快捷启动'

global MyActionArray := [
    MyAction('打开网址', 'list', isLegitimateWebsite, appendWebsiteName, jumpURL), ; 是否提前些比较好，不用了，兜底挺好
    ; 打开（文件，可能是 mp3 或者 mp4 或者 mov）
    MyAction('打开', 'list', path => isFileOrDirExists(path) && NOT DirExist(path), appendFileType, path => Run(path)) ,
    MyAction('前往文件夹', 'list', isDir,, openDir),
    MyAction('查看属性', 'list', isFileOrDirExists,, path => Run('properties "' . path . '"')),
    MyAction('打印文件', 'list', path => path ~= 'i).+\.(?:bmp|docx?|gif|jpe?g|ofd|pdf|png|pptx?|xlsx?)$' && isFileOrDirExists(path) && NOT DirExist(path),, path => Run('print "' . path . '"')),
    MyAction('删除文件', 'list', isFileOrDirExists,, delFileOrDir),
]
if IsSet(MY_BASH)
    MyActionArray.Push(MyAction('在 Bash 中打开', 'list', isFileOrDirExists,, openInBash))
useTerminal := IsSet(MY_NEW_TERMINAL) ? openInNewTerminal : openInTerminal
MyActionArray.Push(MyAction('在终端中打开', 'list', isFileOrDirExists,, useTerminal))
if IsSet(MY_VSCode)
    MyActionArray.Push(MyAction('在 VSCode 中打开', 'list', isFileOrDirExists,, openInVSCode))
if IsSet(MY_IDEA)
    MyActionArray.Push(MyAction('在 IDEA 中打开', 'list', isFileOrDirExists,, openInIDEA))

; 彩蛋 本机 IP
MyActionArray.Push(MyAction('myip', 'edit',,, getIPAddresses))

; 设置监听
#HotIf WinActive(MY_GUI_TITLE . " ahk_class i)^AutoHotkeyGUI$")
~Down::{
    ; 当前焦点在 edit 上 且如果 listbox 有东西 则 焦点移动到 listbox
    if (MY_GUI.FocusedCtrl.type = 'Edit' && StrLen(MY_GUI['listbox1'].Text) > 0)
        ControlFocus 'listbox1'
}
~UP::{
    ; 如果焦点在 listbox 首项 再向上则焦点移动到 edit
    if (MY_GUI.FocusedCtrl.type = 'ListBox' && MY_GUI['listbox1'].value == 1)
        ControlFocus 'Edit1'
}
#HotIf

anyrun() {
    ; reload 过程中 MY_GUI_TITLE 会未定义
    if !IsSet(MY_GUI_TITLE)
        return
    ; 检查窗口是否已经存在，如果窗口已经存在，如果窗口不存在，则创建新窗口
    if WinExist(MY_GUI_TITLE)
        WinClose ; 使用由上一句 WinExist 找到的窗口
    else {
        ; S: 尺寸(单位为磅)
        ; AlwaysOnTop 使窗口保持在所有其他窗口的顶部
        ; Owner 可以让当前窗口从属于另一个窗口。从属的窗口默认不显示在任务栏, 并且它总是显示在其父窗口的上面. 当其父窗口销毁时它也被自动销毁
        ; -Caption 移除背景透明的窗口的边框和标题栏
        ; -Resize 禁止用户重新调整窗口的大小
        global MY_GUI := Gui('AlwaysOnTop Owner -Caption -Resize', MY_GUI_TITLE)
        ; 横向和纵向边框收窄
        MY_GUI.MarginY := MY_GUI.MarginX := MY_GUI_MARGINX_X
        fontSize := 's21'
        MY_GUI.SetFont(fontSize, 'Consolas') ; 设置兜底字体(21 磅) Consolas
        MY_GUI.SetFont(fontSize, 'Microsoft YaHei') ; 设置优先字体(21 磅) 微软雅黑
        myEdit := MY_GUI.AddEdit(Format("w{1}", MY_GUI_WIDTH))
        ; R5：做到贴边 默认只显示 5 行
        ; Hidden：让控件初始为隐藏状态
        listBox := MY_GUI.AddListBox(Format("R5 w{1} XM+0 Y+0 BackgroundF0F0F0 Hidden", MY_GUI_WIDTH))
        button := MY_GUI.Add('Button', "default X0 Y0 Hidden", 'OK')

        myEdit.OnEvent('Change', onEditChange)

        ; 若两个关键控件都失去焦点则关闭窗口
        myEdit.OnEvent('LoseFocus', onEditLoseFocus)
        listbox.OnEvent('LoseFocus', onListboxLoseFocus)

        ; 双击列表条目 触发事件
        listbox.OnEvent('DoubleClick', onListBoxDoubleClick)
        ; 按回车触发 点击事件
        button.OnEvent('Click', onButtonClick)

        ; 按住 esc 销毁 窗口
        MY_GUI.OnEvent('Escape', onEscape)

        ; 居中但是稍微往上偏移些
        MY_GUI.Show(Format("xCenter y{1} AutoSize", A_ScreenHeight / 2 - 300))

        ; 判断剪切板有没有内容 如果输入内容是文件或者网址 且离最后一次 ctrl + c/x 操作小于 13 秒则打开 anyrun 组件 这样给用户的自主性更大           
        if (A_Clipboard != '' && DateDiff(A_NowUTC, CTRL_TIMESTAMP, 'Seconds') < 13) {
            pasteText := Trim(A_Clipboard, ' `t`r`n')
            if (pasteText ~= IS_HTTP_Reg || FileExist(pasteText))
                Send "^v"
        }

        onEscape(*) {
            if IsSet(MY_GUI) {
                MY_GUI.Destroy()
                MY_GUI := unset
            }
        }

        onEditChange(thisGui, *) {
            ; 一旦文本框有变化立即清空
            listBox.Delete()
            ; 获取文本框输入内容
            editValue := thisGui.Value
            if (editValue == '') {
                listBox.Visible := false
                MY_GUI.Show('AutoSize')
                return
            }
            dataArray := unset
            ; 精确匹配失败 将 转到模糊匹配
            ; 若为空则清空列表 或 大于设定长度 或 非字母和数字汉子和空格的组合则退出 \u4e00-\u9fa5 可以表示为 一-龥
            if (StrLen(editValue) <= SUPPORT_LEN && editValue ~= '^[a-zA-Z一-龥\d]+$') {
                needleRegEx := ''
                Loop Parse, editValue
                    needleRegEx .= '(' . A_LoopField . ").*"
                needleRegEx := 'i)' . needleRegEx
                
                dataArray := Array()
                for it in DATA_LIST {
                    if (it.type ~= DATA_FILTER_REG) {
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
                                            , title: it.title ; . '-' . computeDegree(regExMatchInfo) 测试用
                                            , type: it.type
                            })
                    }
                }
            }
            listBoxDataArray := unset
            if (NOT IsSet(dataArray) || dataArray.Length == 0)
                listBoxDataArray := []
            else {
                dataArraySort(dataArray)
                listBoxDataArray := listBoxData(dataArray)
            }

            ; 搜索匹配
            ; 查询出所有搜索，如果前缀满足则添加到列表
            for it in DATA_LIST {
                if (it.type == DataType.action and 1 = InStr(editValue, it.alias))                        
                    listBoxDataArray.push(it.title . '-' . it.type)
            }
                
            ; 模糊匹配 按照顺序
            for action in MyActionArray {
                ; 如果是 list 类型 且 符合条件
                if (action.type = 'list' && action.isMatch.Call(editValue)) {
                    if action.HasOwnProp('appendTitle') {
                        ; 最终的标题
                        listBoxDataArray.push(action.title . action.appendTitle.Call(editValue))
                    } else {
                        listBoxDataArray.push(action.title)
                    }
                }
            }
            if IsSet(MY_GUI) {
                ; 显示出来
                listBox.Visible := listBoxDataArray.Length > 0
                if (listBox.Visible) { 
                    listBox.Add(listBoxDataArray)
                    listBox.Choose(1)
                }
                MY_GUI.Show("AutoSize")
            } else {
                MsgBox('anyrun 组件异常销毁', APP_NAME)
            }
        }

        onEditLoseFocus(*) {
            if (IsSet(MY_GUI) && !listBox.Focused) {
                MY_GUI.Destroy()
                MY_GUI := unset
            }
        }

        onListboxLoseFocus(*) {
            if (IsSet(MY_GUI) && !myEdit.Focused) {
                MY_GUI.Destroy()
                MY_GUI := unset                
            }
        }

        ; listbox 和 序号（从 1 开始）
        onListBoxDoubleClick(listBoxObj?, info?) {
            ; 此时 listbox 必定有焦点，则根据 title 反查 path
            item := unset
            if (StrLen(listBox.Text) > 0) {
                split := StrSplit(listBox.Text, '-')
                ; 分离出类型 和 名称
                if split.Length == 2 {
                    type := split[2]
                    title := split[1]
                    item := findItemByTypeAndTitle(type, title)
                    ; 能否根据序号直接找到 item 呢，而不是通过反查，感觉不高效因此不采用
                }
            }
            editValue := myEdit.Value

            ; 不能精确匹配，则尝试（打开网址 打开文件 前往文件夹 等），否则无事发生
            if (!IsSet(item) || item == '') {
                for action in MyActionArray {
                    ; 如果是 list 则表示必须在列表中存在
                    if (action.type = 'list') {
                        ; 必须满足匹配规则：action.title 在 listBox.Text 首部
                        if (1 == InStr(listBox.Text, action.title)) {
                            action.run.Call(editValue)
                            break
                        }
                    }
                    ; 不在列表中显示，但是依旧有作用
                    else if (action.type = 'edit') {
                        ; 没有匹配规则
                        if (editValue = action.title) {
                            action.run.Call()
                            break
                        }
                    }
                }
            }
            ; 用于 action 匹配，形如 bd + 关键字
            else if (item.type = DataType.action) {
                ; 拿到 alias 例如为 bd 并去除 bd 开头的字符串
                realStr := SubStr(editValue, StrLen(item.alias) + 1)
                runUrl := unset
                if InStr(item.path, "{query}")
                    runUrl := strReplace(item.path, "{query}", realStr) 
                else
                    runUrl := item.path . realStr
                Run(runUrl)
            }
            ; 兜底 精确匹配 DATA_FILTER_REG
            else {
                openPathByType(item)
            }
            if IsSet(MY_GUI) {
                MY_GUI.Destroy()
                MY_GUI := unset
            }
        }

        onButtonClick(*) {
            ; 如果 listbox 有焦点
            if (listBox.Focused) {
              onListBoxDoubleClick(listBox)
            } else {
                ; 如果焦点在 编辑框 且按下回车则会触发弹窗提示；否则表示焦点在 edit，如果列表有匹配项 则获取编辑框文本内容
                Trim(myEdit.Value) == '' ? MsgBox('输入内容不能为空') : onListBoxDoubleClick(listBox)
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
    ; 总的匹配度
    degree := 0
    loop regExMatchInfo.Count {
        ; A_Index 第一次循环体执行时, 它为 1. 第二次, 它的值为 2; 依次类推
        item := SUPPORT_LEN - regExMatchInfo.Pos[A_Index]
        if (item < 0)
            break
        degree += (2 ** item)
    }
    return degree
}

; 用到了 item.type、item.path 和 item.title
openPathByType(item) {
    if (item.type = DataType.web || item.type = DataType.dl)
        jumpURL(item.path)
    else if (item.type = DataType.inner) { ; 精确处理：内部               
        openInnerCommand(item.title, True)
    } else if (item.type = DataType.ext) ; 精确处理：外部
        Run('jiejian' . (A_PtrSize == 4 ? '32' : '64') . '.exe /script ' . item.path)
    else if (item.type = DataType.app && item.title == '微信') { ; 对微信特殊处理：自动登录微信
        try {
            Run(item.path,,, &pid)
            WinWaitActive("ahk_pid " . pid)
            ; 手动等待 1.1 秒，否则可能会跳到扫码页
            Sleep(1100)
            Send("{Space}")
        } catch
            MsgBox("找不到目标应用")
    } else {
        ; 启动逻辑为每次都新建应用，而非打开已有应用 ActivateOrRun('', item.path)
        Run(item.path)
    }
}

class MyAction {
    __new(title, type, isMatch?, appendTitle?, run?) {
        ; 显示标题
        this.title := title
        ; 类型 edit or list
        this.type := type
        ; 过滤条件 是否符合匹配
        if IsSet(isMatch)
            this.isMatch := isMatch

        ; 拼接到 title 后面，意为进一步的描述
        if IsSet(appendTitle)
            this.appendTitle := appendTitle

        ; 执行动作 匹配后选定的行为
        if IsSet(run)
            this.run := run
    }
}

; 是否是文件夹，如果当前是文件则提取
isDir(path) {
    if (path == '*' || path == '/')
        return False

    isMatch := unset
    if DirExist(path) {
        isMatch := true
    } else if FileExist(path) {
        ; 抽出文件夹
        if RegExMatch(path, '.*[\\/]', &regExMatchInfo)
            isMatch := DirExist(regExMatchInfo.0)
        else
            isMatch := false
    } else {
        isMatch := false
    }
    return isMatch
}

appendWebsiteName(path) {
    ; 对网址进行细化处理
    ; 从 dava.csv 中抽取符合条件的 b 列 (http 网址)，若满足则赋值 d 列
    match := ''
    for (it in DATA_LIST) {
        if (it.type == DataType.web) {
            ; 完全匹配
            if (path == it.path) {
                match := '-' . it.title
                break
            } else {
                ; 可以匹配 www.doubao.com doubao.com https://www.doubao.com http://www.doubao.com https://www.doubao.com/ http://www.doubao.com/a/b.html 但不能匹配 abc.doubao.com https://edf.doubao.com http://ghi.doubao.com
                ; 提取关键部位
                ; 去掉 www
                newUri := unset
                if 1 == InStr(it.path, 'http://www.') || 1 == InStr(it.path, 'https://www.') || 1 == InStr(it.path, 'www.') {
                    uri := SubStr(it.path, InStr(it.path, 'www.') + StrLen('www.'))
                    newUri := 'i)^(?:https?://)?(?:www\.)?' . StrReplace(uri, '.', "\.") . '(?:/.*)?$'
                }
                ; 去掉 ://
                else {
                    if InStr(it.path, '://') {
                        uri := SubStr(it.path, InStr(it.path, '://') + StrLen('://'))
                    } else {
                        uri := it.path
                    }
                    ; 如果是顶级域名（简单认为分段数为 2）则加上 www
                    is_top_level_domain := (2 == StrSplit(uri, '.').Length)
                    newUri := 'i)^(?:https?://)?' . (is_top_level_domain ? '(?:www\.)?' : '') . StrReplace(uri, '.', "\.") . '(?:/.*)?$'
                } 
                if (path ~= newUri) {
                    match := '-' . it.title
                    break
                }
            }
        }
    }
    return match
}

appendFileType(path) {
    ; 取出文件后缀名，若有的话
    if RegExMatch(path, '\.([^.]*$)', &matchInfo) {
        extension := matchInfo.1
        switch extension, false {
            case '3gp', 'avi', 'flv', 'mkv', 'mov', 'mp4', 'wmv': return "视频"
            case '7z', 'bz2', 'gz', 'gz2', 'rar', 'tar', 'zip': return "压缩文件"
            case 'aac', 'flac', 'mp3', 'ogg', 'png', 'wav', 'wma': return "音频"
            case 'apk': return "安卓安装包"
            case 'bat', 'cmd': return " Windows 批处理文件"
            case 'bmp', 'gif', 'ico', 'jpeg', 'jpg', 'tiff', 'png', 'webp': return "图片文件"
            case 'css': return " CSS 样式表"
            case 'csv': return "逗号分隔值文件(二维表格)"
            case 'cer', 'crt': return "安全证书文件"
            case 'doc': return " Word 文档（旧版）"
            case 'docx': return " Word 文档"
            case 'dps': return " WPS 演示文件"
            case 'dwg': return " AutoCAD 绘图文件"
            case 'epub': return "开放式电子书"
            case 'et': return " WPS 表格文件"
            case 'exe', 'msi': return "可执行文件"
            case 'htm', 'html': return "网页文件"
            case 'ipa': return " iOS 应用安装包"
            case 'iso': return "光盘映像文件"
            case 'lnk': return "快捷方式"
            case 'log': return "日志文件"
            case 'json': return " JSON 数据文件"
            case 'md', 'markdown': return " markdown 文档"
            case 'mobi': return " Kindle 电子书格式"
            case 'js': return " JavaScript 脚本"
            case 'odf': return "电子表格"
            case 'odg': return " OpenDocument 绘图"
            case 'odp': return " OpenDocument 演示文稿"
            case 'ods': return " OpenDocument 表格"
            case 'odt': return " OpenDocument 文本"
            case 'ofd': return "国产 OFD 文档"
            case 'pdf': return " PDF 文档"
            case 'php': return " PHP 脚本文件"
            case 'ppt': return " PowerPoint 演示文稿（旧版）"
            case 'pptx': return " PowerPoint 演示文稿"
            case 'psd': return " Microsoft Visio 文件"
            case 'ps1': return " PowerShell 脚本文件"
            case 'py': return " Python 脚本文件"
            case 'rtf': return " RTF 文档"
            case 'svg': return "可缩放矢量图形文件"
            case 'torrent': return "种子文件"
            case 'txt': return "纯文本"
            case 'url' : return "网络书签"
            case 'vsd': return " Adobe Photoshop 文件"
            case 'wps': return " WPS 文档"
            case 'xls': return " Excel 表格（旧版）"
            case 'xlsx': return " Excel 表格"
            case 'xml': return " xml 文件"
            default: return "文件"
        }
    }
    return "文件"
}

openDir(path) {
    if DirExist(path) {
        Run(path)
    } else {
        RegExMatch(path, '.*[\\/]', &regExMatchInfo)
        Run(regExMatchInfo.0)
    }
}

; 是否是网站
isLegitimateWebsite(url) {
    return url ~= IS_HTTP_Reg
}

isFileOrDirExists(path) {
    ; con 文件或目录 为何存在，我用不到
    return path !== '*' && path !== '/' && 'con' != SubStr(path, 1, 3) && FileExist(path)
}

delFileOrDir(path) {
    DirExist(path) ? DirDelete(path) : FileDelete(path)
}

openInTerminal(path) {
    ; 在终端中打开所在文件夹
    if DirExist(path) {
        ; 盘符根目录需要以 \ 结尾才生效
        endChar := SubStr(path, StrLen(path))
        addSomething := (endChar = '\' || endChar = '/') ? "" : "\"
        Run(A_ComSpec, path . addSomething)
    } else {
        RegExMatch(path, '.*[\\/]', &regExMatchInfo)
        Run(A_ComSpec, regExMatchInfo.0)
    }
}

openInNewTerminal(path) {
    ; 在终端中打开所在文件夹
    if DirExist(path) {
        ; 盘符根目录需要以 \ 结尾才生效
        endChar := SubStr(path, StrLen(path))
        addSomething := (endChar = '\' || endChar = '/') ? "" : "\"
        Run(MY_NEW_TERMINAL . ' -d' . path . addSomething)
    } else {
        RegExMatch(path, '.*[\\/]', &regExMatchInfo)
        Run(MY_NEW_TERMINAL . ' -d' . regExMatchInfo.0)
    }
}

; openInPwsh(path) {
;     if DirExist(path) {
;         ; 盘符根目录需要以 \ 结尾才生效，所以都统一加上
;         endChar := SubStr(path, StrLen(path))
;         addSomething := (endChar = '\' || endChar = '/') ? "" : "\"
;         Run(MY_PWSH, path . addSomething)
;     } else {
;         RegExMatch(path, '.*[\\/]', &regExMatchInfo)
;         Run(MY_PWSH, regExMatchInfo.0)
;     }
; }

openInBash(path) {
    ; 在 bash 中打开所在文件夹
    if DirExist(path) {
        ; 盘符根目录需要以 \ 结尾才生效，所以都统一加上
        endChar := SubStr(path, StrLen(path))
        addSomething := (endChar = '\' || endChar = '/') ? "" : "\"
        Run(MY_BASH, path . addSomething)
    } else {
        RegExMatch(path, '.*[\\/]', &regExMatchInfo)
        Run(MY_BASH, regExMatchInfo.0)
    }
}

openInVSCode(path) {
    Run(MY_VSCode . ' ' . path)
}

openInIDEA(path) {
    Run(MY_IDEA . ' ' . path)
}

; 包含了所有我预设的内部命令
openInnerCommand(title, isConfirm := False) {
    switch title {
        case '重启': 
            if (isConfirm) {
                if MsgBox("立即" . title . "?", APP_NAME, "OKCancel") = "OK"
                    SystemReboot()
            } else {
                SystemReboot()
            }
        case '关机': 
            if (isConfirm) {
                if MsgBox("立即" . title . "?", APP_NAME, "OKCancel") = "OK"
                    SystemShutdown()
            } else {
                SystemShutdown()
            }
        case '锁屏': SystemLockScreen()
        case '睡眠': SystemSleep()
        case '激活屏幕保护程序': SendMessage(0x0112, 0xF140, 0,, "Program Manager") ; 0x0112 为 WM_SYSCOMMAND, 而 0xF140 为 SC_SCREENSAVE.
        case '清空回收站': FileRecycleEmpty()
        case '息屏': SystemSleepScreen()
        case '注销': SystemLogoff()
        ; 媒体类
        case '静音': Send '{Volume_Mute}'
        case '上一曲': Send '{Media_Prev}'
        case '下一曲': Send '{Media_Next}'
        case '暂停': Send '{Media_Play_Pause}'
        ; shell
        case '终端': Run(A_ComSpec) ; 在用户根目录打开文件夹
        case '网络连接': Run "shell:ConnectionsFolder" ; 第二种方式 ncpa.cpl
        case '收藏夹': Run "shell:Favorites"
        case '字体': Run "shell:Fonts"
        case '打印机': Run "shell:PrintersFolder"
        case '我的文档': Run "shell:Personal"
        case '回收站': Run "shell:RecycleBinFolder"
        case '我的桌面': Run "shell:desktop"
        case '我的下载': Run "shell:downloads"
        case '我的图片': Run "shell:My Pictures"
        case '我的视频': Run "shell:My Video"
        case '我的音乐': Run "shell:My Music"
        case '环境变量': Run "rundll32 sysdm.cpl,EditEnvironmentVariables"
        case '关闭程序': smartCloseWindow
        default: MsgBox('非系统内置命令！', APP_NAME)
    }
}

getIPAddresses() {
    addresses := SysGetIPAddresses()
    msg := "IP 地址:`n"
    for address in addresses
        msg .= address . "`n"
    MsgBox(msg, APP_NAME)
}
