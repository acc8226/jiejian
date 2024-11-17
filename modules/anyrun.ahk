#Include "Sort.ahk"

; 正则匹配最大支持长度默认为 32 位
GLOBAL SUPPORT_LEN := 32
GLOBAL DATA_FILTER_REG := 'i)^(?:' . DataType.app . '|' . DataType.file . '|' . DataType.web . '|' . DataType.inner . '|' . DataType.ext . '|' . DataType.dl . ')$'
; 端口判断过于简单 但是基本够用了
GLOBAL IS_HTTP_Reg := 'i)^(?:https?://)?' ; 协议
                    ; local 或 IP 或 英文网址
                    . '(?:localhost'
                        . '|(?:\d{1,2}|1\d{2}|2[0-4]\d|25[0-5])\.(?:\d{1,2}|1\d{2}|2[0-4]\d|25[0-5])\.(?:\d{1,2}|1\d{2}|2[0-4]\d|25[0-5])\.(?:\d{1,2}|1\d{2}|2[0-4]\d|25[0-5])' 
                        . '|(?!(?:\d+\.)+\d+)(?:[\w-一-龥]+\.)+[\w-一-龥]+' ; 华为.网址
                        ; 警惕 中文.com 的网络诈骗：有些诈骗者可能会利用账户变更的名义来诱骗用户泄露个人信息。如果收到任何要求你提供账户信息的邮件或消息，务必通过官方客服渠道进行核实
                        ; .com 是全球最广泛认可和使用的顶级域名，而 .网址是中国的国家级域名，但是在国内还是 .网址 比较正规，因为要有备案
                    . ')'
                    . '(:(?!0)(?![7-9]\d{4})\d{1,5})?' ; 端口
                    . '(?:/[\w-./?%&=#一-龻]*)?\s*$' ; 路径（可以包含中文）
GLOBAL MY_GUI
GLOBAL MY_GUI_TITLE := '快捷启动'

GLOBAL MyActionArray := [
    MyAction('打开网址', 'list', isLegitimateWebsite, AppendWebsiteName, jumpURL), ; 是否提前些比较好，不用了，兜底挺好
    MyAction('生成二维码(磁力链)', 'list', isMagnetUrl,, CreateQRcode),
    MyAction('生成二维码(网址)', 'list', isLegitimateWebsite,, CreateQRcode),
    ; 打开（文件，可能是 mp3 或者 mp4 或者 mov）
    MyAction('打开', 'list', path => isFileOrDirExists(path) && NOT DirExist(path), AppendFileType, path => Run(path)) ,
    MyAction('前往文件夹', 'list', isDir,, OpenDir),
    MyAction('查看属性', 'list', isFileOrDirExists,, path => Run('properties "' . path . '"')),
    MyAction('打印文件', 'list', path => path ~= 'i).+\.(?:bmp|docx?|gif|jpe?g|ofd|pdf|png|pptx?|xlsx?)$' && isFileOrDirExists(path) && NOT DirExist(path),, path => Run('print "' . path . '"')),
    MyAction('删除文件', 'list', isFileOrDirExists,, DelFileOrDir),
]

if IsSet(MY_BASH)
    MyActionArray.Push(MyAction('在 Bash 中打开所在位置', 'list', isFileOrDirExists,, OpenInBash))
if IsSet(MY_NEW_TERMINAL)
    MyActionArray.Push(MyAction('在新终端中打开', 'list', isFileOrDirExists,, OpenInNewTerminal))
else
    MyActionArray.Push(MyAction('在终端中打开', 'list', isFileOrDirExists,, OpenInTerminal))
if IsSet(MY_VSCode)
    MyActionArray.Push(MyAction('在 VSCode 中打开', 'list', isCodeFileOrDir,, path => Run(MY_VSCode . ' ' . path)))
if IsSet(MY_IDEA)
    MyActionArray.Push(MyAction('在 IDEA 中打开', 'list', isCodeFileOrDir,, path => Run(MY_IDEA . ' ' . path)))

; 彩蛋 本机 IP
MyActionArray.Push(MyAction('myip', 'edit',,, GetIPAddresses))

; 设置监听
#HotIf WinActive(MY_GUI_TITLE . " ahk_class i)^AutoHotkeyGUI$")
~Down::{
    ; 当前焦点在 edit 上 且如果 listbox 有东西 则 焦点移动到 listbox
    if MY_GUI.FocusedCtrl.type = 'Edit' && StrLen(MY_GUI['listbox1'].Text) > 0
        ControlFocus 'listbox1'
}
~UP::{
    ; 如果焦点在 listbox 首项 再向上则焦点移动到 edit
    if MY_GUI.FocusedCtrl.type = 'ListBox' && MY_GUI['listbox1'].value == 1
        ControlFocus 'Edit1'
}
#HotIf

