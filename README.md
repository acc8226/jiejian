# 捷键 for win 使用说明

* 基于 Autohotkey2 开发的按键映射 / 快捷键增强工具
* 为增强鼠标和键盘按键功能而生
* 不区分鼠标厂商，选择使用带侧边按键的鼠标，体验更完善。
* 支持自定义快捷键、快捷键改写、快捷键功能增强。提供快捷启动等功能。
* 建议搭配 [WGestures 1] / [WGestures 2] 全局鼠标手势 + [MyKeymap]（完善的窗口操作 & 启动程序 & 召唤窗口）软件进行使用。

注意：说明书指向最新版软件，若功能有差异，请[下载并使用最新版](https://gitcode.com/acc8226/jiejian/releases)。

## 1. 热键 之 鼠标操作

1\. 当鼠标移动到屏幕左边缘或者上边缘以及停留在任务栏时，鼠标滑轮滚动可以调节音量。

2\. 鼠标按键功能

| 按键 | 正常用途 | 多标签软件 | 音乐类软件 | 视频类软件 | 焦点在任务栏 | 焦点在左或上边界 |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| 鼠标右键 | - | - | - | - | - | 播放/暂停 |
| 鼠标中键 | - | - | - | - | 静音 | 静音 |
| 鼠标侧边前进键（XB2） | 同 alt + tab 按键 | 切换到上个标签 | 上一曲 | 上一个视频 | 上一曲 | 上一曲 |
| 鼠标侧边后退键（XB1） | 关闭窗口 | 在多标签页则是关闭当前标签 | 关闭当前标签 | 关闭窗口 | 下一曲 | 下一曲 |

![1](https://foruda.gitee.com/images/1689318820722473769/d4f9efe3_426858.gif)

3\. 按住 CapsLock 后可以用鼠标左键拖动窗口

## 2. 热键 之 重写快捷键

增强已有快捷键以及新增快捷键。支持众多常用软件，详细列表见附录。

| 按键 | 鼠标手势 | 正常用途 | 多标签软件 | 音乐类软件 | 视频类软件 | 焦点在任务栏或左/上边界
| ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| Esc（逃逸键）| 无 | 关闭特定窗口 | - | - | - | - |
| Ctrl + F3 | ↓ | 打开文件 或 新建文件/窗口 | 新建标签 | 打开文件 或 无操作 | 打开文件 或 无操作 | - |
| Ctrl + F4 | ↑ | 关闭窗口 | 关闭标签 | 关闭窗口 | 关闭窗口 | 关闭窗口 |
| Alt + ← | ← | 后退 | 后退 | 上一曲 | 快退 | 上一曲 |
| Ctrl + Shift + Tab | 上左 | - |切换上一个标签 | 上一曲 | 上一个视频 | 上一曲 |
| Alt + → | → | 前进 | 前进 | 下一曲 | 快进 | 下一曲 |
| Ctrl + Tab | 上右 | Ctrl + Tab | 切换下一个标签 | 下一曲 | 下一个视频 | 下一曲 |

注：

1. 多标签软件主要为浏览器，支持多标签的文本编辑器、IDE 等。
2. 音乐类软件如 QQ 音乐 等。其中 ctrl + f3 打开文件的功能仅适用于本地音乐播放器，在线音乐类软件可能不适用。
3. 视频类软件如 potplayer 等。
4. 以下部分场景使用了鼠标手势软件 [WGestures 1] / [WGestures 2] 替代了手动键入快捷键

操作资源管理器

![输入图片说明](https://foruda.gitee.com/images/1689318878983165049/4f89b32d_426858.gif "动画.gif")

操作 360 极速浏览器

![输入图片说明](https://foruda.gitee.com/images/1689320148290015829/d0563e32_426858.gif "动画.gif")

操作 Jetbrains IDEA

![输入图片说明](https://foruda.gitee.com/images/1689318910813101697/359f150e_426858.gif "动画.gif")

操作 microsoft vscode

![输入图片说明](https://foruda.gitee.com/images/1689318894573526368/39027a0d_426858.gif "动画.gif")

## 3. 热键 之 打开网址

* alt + 6 打开 B 站
* alt + 7 打开 IT 之家
* alt + 8 打开 西瓜视频

![打开网址](https://foruda.gitee.com/images/1689318923398248705/25b1c4c9_426858.gif "动画.gif")

## 4. 热键 之 运行程序

* Alt + j 打开记事本

![打开记事本](https://foruda.gitee.com/images/1689318934831690368/2606bf7a_426858.gif "动画.gif")

## 5. 热键 之 启动文件夹

* Alt + d 打开 D 盘

![打开D盘](https://foruda.gitee.com/images/1689318944226542670/0337e814_426858.gif "动画.gif")

## 6. 热键 之 其他

* Ctrl + 数字 1-5 为光标所在行添加 markdown 格式标题（目前仅开放了 vscode 和 windows 记事本的使用权限）

![输入图片说明](https://foruda.gitee.com/images/1689318964909077353/0518d03d_426858.gif "动画.gif")

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

![输入图片说明](https://foruda.gitee.com/images/1689321508560702893/2457a573_426858.gif "动画.gif")

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
  
![](https://foruda.gitee.com/images/1689259764657007580/13e4cb48_426858.gif "动画.gif")

* xwx 😄 微笑
* xlh 😊 脸红
* xok 👌 OK
* xax ❤️ 爱心
* xbz 📰 报纸
* xbq 🏷️ 标签
* xsq 🔖 书签
* xsh 💩 大便
* xgh 👻 鬼魂

![](https://foruda.gitee.com/images/1689259802922906219/d546cc12_426858.gif "动画.gif")

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

## 版本发布

### 未来计划

* 支持 尚未发布的 arc 浏览器 windows 版
* icon 添加按下效果
* 配置文件不太易用，需要优化

### 捷键 2024.01

项目名从 shortcut 正式改名为 jiejian

新增：

* 完善对 jetbrains 系列软件的支持，包含衍生的 Google Android Studio 和 华为 DevEco Studio。
* 支持已过时的 Atom
* 哔哩哔哩、GitKraken、Rstudio、foobar2000 和 方格音乐部分按键的支持
* 新增鼠标中间和右键的一些支持
* 新增 按住 CapsLock 后可以用鼠标左键拖动窗口 和 兜底的关闭功能更加完善了
  
* 添加 [MyKeymap] 和 wg 鼠标手势的玩法
* 新增了版本升级的功能
* 菜单选项重新调整
* 新增一键打包 package.ahk

### 捷键 2023 年度纪念版

这是 23 年最后的一个版本。提前祝大家 2024 年元旦快乐。

* 支持青鸟浏览器、小白浏览器、阿里云客户端、Spotify、CudaText、PotPlayer、Devecostudio 64位。
* 提供了 [WGestures 2] 预设手势方案
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

在运行窗口中运行 `shell:startup`，根据自己是 32 还是 64 位系统，按住 alt 键将 `jiejian32.exe` 或 `jiejian64.exe` 拖入 Startup 文件夹内即可。

## 附录

### 软件搭配玩法

#### 搭配 WGestures

这里我选用功能全面的 【付费】【win mac】[WGestures 2]

| 方向 | 名称 | 按键/功能 |
| ----  | ---- | ---- |
| ↗︎ | 最小化/min | 最小化 |
| ↙︎ | 最大化/max | 最大化/还原 |
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
| 左上 | 剪切/cut | ctrl + x |
| 左下 | 删除/del | del |
| 右上 | 百度选定文字 | wg 的网址直达功能 `https://baidu.com/s?wd={WG_SELECTED_TEXT}` |
| 右下 | 新建窗口/new | ctrl + shift + n |

#### 搭配 [MyKeymap](https://xianyukang.com/MyKeymap.html)

CapsLock 模式

| 按键 | 用途 |
| ----  | ---- |
| W | IDEA |
| E | VSCode |
| R | 在当前程序的窗口间轮换 |
| A | 360 极速浏览器 |
| S | 资源管理器 |
| D | 微信 |
| Z | 复制文件路径或纯文本 |
| C | musicplayer2 |

| 窗口标识符 | 当窗口不在时启动 | 备注 和 短语 和 key |
| ---- | ---- | ---- |
| ahk_exe SumatraPDF.exe | D:\alee\exec\daily\0.日常\2.办公类\SumatraPDF\SumatraPDF.exe | SumatraPDF【pd】 |
| ahk_exe PotPlayerMini64.exe | D:\alee\exec\daily\0.日常\4.视频类\Pot_Player64\PotPlayerMini64.exe | PotPlayer【vi】 |
| ahk_class Chrome_WidgetWin_1 ahk_exe Termius.exe | C:\Users\ferder\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Termius.lnk | Termius【tm】【t】 |
| ahk_exe MusicPlayer2.exe | D:\alee\exec\daily\0.日常\3.音频类\MusicPlayer2_x64\MusicPlayer2.exe | MusicPlayer2【mu】 |
| ahk_exe 360ChromeX.exe | shortcuts\360 极速浏览器X.lnk | 360极速浏览器【ch】【a】|
| ahk_class CabinetWClass ahk_exe Explorer.EXE | D:\ | 资源管理器【ex】【s】|
| ahk_exe WeChat.exe | shortcuts\微信.lnk | 微信【we】【d】|
| ahk_exe WindowsTerminal.exe | wt.exe | WindowsTerminal【te】【g】 |
| ahk_exe Code.exe | shortcuts\Visual Studio Code.lnk | vscode【co】【c】|
| ahk_exe idea64.exe | D:\alee\exec\dev\IDE\ideaIC-2022.3.3.win\bin\idea64.exe | IntelliJ IDEA【id】【v】|
| 一些内置函数 | ProcessExistSendKeyOrRun("TIM.exe", "^!z", "shortcuts\TIM.lnk") | 如果 TIM.exe 进程存在则输入 Ctrl+Alt+Z 热键激活 TIM，否则启动 TIM |

CapsLock 命令

| 按键 | 参数1 | 参数2 | 参数3 |
| ----  | ---- | ---- | ---- |
| cc | shortcuts\Visual Studio Code.lnk | -n "{selected}" | 用 VS Code 打开选中的文件，在新窗口中打开 |
| wt | wt.exe | -d "{selected}" | 用 Windows Terminal 打开选中的文件夹 |

### 适配软件列表

软件入选原则：主要收录热门软件，其中主要以浏览器比较全。

已知 bug：

* Right PDF Reader 的鼠标侧边后退键无效。
* 适配不太好的软件：搜狗浏览器。
* 测试关闭窗口不奏效的软件：极客卸载、windows 任务管理器（似乎屏蔽了 ctrl 键）。

支持但不限于以下百余款软件，且持续更新中...

* 360 压缩
* BvSsh
* ahk 应用程序
* Visual Studio
* skylark 主程序
* 【系统】Win11 21h1 桌面
* 【系统】Win11 22h2 桌面
* 【系统】Win11 资源管理器
* 【系统】Win11 旧版 记事本
* 【系统】Win11 新版 记事本
* 【系统】新版 win 11 设置
* 【浏览器】115
* 【浏览器】123
* 【浏览器】2345
* 【浏览器】360 极速
* 【浏览器】360 安全
* 【浏览器】Avast
* 【浏览器】Brave
* 【浏览器】Chrome 谷歌 & 百分 & 小马浏览器
* 【浏览器】Duck
* 【浏览器】Duoyu 多御
* 【浏览器】Edge
* 【浏览器】Firefox火狐 & Tor洋葱
* 【浏览器】Opera
* 【浏览器】QQ
* 【浏览器】UC
* 【浏览器】UU
* 【浏览器】Vivaldi
* 【浏览器】Waterfox
* 【浏览器】Yandex
* 【浏览器】傲游
* 【浏览器】斑斓石
* 【浏览器】红芯【已过时】
* 【浏览器】华为
* 【浏览器】极速
* 【浏览器】联想
* 【浏览器】猎豹
* 【浏览器】猫眼
* 【浏览器】蚂蚁
* 【浏览器】青鸟
* 【浏览器】搜狗
* 【浏览器】双核
* 【浏览器】星愿
* 【浏览器】想天
* 【浏览器】小K
* 【浏览器】小白
* 【浏览器】小智双核
* 【浏览器】一点
* 【音乐类】foobar2000
* 【音乐类】MusicPlayer2
* 【音乐类】QQ音乐
* 【音乐类】Spotify
* 【音乐类】方格音乐
* 【音乐类】酷我音乐
* 【音乐类】汽水音乐
* 【音乐类】网易云音乐
* 【音乐类】喜马拉雅
* 【音乐类】酷狗音乐
* 【视频类】GridPlayer【部分支持】
* 【视频类】mpv【部分支持】
* 【视频类】KMPlayer 64位
* 【视频类】PotPlayer 64位
* 【视频类】vlc
* 【视频类】抖音【不支持】
* 【视频类】恒星播放器
* 【sql】Beekeeper Studio
* 【sql】Heidisql
* 【sql】Navicat
* 【sql】SQLyog
* 【md】MarkdownPad2
* 【md】MarkText
* 【md】Typora
* 【editor】Atom【已过时】
* 【editor】Bracket
* 【editor】CudaText
* 【editor】Editplus
* 【editor】Everedit
* 【editor】Fleet
* 【editor】Geany
* 【editor】Kate
* 【editor】Notepad++
* 【editor】Notepad--
* 【editor】Notepad2
* 【editor】Notepad3
* 【editor】Sublime
* 【editor】Ultraedit
* 【file compare】Beyond Compare
* 【file compare】WinMerge
* 【IDE】Dev C++
* 【IDE】Eclipse
* 【IDE】HbuilderX
* 【IDE】MyEclipse
* 【IDE】Rstudio
* 【IDE】SpringToolSuite4
* 【IDE】VS Code
* 【jetbrains】Aqua
* 【jetbrains】Clion
* 【jetbrains】Datagrip
* 【jetbrains】Dataspell
* 【jetbrains】Goland
* 【jetbrains】Idea
* 【jetbrains】Phpstorm
* 【jetbrains】Pycharm
* 【jetbrains】Rider
* 【jetbrains】RubyMine
* 【jetbrains】RustRover
* 【jetbrains】Webstorm
* 【jetbrains】Writerside
* 【jetbrains】Android Studio
* 【jetbrains】华为 DevEco Studio
* Netbean 32 位 & Jmeter
* Netbean 64 位
* 【http调试】Apifox
* 【http调试】ApiPost
* 【http调试】HTTPie
* 【http调试】Postman
* Zeal
* 【git】GitHub 桌面版
* 【git】GitKraken
* 【git】SourceTree
* 【git】小乌龟 Git 的 merge 窗口
* 【终端类】Finalshell
* 【终端类】Hyper
* 【终端类】MobaXterm
* 【终端类】SecureCRT
* 【终端类】Tabby
* 【终端类】Termius
* 【终端类】WindTerm
* 【终端类】WindowsTerminal
* 【终端类】Xshell
* 【终端类】zoc
* 【ftp】FlashFXP
* 【ftp】Xftp
* 【pdf】Right PDF Reader【部分支持】
* 【pdf】Sumatra PDF
* 【pdf】UPDF
* 【pdf】福昕PDF编辑器
* 【pdf】福昕阅读器
* 【pdf】极速 PDF
* 【pdf】金山PDF独立版
* 【pdf】迅读PDF
* LibreOffice 窗口
* LibreOffice 主体
* Motrix
* Snipaste
* WPS Office
* WPS 图片查看器
* 哔哩哔哩
* 阿里云客户端
* 雷鸟
* 炉石传说
* 腾讯QQ
* 稻壳阅读器
* 微信
* 微信内置浏览器

### 打包发版目录结构

每次打包都在 out 目录。

1. extra/ 【增强体验】MyKeymap2/data/config.json 为预设配置。WGestures V1/V2 为预设手势模版。WindowSpyU32.exe 用于查看窗口标识符。
2. app.csv 配置文件
3. data.csv 配置文件
4. help.url 在线帮助文档
5. **jiejian32/64.exe** 分别为 32/64 位主程序 免安装，双击即用

### 设计思路

* 严格按照 ahk 中的 hotIf 的优先匹配原则。一般 esc 会在前。由于考虑到 Esc 逃逸键 用于关闭窗口，目前支持记事本中使用。
* Ctrl + F3 为新建标签/窗口 避免和已有 Ctrl + t 冲突
* Ctrl + Shift + Tab / Ctrl + Tab 切换到上/下个标签 默认不需要重写
* Ctrl + F4 为关闭标签/窗口，避免和常见的 Ctrl + w 冲突
* Ctrl + Shift + t 撤销关闭标签 默认不需要重写
* Alt + 左方向键 比 backspace 更加通用
* 后退 默认 Alt + 左
* app.csv 中先后顺序关系通过优先级进行定义

适配视频类软件：分别找出打开、快进、快退、切换上一个视频、切换下一个视频的快捷键。

### 软件升级

jiejian.exe 的文件版本为当前四位版本号，产品版本为当前编译的 ahk 版本。

升级信息会写入了注册表，而非传统 ini 文件。

升级有两个渠道，release 为正式版 和 snapshot 为测试版。release 版本中会自动检查更新间隔为 1 天。snapshot 版本中为每次启动的时候。

下载新的发布包，提取 jiejian.exe / jiejian64.exe 覆盖即可。

另外 app.csv 和 data.csv 可按需覆盖。一般情况下建议 app.csv 和 data.csv 自定义内容追加在尾部，方便迁移数据。

## 软件构建

建议在 64 为环境编译和打包该软件。32 位平台我就没试过。

测试平台：win11 22H2 64 位系统 + ahk 2.0.11 64 位主程序 + UPX 压缩

在安装 ahk 之后，双击 jiejian.ahk 即可运行

打包则双击 package.ahk 即可。

package.ahk 的设计思路：Ahk2Exe.exe 将 ahk 转化为 exe，期间使用 /compress 制定了压缩方式。ahk 编译会触发 jiejianPostExec.ahk。jiejianPostExec.ahk 做了两件事：写入版本信息 和 将文件夹命名为 jiejian-版本。

## 鸣谢

本程序编辑 csv 文件用到了开源的 LiberOffice。主要发布平台为 [GitHub](https://github.com) 和 [GitCode](https://gitcode.com)。项目主页发布在 GitHub Page。

lib 下部分代码源自 [MyKeymap] 项目。

[MyKeymap]: https://xianyukang.com/MyKeymap.html
[WGestures 1]: https://www.yingdev.com/projects/wgestures
[WGestures 2]: https://www.yingdev.com/projects/wgestures2
