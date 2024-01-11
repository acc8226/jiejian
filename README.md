# 捷键 for win 使用说明

* 基于 autohotkey2 开发的按键映射 / 快捷键增强工具
* 为增强鼠标和键盘按键功能而生
* 不区分鼠标厂商，选择使用带侧边按键的鼠标，体验更完善。
* 支持自定义快捷键、快捷键改写、快捷键功能增强。提供快捷启动等功能。
* 建议搭配 WGestures（全局鼠标手势） + MyKeymap（完善的窗口操作 & 启动程序 & 召唤窗口）使用。

注意：说明书指向最新版软件，若功能有差异，请[下载并使用最新版](https://gitcode.com/acc8226/jiejian/releases)。

## 1. 热键 之 鼠标操作

1\. 当鼠标移动到屏幕左边缘或者上边缘以及停留在任务栏时，鼠标滑轮滚动可以调节音量。

2\. 鼠标按键用法

| 按键 | 正常用途 | 音乐类软件 | 视频类软件 | 焦点在任务栏 | 焦点在左或上边界
| ----  | ---- | ---- | ---- | ---- | ---- |
| 鼠标右键 | - | - | - | - | 播放/暂停 |
| 鼠标中键 | - | - | - | 静音 | 静音 |
| Xbutton2（鼠标侧边前进键） | 万能**后退**键：在多标签页则是切换到上个标签 | 上一曲 | 上一个视频 | 上一曲 | 上一曲 |
| Xbutton1（鼠标侧边后退键） | 万能**关闭**键：在多标签页则是关闭当前标签 | 关闭窗口 | 关闭窗口 | 下一曲 | 下一曲 |

![1](https://foruda.gitee.com/images/1689318820722473769/d4f9efe3_426858.gif)

3\. 按住 CapsLock 后可以用鼠标左键拖动窗口

## 2. 热键 之 重写快捷键

增强已有快捷键以及新增快捷键。支持众多常用软件，详细列表见附录。

| 按键 | 正常用途 | 音乐类软件 | 视频类软件 | 焦点在任务栏或左/上边界
| ----  | ---- | ---- | ---- | ---- |
| Ctrl + F3 | 用于**新建**标签/窗口 | - | - | - |
| Esc（逃逸键）| 可用于**关闭**特定窗口 | - | - | - |
| Ctrl + F4 | 用于**关闭**标签/窗口 | 同左 | 同左 | 同左 |
| Alt + → | 前进/快进 | 下一曲 | 快进 | 下一曲 |
| Ctrl + Tab | 切换下一个标签| 下一曲 | 下一个视频 | 下一曲 |
| Alt + ← | 后退/快退 | 上一曲 | 快退 | 上一曲 |
| Ctrl + Shift + Tab | 切换上一个标签 | 上一曲 | 上一个视频 | 上一曲 |

注：以下部分场景使用了鼠标手势 WGestures 替代了手动键入快捷键

操作资源管理器

![输入图片说明](https://foruda.gitee.com/images/1689318878983165049/4f89b32d_426858.gif "动画2-3.gif")

操作 360 极速浏览器

![输入图片说明](https://foruda.gitee.com/images/1689320148290015829/d0563e32_426858.gif "2.gif")

操作 idea

![输入图片说明](https://foruda.gitee.com/images/1689318910813101697/359f150e_426858.gif "动画2-4.gif")

操作 vscode

![输入图片说明](https://foruda.gitee.com/images/1689318894573526368/39027a0d_426858.gif "动画2-2.gif")

## 3. 热键 之 打开网址

* alt + 6 打开 B 站
* alt + 7 打开 IT 之家
* alt + 8 打开 西瓜视频

![打开网址](https://foruda.gitee.com/images/1689318923398248705/25b1c4c9_426858.gif "动画3.gif")

## 4. 热键 之 运行程序

* Alt + j 打开记事本

![打开记事本](https://foruda.gitee.com/images/1689318934831690368/2606bf7a_426858.gif "动画4.gif")

## 5. 热键 之 启动文件夹

* Alt + d 打开 D 盘

![打开D盘](https://foruda.gitee.com/images/1689318944226542670/0337e814_426858.gif "动画5.gif")

## 6. 热键 之 其他

* Ctrl + 数字 1-5 为光标所在行添加 markdown 格式标题（目前仅开放了 vscode 和 windows 记事本的使用权限）

![输入图片说明](https://foruda.gitee.com/images/1689318964909077353/0518d03d_426858.gif "动画6.gif")

* `ctrl + alt + v` 剪贴板的内容输入到当前活动应用程序中，防止了一些网站禁止在 HTML 密码框中进行粘贴操作
* `ctrl + alt + r` 重启脚本
* `ctrl + shift + "`  插入一对双引号

## 7. 应用启动器

一款简洁、精巧、高效并持续优化中的应用启动器。

启动器特点：

1. 无边框设计，去除最小化和关闭按钮，界面极简。
2. 使用普适易读的微软雅黑字体，字号设计合理，字体风格简洁大方。
3. 支持自定义多种关键词进行应用匹配，智能识别用户的启动意图。
4. 搜索栏设计简洁，支持模糊搜索，帮助快速定位应用。
5. 系统资源占用少，启动迅速，可靠性高，全天候支持用户的应用启动需求。
6. 支持自定义配置。

使用说明：

`Alt + 空格` 开启快捷启动器。若再次按下 / 鼠标在启动器外点击 / esc 键则关闭

只要输入对应启动程序/网址的全拼或首字母简拼这种模糊搜索，如果候选词有多个可以按下 tab 键切换到列表框中方向上下键选中后回车或鼠标双击。

### bd 百度搜索

在框中输入 bd[空格?]{关键字} 进行百度搜索

![输入图片说明](https://foruda.gitee.com/images/1689321508560702893/2457a573_426858.gif "2.gif")

### bing 必应搜索

在框中输入 bing[空格?]{关键字} 进行必应搜索

### ip 归属地查询

在框中输入 ip[空格?]{关键字} 进行 ip 归属地查询

### 快速跳转到网络书签 和 打开软件

支持模糊拼写和全拼

bd 打开百度

![](https://gitee.com/acc8226/shortcut-key/raw/main/imgs/7%20%E6%89%93%E5%BC%80%E7%99%BE%E5%BA%A6.apng)

kz 打开了控制面板

![](https://gitee.com/acc8226/shortcut-key/raw/main/imgs/7%20%E6%89%93%E5%BC%80%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%9D%BF.apng)

## 8. 热串 之 直达网址（Z 直达模式）

* zbd 打开 百度
* zbi 打开 哔哩哔哩
* zdy 打开 电影天堂
* zit 打开 IT 之家
* zma 打开 QQ 邮箱
* zxg 打开 西瓜视频

![图片说明](https://foruda.gitee.com/images/1689318989538537685/7b71d232_426858.gif)

![图片说明](https://foruda.gitee.com/images/1689319007424875617/4934e693_426858.gif)

## 9. 热串之 扩展片段：将字符串替换为自定义话术（X 拓展模式）【可配置】

* xnb 很牛呀
* xnm 你妹的
* xnow 插入当前日期时间，举例 `2023-08-27 09:10:41`
* xdate 插入特定格式的当前日期时间，举例 `Date: 2023-12-22 21:23:30`
  
![](https://foruda.gitee.com/images/1689259764657007580/13e4cb48_426858.gif "8.gif")

* xwx 😄 微笑
* xlh 😊 脸红
* xok 👌 OK
* xax ❤️ 爱心
* xbz 📰 报纸
* xbq 🏷️ 标签
* xsq 🔖 书签
* xsh 💩 大便
* xgh 👻 鬼魂

![](https://foruda.gitee.com/images/1689259802922906219/d546cc12_426858.gif "10.gif")

## 10. 自定义配置说明

配置文件 **app.csv**（用于配置软件的快捷键）、**data.csv**（用于配置启动器候选项以及热键、热串） 必须和 ahk 脚本文件在同一级目录，且文本编码必须为 utf-8。

推荐使用 [LiberOffice](https://www.libreoffice.org/download/download-libreoffice/) 或者微软 Office utf8 模式打开。

强烈不建议使用 WPS 进行打开，因为 WPS 默认使用 gbk 编码。

### app.csv - 自定义快捷键

B列（标识符）为必须项。其余皆为可选项。只需填写需要变更的快捷键即可，否则可留空。

若该行全部留空则表示 ctrl + f4 和 鼠标侧边后退键用于关闭窗口。

### data.csv - 自定义快捷启动项

* A列 类型：app / web
* B列 启动路径：实际运行的网址或程序路径
* C列 运行名称：用于展示
* D列 运行关键字：匹配关键字，若有多个通过 | 进行分割。

### data.csv - 自定义热键

* A列 类型：app / web / file / text
* B列 启动路径：实际运行的网址或程序路径
* E列 热键关键字：例如 !6 表示 ctrl + 数字 6

### data.csv - 自定义热串

* A列 类型：app / web / file / text
* B列 启动路径：实际运行的网址或程序路径
* F列 热串关键字：例如 zbd 表示打开百度网

## 已知 bug

目前适配不太好的软件：搜狗浏览器。

目前测试关闭窗口不奏效的软件：搜狗浏览器、windows 任务管理器（似乎屏蔽了 ctrl 键）、windows 任务管理器。

## 版本发布

### 未来计划

* 考虑是否提供软件检测升级功能

### 捷键 2023 年度纪念版

这是 23 年最后的一个版本。提前祝大家 2024 年元旦快乐。

* 支持青鸟浏览器、小白浏览器、阿里云客户端、Spotify、CudaText、PotPlayer、Devecostudio 64位。
* 提供了 WGestures2 预设手势方案
* bug 修复

### 捷键 2023.10

2023 年 10 月 30 晚 于北京

新增：

* 当鼠标在任务栏上定义左滑为上一首，右滑为下一首
* 支持 稻壳阅读器、汽水音乐、navicat
* 快速启动 新增 bing 搜索

优化：

* 当程序启动失败，添加了友好提示

### 捷键 2023.09

2023 年 9 月 29 晚 于北京

新增

* 支持 netbean、editplus、JB fleet、eclipse、myeclipse、Notepad--、Notepad++、SpringToolSuite4、sublime、ultraedit 64 位、HBuilderX

优化

* 导入 csv 的 path 支持首尾都包含双引号
* 调整 x 模式的激活条件使更合理

### 捷键 v1.0.3 2023-8-27

新增：

* 热串 xnow 用于输出当前日期时间时间
* 热串 xdate 用于 markdown 版输出当前日期时间时间

优化：

* 热串 x 模式主要用于拓展文本，限定范围为只在文本编辑框可编辑
* 热串 z 模式主要用于打开网页，限定范围为排除在 vscode 和 浏览器中鼠标处于非光标形状下使用
* 启用自定义系统栏图标，更有辨识度
* 优化找不到目标应用的错误提示
* 新增和关闭标签 适配 win11 新版 记事本
* 新建标签/窗口 改为使用 ctrl + f3
* 删除用的不多的禁用脚本快捷键 ctrl + alt + s

### 捷键 v1.0.2 2023-08-17

优化：

* 优先使用 WinClose "A" 去关闭窗口
* anyrun 组件优先使用微软雅黑字体，匹配按照优先级排序：匹配位置 + 字符串长度
* 关闭标签从 ctrl + w 改为了 ctrl + f4

### 捷键 v1.0.1 2023-08-07

新增：

* 添加 ip 查询

优化：

* 捷键输入框不再区分大小写，具体规则是搜索按照匹配位置进行排序，首字母越先匹配到的越靠前

### 捷键 v1.0.0 for windows 2023-07-22

第一个正式版本

* 代码注释调整 和 丰富数据源
* 修复 bug
* anyrun 组件完善当鼠标在窗口外点击后关闭窗口

### 捷键 v0.0.2 for windows 2023-07-20

* 运行框支持英文大小写混写
* 创建 anyrun 组件以及其他优化

### 捷键 v0.0.1 for windows 2023-07-13

一个伟大的里程碑

## 常见问题

### 如何将捷键设置为开机自启

在运行窗口中运行 shell:startup，按住 alt 键将 shortcut64.exe 拖入 Startup 文件夹内即可。

## 附录

### 软件搭配玩法

#### 搭配 WGestures

[【免费】【win】WGestures 1 鼠标手势](https://www.yingdev.com/projects/wgestures) / [【付费】【win mac】WGestures 2 鼠标手势](https://www.yingdev.com/projects/wgestures2)

| 方向 | 名称 | 按键/功能 |
| ----  | ---- | ---- |
| ↗︎ | 最小化 | 最小化 |
| ↙︎ | 最大化 | 最大化/还原 |
| ↘︎ | 复制/copy | ctrl + c |
| ↖︎ | 粘贴/paste | ctrl + v |
| ↑ | 新建/new | ctrl + f3 |
| ↓ | 关闭/close | ctrl + f4 |
| ← | 后退/prev | alt ← |
| → | 前进/next | alt → |
| ↩ | 重新打开/reopen | ctrl + shift + t |
| ↪ | 关闭/close | alt + f4 |
| 上左 | 上一个/prev | ctrl + shift + tab |
| 上右 | 下一个/next | ctrl + tab |

#### 搭配 [MyKeymap](https://xianyukang.com/MyKeymap.html)

CapsLock 模式

| 按键 | 用途 |
| ----  | ---- |
| W | 切换到上一个窗口 |
| E | 窗口管理 EDSF 切换 X关闭、空格选择 |
| G | 置顶/取消置顶 窗口 |
| Q | 窗口最大化或还原 |
| R | 在当前程序的窗口间轮换 |
| Z | 复制文件路径或纯文本 |
| B | 窗口最小化 |
| | |
| a | 360 chrome |
| s | 资源管理器 |
| d | 微信 |
| x | WindowsTerminal |
| c | Code |
| v | idea64 |
| t | Termius |

CapsLock F 模式

| 按键 | 窗口标识符 | 当窗口不在时启动 | 备注 和 短语 和 key |
| ----  | ---- | ---- | ---- |
| Q | ahk_exe SumatraPDF.exe | D:\alee\exec\daily\0.日常\2.办公类\SumatraPDF\SumatraPDF.exe | SumatraPDF【pd】 |
| W | ahk_exe PotPlayerMini64.exe | D:\alee\exec\daily\0.日常\4.视频类\Pot_Player64\PotPlayerMini64.exe | PotPlayer【vi】 |
| T | ahk_class Chrome_WidgetWin_1 ahk_exe Termius.exe | C:\Users\ferder\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Termius.lnk | Termius【tm】【t】 |
| E | ahk_exe MusicPlayer2.exe | D:\alee\exec\daily\0.日常\3.音频类\MusicPlayer2_x64\MusicPlayer2.exe | MusicPlayer2【mu】 |
| A | ahk_exe 360ChromeX.exe | shortcuts\360 极速浏览器X.lnk | 360极速浏览器【ch】【a】|
| S | ahk_class CabinetWClass ahk_exe Explorer.EXE | D:\ | 资源管理器【ex】【s】|
| D | ahk_exe WeChat.exe | shortcuts\微信.lnk | 微信【we】【d】|
| Z | ahk_exe WindowsTerminal.exe | wt.exe | WindowsTerminal【te】【g】 |
| X | ahk_exe Code.exe | shortcuts\Visual Studio Code.lnk | vscode【co】【c】|
| C | ahk_exe idea64.exe | D:\alee\exec\dev\IDE\ideaIC-2022.3.3.win\bin\idea64.exe | IntelliJ IDEA【id】【v】|
| M | 一些内置函数 | ProcessExistSendKeyOrRun("TIM.exe", "^!z", "shortcuts\TIM.lnk") | 如果 TIM.exe 进程存在则输入 Ctrl+Alt+Z 热键激活 TIM，否则启动 TIM |

CapsLock 命令

| 按键 | 参数1 | 参数2 | 参数3 |
| ----  | ---- | ---- | ---- |
| cc | shortcuts\Visual Studio Code.lnk | -n "{selected}" | 用 VS Code 打开选中的文件，在新窗口中打开 |
| wt | wt.exe | -d "{selected}" | 用 Windows Terminal 打开选中的文件夹 |

### 支持软件

支持但不限于以下百余款软件，且持续更新中...

* 360 压缩
* BvSsh
* ahk 应用程序
* Visual Studio
* skylark
* 360 极速浏览器
* 360 极速浏览器-下载管理窗口
* Win11 21h1 桌面
* Win11 22h2 桌面
* Win11 资源管理器
* Win11 旧版 记事本
* Win11 新版 记事本
* 新版 win 11 设置
* 123 浏览器
* 115 浏览器
* 2345 浏览器
* 360 安全浏览器
* Avast 浏览器
* Brave 浏览器
* Chrome 谷歌 & 百分 & 小马浏览器
* Duck 浏览器
* Duoyu 多御浏览器
* Edge 浏览器
* Firefox 火狐 & Tor 洋葱浏览器
* Opera 浏览器
* QQ 浏览器
* UC 浏览器
* UU 浏览器
* Vivaldi 浏览器
* Waterfox 浏览器
* Yandex 浏览器
* 傲游浏览器
* 斑斓石浏览器
* 华为浏览器
* 红芯浏览器
* 极速浏览器
* 猫眼浏览器
* 蚂蚁浏览器
* 猎豹浏览器
* 青鸟浏览器
* 联想浏览器
* 搜狗浏览器
* 双核浏览器
* 星愿浏览器
* 想天浏览器
* 小K 浏览器
* 小白浏览器
* 小智双核浏览器
* 一点浏览器
* foobar2000
* MusicPlayer2
* QQ 音乐
* Spotify
* 方格音乐
* 酷我音乐
* 汽水音乐
* 网易云音乐
* LibreOffice 窗口
* LibreOffice 主体
* Motrix
* Sumatra PDF
* PotPlayer 64位
* QQ
* Snipaste
* Thunderbird
* WPS
* WPS 图片查看器
* 哔哩哔哩
* 稻壳阅读器
* 微信
* 阿里云客户端
* 炉石传说
* Beekeeper Studio
* heidisql
* Navicat
* SQLyog
* MarkdownPad2
* MarkText
* Typora
* Atom
* Bracket
* Fleet
* CudaText
* Editplus
* Everedit
* Geany
* Kate
* Notepad++
* Notepad--
* Notepad2
* Notepad3
* Sublime
* Ultraedit
* Bcompare
* Winmerge
* HbuilderX
* Dev C++
* Eclipse
* MyEclipse
* Rstudio
* SpringToolSuite4
* VS Code
* Aqua
* Clion
* Datagrip
* Dataspell
* Goland
* Idea
* Phpstorm
* Pycharm
* Rider
* Rubymine
* RustRover
* Webstorm
* Writerside
* Android Studio
* 华为 DevEco Studio
* Netbean 32 位 & Jmeter
* Netbean 64 位
* Apifox
* ApiPost
* HTTPie
* Postman
* Zeal
* GitHub 桌面版
* GitKraken
* SourceTree
* 小乌龟 Git 的 merge 窗口
* Xshell
* Finalshell
* MobaXterm
* SecureCRT
* Tabby
* Termius
* zoc
* FlashFXP
* Xftp
* WindowsTerminal
* WindTerm

### 打包发版目录结构

1. extra/ 【增强体验】MyKeymap2.0 预设配置。WGestures 为 可导入的预设手势模版。WindowSpyU64.exe 用于查看窗口信息。
2. app.csv 配置文件
3. data.csv 配置文件
4. help.url 在线帮助文档
5. **jiejian32.exe** 分别为 32/64 位主程序 免安装，双击即用
6. **jiejian64.exe**

### 软件设计思路

* 严格按照 ahk 中的 hotIf 的优先匹配原则。一般 esc 会在前。由于考虑到 Esc 逃逸键 用于关闭窗口，目前支持记事本中使用。
* Ctrl + F3 为新建标签/窗口 避免和已有 Ctrl + t 冲突
* Ctrl + Shift + Tab / Ctrl + Tab 切换到上/下个标签 默认不需要重写
* Ctrl + F4 为关闭标签/窗口，避免和常见的 Ctrl + w 冲突
* Ctrl + Shift + t 撤销关闭标签 默认不需要重写
* Alt + 左方向键 比 backspace 更加通用
* 后退 默认 Alt + 左
* app.csv 中先后顺序关系通过优先级进行定义

### 软件升级

下载新的发布包，提取 jiejian.exe / jiejian64.exe 覆盖即可。

另外 app.csv 和 data.csv 可按需覆盖。一般情况下建议 app.csv 和 data.csv 自定义内容追加在尾部，方便迁移数据。

## 感谢

本程序编辑 csv 文件用到了开源的 LiberOffice。主要发布平台为 [GitHub](https://github.com) 和 [GitCode](https://gitcode.com)。项目主页发布在 GitHub Page。

lib 下部分代码源自 [MyKeymap](https://xianyukang.com/MyKeymap.html) 项目。