Anyrun() {
    ; reload 过程中 MY_GUI_TITLE 会未定义
    if NOT IsSet(MY_GUI_TITLE)
        return
    ; 检查窗口是否已经存在，如果窗口已经存在，如果窗口不存在，则创建新窗口
    if (WinExist(MY_GUI_TITLE)) {
        WinClose ; 使用由上一句 WinExist 找到的窗口
    } else {
        ; S: 字体尺寸(单位为磅)
        ; AlwaysOnTop 使窗口保持在所有其他窗口的顶部
        ; Owner 可以让当前窗口从属于另一个窗口。从属的窗口默认不显示在任务栏, 并且它总是显示在其父窗口的上面. 当其父窗口销毁时它也被自动销毁
        ; -Caption 移除背景透明的窗口的边框和标题栏
        ; -Resize 禁止用户重新调整窗口的大小
        GLOBAL MY_GUI := Gui('AlwaysOnTop Owner -Caption -Resize', MY_GUI_TITLE)
        ; 横向和纵向边框收窄
        MY_GUI.MarginY := MY_GUI.MarginX := 2.8   
        fontSize := 's21'
        MY_GUI.SetFont(fontSize, 'Consolas') ; 设置兜底字体(21 磅) Consolas
        MY_GUI.SetFont(fontSize, 'Microsoft YaHei') ; 设置优先字体(21 磅) 微软雅黑
        guiWidth := 432
        myEdit := MY_GUI.AddEdit(Format("w{1}", guiWidth))
        ; R7：做到贴边 默认只显示 7 行
        ; Hidden：让控件初始为隐藏状态
        listBox := MY_GUI.AddListBox(Format("R7 w{1} XM+0 Y+0 BackgroundF0F0F0 Hidden", guiWidth))
        fontSize := 's18'
        listBox.SetFont(fontSize, 'Consolas') ; 设置兜底字体(21 磅) Consolas
        listBox.SetFont(fontSize, 'Microsoft YaHei') ; 设置优先字体(21 磅) 微软雅黑
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
                Send '^v'
        }

        onEscape(*) {
            if (IsSet(MY_GUI)) {
                MY_GUI.Destroy
                MY_GUI := unset
            }
        }

        onEditChange(thisGui, *) {
            ; 一旦文本框有变化立即清空
            listBox.Delete
            ; 获取文本框输入内容
            editValue := thisGui.Value
            if (editValue == '') {
                listBox.Visible := false
                MY_GUI.Show 'AutoSize'
                return
            }
            dataArray := unset
            ; 精确匹配失败 将 转到模糊匹配
            ; 若为空则清空列表 或 大于设定长度 或 满足正则
            if (StrLen(editValue) <= SUPPORT_LEN && editValue ~= '^[\s\d\.a-zA-Z一-龥]+$') {
                needleRegEx := 'i)'
                Loop Parse, editValue {
                    if A_LoopField == ' '
                        needleRegEx .= '( )'
                    else
                        needleRegEx .= '(' . A_LoopField . ').*'
                }
                dataArray := Array()
                for it in DATA_LIST {
                    if (it.type ~= DATA_FILTER_REG) {
                        if ('Array' == Type(it.alias)) {
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
                                    if NOT IsSet(maxData)
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
            if (NOT IsSet(dataArray) || dataArray.Length == 0) {
                listBoxDataArray := []
            } else {
                dataArraySort(dataArray)
                listBoxDataArray := listBoxData(dataArray)
            }

            ; 搜索匹配
            ; 查询出所有搜索，如果前缀满足则添加到列表
            for it in DATA_LIST {
                if it.type == DataType.action and 1 == InStr(editValue, it.alias)
                    listBoxDataArray.push(it.title . '-' . it.type)
            }

            ; 模糊匹配 按顺序
            for action in MyActionArray {
                ; 如果是 list 类型 且 符合条件
                if (action.type = 'list' && action.isMatch.Call(editValue)) {
                    if action.HasOwnProp('appendTitle')
                        listBoxDataArray.push(action.title . action.appendTitle.Call(editValue)) ; 最终的标题
                    else
                        listBoxDataArray.push(action.title)
                }
            }
            if IsSet(MY_GUI) {
                ; 显示出来
                listBox.Visible := listBoxDataArray.Length > 0
                if (listBox.Visible) { 
                    listBox.Add listBoxDataArray
                    listBox.Choose 1
                }
                MY_GUI.Show "AutoSize"
            } else {
                MsgBox 'Anyrun 组件异常销毁', APP_NAME
            }
        }

        onEditLoseFocus(*) {
            if (IsSet(MY_GUI) && NOT listBox.Focused) {
                MY_GUI.Destroy
                MY_GUI := unset
            }
        }

        onListboxLoseFocus(*) {
            if (IsSet(MY_GUI) && NOT myEdit.Focused) {
                MY_GUI.Destroy
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
                if (split.Length == 2) {
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
                ; 拿到 alias 例如为 bd 则去除头部 bd
                realStr := SubStr(editValue, StrLen(item.alias) + 1)
                ; GitHub 加速服务 js 由 https://www.7ed.net/gitmirror/hub.html 提供
                if NOT(item.alias == 'pi' || item.alias == 'js') {
                    ; 特殊处理 ip
                    if (item.alias == 'ip') {
                        ; 去掉 http:// 和 https://
                        len := InStr(realStr, "://")
                        if len
                            realStr := SubStr(realStr, len + 3)
                    }
                    realStr := URIEncode(realStr)
                }
                runUrl := unset
                if InStr(item.path, "{query}")
                    runUrl := strReplace(item.path, "{query}", realStr)
                else
                    runUrl := item.path . realStr
                Run runUrl
            }
            ; 兜底 精确匹配 DATA_FILTER_REG
            else {
                openPathByType item
            }
            if (IsSet(MY_GUI)) {
                MY_GUI.Destroy
                MY_GUI := unset
            }
        }

        onButtonClick(*) {
            ; 如果 listbox 有焦点
            if listBox.Focused
                onListBoxDoubleClick listBox
            else if Trim(myEdit.Value) == '' ; 如果焦点在 编辑框 且按下回车则会触发弹窗提示
                MsgBox '输入内容不能为空'
            else ; 否则表示焦点在 edit，如果列表有匹配项 则获取编辑框文本内容
                onListBoxDoubleClick listBox
        }
    }
}

/**
 * 计算匹配度
 * 
 * @param regExMatchInfo
 * @returns {number} 
 */
ComputeDegree(regExMatchInfo) {
    ; 总的匹配度
    degree := 0
    loop regExMatchInfo.Count {
        ; A_Index 第一次循环体执行时, 它为 1. 第二次, 它的值为 2; 依次类推
        item := SUPPORT_LEN - regExMatchInfo.Pos[A_Index]
        if item < 0
            break
        degree += (2 ** item)
    }
    return degree
}

; 用到了 item.type、item.path 和 item.title
OpenPathByType(item) {
    if (item.type = DataType.web || item.type = DataType.dl) {
        jumpURL(item.path)
    } else if (item.type = DataType.inner) { ; 精确处理：内部
        OpenInnerCommand(item.title, True)
    } else if (item.type = DataType.ext) { ; 精确处理：外部
        Run('jiejian' . (A_PtrSize == 4 ? '32' : '64') . '.exe /script ' . item.path)
    } else if (item.type = DataType.app && item.title == '微信') { ; 对 微信 优化体验：自动登录微信
        try {
            Run(item.path,,, &pid)
            WinWaitActive("ahk_pid " . pid)
            ; 手动等待 1.1 秒，否则可能会跳到扫码页
            Sleep 1100
            Send "{Space}"
        } catch
            MsgBox "找不到目标应用"
    } else if (item.type = DataType.app && item.title = 'alist') { ; 对 alist 特殊处理：使用命令行打开并添加 server 参数
        SplitPath(item.path,, &dir)
        Run(A_ComSpec " /C " . item.path . " server", dir)
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

; --- appendTitle 开始 ---
AppendWebsiteName(path) {
    ; 对网址进行细化处理
    ; 从 dava.csv 中抽取符合条件的 b 列 (http 网址)，若满足则赋值 d 列
    appendName := ''
    for (it in DATA_LIST) {
        if (it.type == DataType.web) {
            ; 完全匹配
            if (path == it.path) {
                appendName := '-' . it.title
                break
            } else {
                ; 可以匹配 www.doubao.com doubao.com https://www.doubao.com http://www.doubao.com https://www.doubao.com/ http://www.doubao.com/a/b.html 但不能匹配 abc.doubao.com https://edf.doubao.com http://ghi.doubao.com
                ; 提取关键部位
                ; 去掉 www
                if (1 == InStr(it.path, 'http://www.') || 1 == InStr(it.path, 'https://www.') || 1 == InStr(it.path, 'www.')) {
                    uri := SubStr(it.path, InStr(it.path, 'www.') + StrLen('www.'))
                    newUriReg := 'i)^(?:https?://)?(?:www\.)?' . StrReplace(uri, '.', "\.") . '(?:/.*)?$'
                } else {
                    ; 去掉 ://
                    if InStr(it.path, '://')
                        uri := SubStr(it.path, InStr(it.path, '://') + StrLen('://'))
                    else
                        uri := it.path
                    ; 如果是顶级域名（简单认为分段数为 2）则加上 www
                    is_top_level_domain := (2 == StrSplit(uri, '.').Length)
                    newUriReg := 'i)^(?:https?://)?' . (is_top_level_domain ? '(?:www\.)?' : '') . StrReplace(uri, '.', "\.") . '(?:/.*)?$'
                } 
                if (path ~= newUriReg) {
                    appendName := '-' . it.title
                    break
                }
            }
        }
    }
    return appendName
}

AppendFileType(path) {
    ; 取出文件后缀名，若有的话
    if RegExMatch(path, '\.([^.]*$)', &matchInfo) {
        extension := matchInfo.1
        switch extension, false {
            case '3gp', 'avi', 'flv', 'mkv', 'mov', 'mp4', 'wmv': return "视频"
            case '7z', 'bz2', 'gz', 'gz2', 'rar', 'tar', 'zip': return "压缩包"
            case 'aac', 'flac', 'mp3', 'ogg', 'wav', 'wma': return "音频"
            case 'apk': return "安卓安装包"
            case 'bat', 'cmd': return " Windows 批处理文件"
            case 'bmp', 'gif', 'ico', 'jpeg', 'jpg', 'tiff', 'png', 'webp': return "图片"
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
            case 'vsd': return ' Adobe Photoshop 文件'
            case 'wps': return ' WPS 文档'
            case 'xls': return ' Excel 表格（旧版）'
            case 'xlsx': return ' Excel 表格'
            case 'xml': return ' xml 文件'
            default: return '文件'
        }
    }
    return "文件"
}

; --- isMatch 开始 ---

; 是否是合法网站
isLegitimateWebsite(url) {
    return url ~= IS_HTTP_Reg
}

; 是否是合法磁力链
isMagnetUrl(url) {        
    return RegExMatch(url, '^magnet:.+')
}

isFileOrDirExists(path) {
    ; con 文件或目录 为何存在，我用不到
    return path !== '*' && path !== '/' && 'con' != SubStr(path, 1, 3) && FileExist(path)
}

; 是否是文件夹，如果当前是文件则提取
isDir(path) {
    if path == '*' || path == '/'
        return false

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

isCodeFileOrDir(path) {
    ; con 文件或目录 为何存在，我用不到
    if path == '*' || path == '/' || 'con' = SubStr(path, 1, 3)
        return false
    if FileExist(path) {
        if DirExist(path)
            return true
        return path ~= 'i)\.(?:txt|html?|xml|xslt?|js|ts|css|php|asp|pl|py|java|c|cpp|cc|h|hpp|hh|cs|vb|sql|sh|ini|bat|cmd|aspx|ashx|asmx|ascx|cfg|conf|json|yaml|yml|rb|lua|swift|m|mm|r|pas|go|rs|dart|kt|scala|hs|erl|hrl|clj|groovy|fs|ps1|vhd|vhdl|verilog|markdown|md|ahk)'
    }
    return false
}

; --- run 开始 ---
CreateQRcode(path) {
    Run('https://api.cl2wm.cn/api/qrcode/code?text=' . URIEncode(path))
}

OpenDir(path) {
    if (DirExist(path)) {
        Run path
    } else {
        RegExMatch(path, '.*[\\/]', &regExMatchInfo)
        Run(regExMatchInfo.0)
    }
}

DelFileOrDir(path) {
    DirExist(path) ? DirDelete(path) : FileDelete(path)
}

OpenInBash(path) {
    ; 在 bash 中打开所在文件夹
    if (DirExist(path)) {
        ; 盘符根目录需要以 \ 结尾才生效，所以都统一加上
        endChar := SubStr(path, StrLen(path))
        addSomething := (endChar = '\' || endChar = '/') ? "" : "\"
        Run(MY_BASH, path . addSomething)
    } else {
        RegExMatch(path, '.*[\\/]', &regExMatchInfo)
        Run(MY_BASH, regExMatchInfo.0)
    }
}

OpenInTerminal(path) {
    ; 在终端中打开所在文件夹
    if (DirExist(path)) {
        ; 盘符根目录需要以 \ 结尾才生效
        endChar := SubStr(path, StrLen(path))
        addSomething := (endChar = '\' || endChar = '/') ? "" : "\"
        Run(A_ComSpec, path . addSomething)
    } else {
        RegExMatch(path, '.*[\\/]', &regExMatchInfo)
        Run(A_ComSpec, regExMatchInfo.0)
    }
}

OpenInNewTerminal(path) {
    ; 在终端中打开所在文件夹
    if (DirExist(path)) {
        ; 盘符根目录需要以 \ 结尾才生效，所以都统一加上
        endChar := SubStr(path, StrLen(path))
        addSomething := (endChar = '\' || endChar = '/') ? "" : "\"
        Run(MY_NEW_TERMINAL ' /d .', path . addSomething)
    } else {
        RegExMatch(path, '.*[\\/]', &regExMatchInfo)
        Run(MY_NEW_TERMINAL ' /d .', regExMatchInfo.0)
    }
}

; 包含了所有我预设的内部命令
OpenInnerCommand(title, isConfirm := false) {
    switch title {
        ; shell
        case '打印机': Run "shell:PrintersFolder"
        case '环境变量': Run "rundll32 sysdm.cpl,EditEnvironmentVariables"
        case '回收站': Run "shell:RecycleBinFolder"
        case '网络连接': Run "shell:ConnectionsFolder" ; 第二种方式为 ncpa.cpl
        case '我的视频': Run "shell:My Video"

        case '我的图片': Run "shell:My Pictures"
        case '我的下载': Run "shell:downloads"
        case '我的音乐': Run "shell:My Music"
        case '我的文档': Run "shell:Personal"
        case '我的桌面': Run "shell:desktop"

        case '收藏夹': Run "shell:Favorites"
        case '终端': Run A_ComSpec ; 在用户根目录打开文件夹
        case '字体': Run "shell:Fonts"
        ; 系统操作
        case '重启': 
            if (isConfirm) {
                if MsgBox("立即" . title . "?", APP_NAME, "OKCancel") = "OK"
                    SystemReboot
            } else {
                SystemReboot
            }
        case '关机': 
            if (isConfirm) {
                if MsgBox("立即" . title . "?", APP_NAME, "OKCancel") = "OK"
                    SystemShutdown
            } else {
                SystemShutdown
            }
        case '锁屏', '锁定', '锁屏/锁定' : SystemLockScreen
        case '睡眠': SystemSleep
        case '激活屏幕保护程序': SendMessage(0x0112, 0xF140, 0,, "Program Manager") ; 0x0112 为 WM_SYSCOMMAND, 而 0xF140 为 SC_SCREENSAVE

        case '清空回收站': FileRecycleEmpty()
        case '息屏': SystemSleepScreen
        case '注销': SystemLogoff
        ; 媒体类
        case '静音': Send '{Volume_Mute}'
        case '上一曲': Send '{Media_Prev}'
        case '下一曲': Send '{Media_Next}'
        case '暂停': Send '{Media_Play_Pause}'

        case '音量设为10': SoundSetVolume 10
        case '音量设为20': SoundSetVolume 20
        case '音量设为30': SoundSetVolume 30
        case '音量设为40': SoundSetVolume 40
        case '音量设为50': SoundSetVolume 50

        case '音量设为60': SoundSetVolume 60
        case '音量设为70': SoundSetVolume 70
        case '音量设为80': SoundSetVolume 80
        case '音量设为90': SoundSetVolume 90
        case '音量设为最大': SoundSetVolume 100

        case '取消关机任务': Run('shutdown /a',, 'Hide')
        ; 其他
        case '关闭程序': SmartCloseWindow
        default: 
            if FoundPos := InStr(title, "秒后关机") {
                second := SubStr(title, 1, FoundPos  - 1)
                Run('shutdown /a', , 'Hide')
                Run('shutdown /s /t ' . second,, 'Hide')
            } else if FoundPos := InStr(title, "分钟后关机") {
                min := SubStr(title, 1, FoundPos  - 1)
                Run('shutdown /a', , 'Hide')
                Run('shutdown /s /t ' . min * 60,, 'Hide')
            } else if FoundPos := InStr(title, "小时后关机") {
                hour := SubStr(title, 1, FoundPos  - 1)
                Run('shutdown /a', , 'Hide')
                Run('shutdown /s /t ' . hour * 60 * 60,, 'Hide')
            } else
                MsgBox '非系统内置命令！', APP_NAME
    }
}

GetIPAddresses() {
    addresses := SysGetIPAddresses()
    msg := "IP 地址:`n"
    for address in addresses
        msg .= (address . "`n")
    MsgBox msg, APP_NAME
}
