---
title: 捷键使用说明
date: 2023-05-01 09:00:00
updated: 2024-05-23 16:20:20
categories: 我的创作
---

# 捷键使用说明

<span>
  <img alt="Static Badge" src="https://img.shields.io/badge/%E6%8D%B7%E9%94%AE-for%20windows-blue" style="display:inline-block;margin: 0 1px;">
  <img src="https://img.shields.io/github/languages/top/acc8226/jiejian" style="display:inline-block;margin: 0 1px;" alt="GitHub top language">
  <img src="https://img.shields.io/github/commit-activity/y/acc8226/jiejian" style="display:inline-block;margin: 0 1px;" alt="GitHub commit activity">
  <img src="https://img.shields.io/github/last-commit/acc8226/jiejian" style="display:inline-block;margin: 0 1px;" alt="GitHub last commit">
  <img src="https://img.shields.io/badge/release-24.2.12-green" style="display:inline-block;margin: 0 1px;" alt="Static Badge">
  <img src="https://img.shields.io/badge/beta-24.5.17-yellow" style="display:inline-block;margin: 0 1px;" alt="Static Badge">
</span>

A key mapping/shortcut enhancement tool developed based on [Autohotkey2](https://www.autohotkey.com/), designed to simplify keyboard and mouse operations in Windows. It can serve as a traditional launcher and also supports mouse side buttons and hotkeys effectively.

It is highly recommended to use it in conjunction with global mouse gesture software and a mouse with side buttons.

System Requirements: Compatible with Windows XP and above, but it is recommended to run smoothly on at least Windows 7.

基于 [Autohotkey2](https://www.autohotkey.com/) 开发，为简化 Windows 键鼠操作而生的按键映射/快捷键增强工具。既可当作一个传统启动器，又对鼠标侧边按键和热字符支持良好。

**强烈建议搭配全局鼠标手势软件 和 任意带侧边按键的鼠标器**（本软件不挑鼠标厂商）以获得最佳体验。

系统要求：支持 32 位和 64 位 Windows，理论上 XP 以上系统均可，Win 7 以上使用更佳。

[video demonstration 视频演示](https://www.bilibili.com/video/BV19H4y1e7hJ?vd_source=54168537affc2c02555097cb26797d99) | [download 下载地址][捷键]

**注意事项：**

1. 若软件功能有差异，以最新版为准。
2. 本程序开源，无毒无后门不收集任何信息。如被误报错杀，请加入排除清单。

**和一些软件对比**

当我开发几个月后，发现市场上早就有了此类成熟软件，我可能连其中任一软件的百分之十的完成度都达不到。

| 功能 |  macOS 平台 | Windows 平台 |
| ---- | ---- | ---- |
| 侧边按键支持 | [BetterAndBetter][]【免费】 | [捷键][]【免费】 或 一些鼠标手势软件支持 |
| 热字符串 | [Espanso][]【免费】 | [捷键][]【免费】 或 Espanso |
| 启动器 | [Raycast][]【免费】/Alfred【付费】/ HapiGo【部分免费】 | [捷键][]【免费】 或 uTools 或 Listary |
| 启动程序/窗口切换 | [Hammerspoon][] 脚本【免费】 | [捷键][]【免费】 或 mykeymap 或 ahk 脚本 |

毕竟是我业内摸鱼和业外空闲时间开发，优点恐怕只剩下功能较多和足够小巧了。下一步我的工作将逐渐放在提升交互上。

## 1. 程序目录结构

1. custom/customAhkFile1.ahk 为自定义 ahk 脚本，用于集成额外脚本或者函数
2. extra/FastGestures 和 WGestures 为预设鼠标手势模版。GenerateShortcuts.exe 用于生成快捷方式文件夹 shortcuts。WindowSpyU32.exe 用于查看窗口标识符。
3. app.csv 配置文件
4. data.csv 配置文件
5. **jiejian32/64.exe** 分别为 32/64 位主程序。双击即用，并强烈建议设置为开机自启

## 2. 热键 之 键鼠操作

| 鼠标 | 按键 | 建议映射手势 | 名称 | 默认用途 | 多标签软件 | 音乐类软件 | 视频类软件 | 看图软件 | 焦点在任务栏 | 焦点在左边界 | 焦点在上边界 | 焦点在桌面 |
| ---- | ---- | ---- |---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| - | **Esc** | - | 逃逸/esc | 退出窗口 | - | - | - | - | - | - | - | - |
| **鼠标右键** | - | - | - | - | - | - | - | - | - | 播放/暂停 | 播放/暂停 | - |
| **鼠标中键** | - | - | - | - | - | - | - | - | 静音 | 静音 | 静音 | - |
| **滚轮上滑** | - | - | - | - | - | - | - | - | 调高音量 | 调高音量 | 下一曲 | - |
| **滚轮下滑** | - | - | - | - | - | - | - | - | 调低音量 | 调低音量 | 上一曲 | - |
| **鼠标侧边后退键**(XB1) | - | - | 关闭/close | 关闭窗口 | 关闭标签 | 关闭窗口 | 关闭窗口 | 关闭窗口 | 下一曲 | 下一曲 | - | - |
| - | **Ctrl+F4** | ↑ | 关闭/close | 关闭窗口 | 关闭标签 | 关闭窗口 | 关闭窗口 | 关闭窗口 | - | - | - | - |
| - | **Ctrl+F8** | ↓ | 新建/new | 打开或新建文件 | 新建标签 | 打开文件 或 无操作 | 打开文件 或 无操作 | 打开文件 或 无操作 | - | - | - | - |
| - | **Alt + ←** | ← | 后退/prev | 后退 | 后退 | 上一曲 | 快退 | 上一张 | - | - | - | 上一曲 |
| - | **Alt + →** | → | 前进/next | 前进 | 前进 | 下一曲 | 快进 | 下一张 | - | - | - | 下一曲 |
| **鼠标侧边前进键**(XB2) | - | - | 上一个/prev | - | 上一页 | 上一曲 | 上个视频 | - | 上一曲 | 上一曲 | - | 上一曲 |
| - | **Ctrl+Shift+Tab** | 上左 | 上一个/prev | - | 上一页 | 上一曲 | 上个视频 | - | - | - | - | - |
| - | **Ctrl+Tab** | 上右 | 下一个/next | - | 下一页 | 下一曲 | 下个视频 | - | - | - | - | - |
| - | **Ctrl+Shift+N** | 右下 | 新建窗口/new | 新建窗口 | - | - | - | - | - | - | - | - |
| - | **Ctrl+F7** | 右左 | 置顶/top | 置顶 | - | - | - | - | - | - | - | - |
| - | **F11** | ↓↑ | 全屏/fullscreen | 全屏/取消全屏 | - | - | - | - | - | - | - | - |

下图为鼠标滚动调节音量示例

![鼠标滚动示例](https://foruda.gitee.com/images/1689318820722473769/d4f9efe3_426858.gif)

注：

1. 建议优先使用鼠标按键进行驱动，因此最好搭配带侧边按键的鼠标。其次考虑安装鼠标鼠标手势驱动快捷键例如 [WGestures 2][WGestures 2付费链接]，最后才考虑直接使用快捷键。
2. 多标签软件主要为各类浏览器，支持多标签的文本编辑器、IDE 等等。
3. 音乐类软件囊括了 Spotify、QQ 音乐、网易云音乐等。其中 Ctrl + F3 打开文件对本地音乐播放器适配良好，在线音乐类软件可能不适用。
4. 视频类软件例如 PotPlayer、VLC。
5. 看图软件如 2345 看图王、Bandiview、ImageGlass。
6. F11 特别适配了 b 站和油管。

除了 [WGestures 2][WGestures 2付费链接]【付费】以外，[WGestures 1][]【免费】和 [FastGestures][]【免费】也是不错的选择。

以下部分场景使用了鼠标手势软件替代了手动键入快捷键。

操作 windows 资源管理器

![](https://foruda.gitee.com/images/1689318878983165049/4F89b32d_426858.gif "动画.gif")

操作 360 极速浏览器

![](https://foruda.gitee.com/images/1689320148290015829/d0563e32_426858.gif "动画.gif")

操作 Jetbrains IDEA

![](https://foruda.gitee.com/images/1689318910813101697/359f150e_426858.gif "动画.gif")

操作 microsoft vscode

![](https://foruda.gitee.com/images/1689318894573526368/39027a0d_426858.gif "动画.gif")

## 3. 热键 之 打开网址

* Alt + 6 打开 B 站
* Alt + 7 打开 IT 之家
* Alt + 8 打开 西瓜视频

![打开网址](https://foruda.gitee.com/images/1689318923398248705/25b1c4c9_426858.gif "动画.gif")

## 4. 热键 之 运行程序

* Alt + 1 打开/切换窗口 资源管理器
* Alt + 2 打开/切换窗口 360 极速浏览器【若程序路径存在 data.csv 中】
* Alt + 3 打开/切换窗口 VSCode【若程序路径存在 data.csv 中】
* Alt + j 打开/切换窗口 记事本

![打开记事本](https://foruda.gitee.com/images/1689318934831690368/2606bf7a_426858.gif "动画.gif")

## 5. 热键 之 启动文件夹

* Alt + d 打开 D 盘

![打开 D 盘](https://foruda.gitee.com/images/1689318944226542670/0337e814_426858.gif "动画.gif")

## 6. 热键 之 其他

预设条件：当 vscode 或 windows 记事本在激活状态下。

* Ctrl + 数字 1-5 为光标所在行添加 markdown 格式标题

![输入图片说明](https://foruda.gitee.com/images/1689318964909077353/0518d03d_426858.gif "动画.gif")

* `Ctrl + Alt + r` 重启脚本
* `Ctrl + Alt + s` 暂停脚本
* `Ctrl + Alt + v` 剪贴板的内容输入到当前活动应用程序中，防止了一些网站禁止在 HTML 密码框中进行粘贴操作
* `Ctrl + Shift + "`  插入一对双引号

## 7. Anyrun 启动器

争做一款简洁、高效的应用启动器。由于定制化程度太高甚至会导致难以上手，提供快捷启动和内置系统命令（锁屏、睡眠、关机等）

特点：

1. 窄边框设计，界面极简。支持模糊搜索，帮助快速定位应用。
2. 使用普适易读的微软雅黑字体，字号设计合理，字体风格简洁大方。
3. 支持自定义多种关键词进行应用匹配，智能识别用户意图。
4. 系统资源占用少，启动迅速，可靠性高，全天候支持用户的应用启动需求。

使用说明：

* `Alt + 空格` 开启快捷启动器。若再次按下 空格/esc键/鼠标在启动器外点击 则关闭该组件。
* 自动识别剪切板有没有内容，如果输入内容是文件或者网址 且离最后一次 ctrl + c 操作小于 13 秒则自动粘贴内容。
* 支持全拼甚至首字母简拼模糊搜索，上下键切换，回车或鼠标双击进行选中。

### 打开程序/文件/网址

在输入框中输入内容后按下回车

* `guanyu` 打开关于 windows 程序
* `fdj` 打开放大镜程序
* `163.com` 打开网址-网易网
* `https://www.soso.com` 打开网址-搜搜网
* `D:\code\atomgit\jiejian` 前往文件夹
* `D:\code\atomgit\jiejian\README.md` 打开 markdown 文档
* `D:\code\atomgit\jiejian\shortcuts\File Explorer.lnk` 打开快捷方式
* `xg/xigua` 打开西瓜视频

### 打开搜索

* `by` 必应搜索：在框中输入 by[空格?]{关键字}
* `bi` 哔哩哔哩搜索
* `bd` 百度搜索
* `ip` 归属地查询
* `so` 360 搜索
* `sg` 搜狗搜索
* `wz` 无追搜索
* `xg` 西瓜视频
* `yc` 异次元软件
* `gh` Github
* `qr` 创建二维码

![](https://foruda.gitee.com/images/1689321508560702893/2457a573_426858.gif "动画.gif")

### 打开内部/外部命令

内部命令

* `zhongduan/cmd/终端` 终端
* 网络连接
* 收藏夹
* 字体
* 打印机
* 我的文档
* 回收站
* 我的桌面
* 我的下载
* 我的图片
* 我的视频
* 我的音乐
* 环境变量
* 重启
* 关机
* 锁屏
* 睡眠
* 激活屏幕保护程序
* 清空回收站
* 息屏
* 注销
* 静音
* 上一曲
* 下一曲
* 暂停
* 息屏
* 睡眠
* 关机

### DL-打开软件下载站

例如输入 `dlqqmusic` 表示跳转到 QQ 音乐客户端下载网址

### 增强的操作文件和网址的能力

当在 anyrun 编辑框中输入文件路径/网址可以获得以下能力：

* 打开网址
* 打开文件
* 前往文件夹
* 查看属性
* 打印文件
* 删除文件
* 在 Bash 中打开（若 data.csv 中 d 列 `Bash` 对应的 b 列路径存即启用）
* 在终端中打开（若 data.csv 中 d 列 `新终端` 对应的 b 列路径存即启用新终端，否则启用旧终端 cmd.exe）
* 在 VSCode 中打开（若 data.csv 中 d 列 `VSCode` 对应的 b 列路径存即启用）
* 在 IDEA 中打开（若 data.csv 中 d 列 `IDEA` 对应的 b 列路径存即启用）

## 8. 热串 之 直达网址（Z 直达模式）

为避免误触，排除了在文本编辑器/ftp/git/IDE/office/sql/窗口软件中激活 z 模式。

* zbd 打开 百度一下
* zbi 打开 哔哩哔哩
* zdy 打开 电影天堂
* zit 打开 IT 之家
* zma 打开 QQ 邮箱
* zxg 打开 西瓜视频

zbd 示例

![](https://foruda.gitee.com/images/1689318989538537685/7b71d232_426858.gif)

zbi 示例

![](https://foruda.gitee.com/images/1689319007424875617/4934e693_426858.gif)

## 9. 热串之 扩展片段：将字符串替换为自定义话术（X 拓展模式）【可配置】

固定配置

* xnow 插入当前日期时间，举例 `2023-08-27 09:10:41`
* xdate 插入特定格式的当前日期时间，举例 `Date: 2023-12-22 21:23:30`

data.csv 可自由配置

* xnb 很牛呀
* xnm 你妹的
  
![](https://foruda.gitee.com/images/1689259764657007580/13e4cb48_426858.gif "动画.gif")

* xwx 😄 微笑
* xlh 😊 脸红
* xok 👌 OK
* xax ❤️ 爱心
* xbz 📰 报纸
* xbq 🏷️ 标签
* xsq 🔖 书签
* xsh 💩 大便

![](https://foruda.gitee.com/images/1689259802922906219/d546cc12_426858.gif "动画.gif")

## 10. 左键辅助

受到 quicker 影响，试验性的加入左键辅助功能。

在鼠标左键按下的同时按下 a 键时，若选中为网址则打开网址，否则百度搜索选中内容。

## 11. CapsLock 模式

按住 CapsLock 后可以用鼠标左键拖动窗口；
按住 CapsLock 键的同时按下以下键可激活特殊功能，其中大部分按键参考了 [MyKeymap][]。

| 按键 | 用途 |
| ---- | ---- |
| Q | 最大化或还原程序 |
| W | 切换到上个窗口 |
| E | 当前窗口恢复不透明 |
| R | 在当前程序的窗口轮换 |
| T | 当前窗口调成半透明(Translucent) |
| Y | 切换到上一个虚拟桌面 |
| P | 切换到下一个虚拟桌面 |
| Z | 复制文件路径或纯文本 |
| X | 关闭窗口 |
| V | 窗口移到下一个显示器 |
| B | 窗口最小化 |
| 空格 | 复制选中文件路径并打开 Anyrun 启动器 |

## 12. 双击模式

预设动作如下，若双击间隔大于 100 毫秒 且 小于 239 毫秒会触发：

* 双击 Alt：息屏（无弹窗提醒）
* 双击 Home：睡眠（无弹窗提醒）
* 双击 End：关机（有确认对话框）

可以手动去 data.csv 中对意图进行修改。d 列置空 或者 删除该列可以屏蔽该命令。
<br />由于中英文切换经常用到 Shift，日常快捷键常用到 ctrl，所以这两个按键不再提供作为前置键。
<br />目前仅支持上述第 7 小节列出的所有内部命令。

## 自定义配置说明

配置文件 **app.csv**（用于配置软件的快捷键）、**data.csv**（用于配置启动器候选项以及热键、热串） 必须和 ahk 脚本文件在同一级目录，且必须使用 GB18030 字符集。
<br />app.csv 使用了正则表达式，需要使用者对正则有一定了解。主要用到了 `^$` 锚和不区分大小写 `i` 选项。
<br />推荐使用开源软件 [LiberOffice](https://www.libreoffice.org/download/download-libreoffice/) 或微软 Office 打开。不要使用 WPS 进行打开，WPS 目前有兼容性问题。

### app.csv 配置

用于增强和改写快捷键

* A 列 必填 名称
* B 列 非必填 默认不填为低，一般搭配窗口使用窗口页填高
* C 列（标识符）必填项。其余皆为可选项。只需填写需要变更的快捷键即可，否则可留空
* F 列 非必填，否则默认触发关闭窗口动作
* M 列 是否启用列，默认启用，不启用请填写 n 或者 N。
* 其他列可参考已有写法，可填入要增强/改写得对于软件的快捷键

### data.csv 配置

anyrun 启动器用

* A 列 类型：程序 / 文件 / 网址 / 搜索 / 内部 / 外部 / 下载
* B 列 启动路径：实际运行的网址或程序路径
* D 列 运行名称：用于展示
* E 列 运行关键字：匹配关键字，若有多个通过 | 进行分割。

自定义热键

* A 列 类型：程序 / 文件 / 网址
* B 列 启动路径：实际运行的网址或程序路径
* C 列 要激活的窗口(仅热键 激活 程序时使用)
* F 列 热键关键字：例如 !6 表示 Ctrl + 数字 6

自定义热串

* A 列 类型：文本 / 网址
* B 列 启动路径：实际运行的网址或程序路径
* G 列 热串关键字：例如 zbd 表示打开百度网

其他列说明

* H 列 是否启用列，默认启用，不启用请填写 n 或者 N。
* I 列 备注列，该列不会被解析

## 未来计划

* 支持 Arc 浏览器 for windows，目前 Arc 只开放了 win 11
* icon 点击后使用新图标，而不是系统样式的图标
* 配置文件不太易用，需要优化

## 常见问题

### 如何将捷键设置为开机自启

在系统栏中找到捷键，鼠标右击并勾选*开机自启(A)*。

### 填写 xxx.exe 程序无法启动

以汽水音乐为例，使用实际的 `C:\Users\zhangsan\AppData\Local\Programs\Soda Music\SodaMusic.lnk` lnk 文件替代 exe 方式即可。

## 附录

### 软件搭配玩法

可搭配 WGestures 2

由于 WGestures 1 由于不支持字母手势。这里我选用的是【付费】【win mac】[WGestures 2][WGestures 2付费链接]。它是一款跨平台全局鼠标手势，且完美契合本软件。目前售价 35 米，优惠的[购买地址][WGestures 2付费链接]我也放这儿了。

### 已适配软件

软件挑选原则：个人偏好以及热门、常用软件，其中又以浏览器收集最为全面。

支持但不限于以下两百余款软件，且持续更新中...

* 【压缩】360 压缩 4.0【部分支持】
* 【压缩】7zip 24.01
* 【压缩】Bandizip 7.32
* 【压缩】WinRAR 6.24
* 【压缩】WinZip
* 【压缩】好压【部分支持】
* 【系统】Win 7、10、11 资源管理器
* 【系统】Win 10 画图
* 【系统】Win 7、10 记事本
* 【系统】Win 11 新版记事本
* 【系统】Win 7 桌面
* 【系统】Win 10 桌面
* 【系统】Win 10、11 设置
* 【浏览器】115、123
* 【浏览器】2345
* 【浏览器】360 AI
* 【浏览器】360 极速
* 【浏览器】360 游戏
* 【浏览器】360 安全
* 【浏览器】Avast 浏览器
* 【浏览器】Brave 浏览器
* 【浏览器】CCleaner Browser
* 【浏览器】Chrome 谷歌 & 百分 & 小马
* 【浏览器】Duck 浏览器
* 【浏览器】Duoyu 多御
* 【浏览器】Edge
* 【浏览器】Firefox火狐 & Tor洋葱 & Waterfox
* 【浏览器】Opera
* 【浏览器】QQ
* 【浏览器】UC
* 【浏览器】UU
* 【浏览器】Vivaldi
* 【浏览器】Yandex
* 【浏览器】傲游
* 【浏览器】斑斓石
* 【浏览器】飞牛
* 【浏览器】华为
* 【浏览器】极速
* 【浏览器】联想
* 【浏览器】猎豹
* 【浏览器】猫眼
* 【浏览器】猎鹰
* 【浏览器】蚂蚁
* 【浏览器】青鸟
* 【浏览器】搜狗
* 【浏览器】双核
* 【浏览器】星愿
* 【浏览器】想天
* 【浏览器】小K、小白、小智
* 【浏览器】一点
* 【浏览器】微软 IE 11【已过时】
* 【浏览器】红芯【已过时】
* 【音乐类】Foobar2000
* 【音乐类】iTunes
* 【音乐类】MusicBee
* 【音乐类】MusicPlayer2
* 【音乐类】Winamp 5.9.2
* 【音乐类】洛雪音乐助手
* 【音乐类】QQ 音乐
* 【音乐类】Spotify
* 【音乐类】方格音乐【部分支持】
* 【音乐类】酷我音乐
* 【音乐类】汽水音乐
* 【音乐类】网易云音乐
* 【音乐类】喜马拉雅
* 【音乐类】酷狗音乐
* 【视频类】GridPlayer【部分支持】
* 【视频类】KMPlayer 64位
* 【视频类】MPV【部分支持】
* 【视频类】PotPlayer 64位
* 【视频类】vlc
* 【视频类】暴风影音 5
* 【视频类】恒星播放器
* 【视频类】迅雷影音
* 【视频类】影音先锋
* 【视频类】荐片播放器
* 【视频类】哔哩哔哩
* 【视频类】爱奇艺
* 【视频类】优酷
* 【视频类】腾讯视频
* 【视频类】斗鱼直播【部分支持】
* 【sql】Beekeeper Studio
* 【sql】Heidisql
* 【sql】Navicat
* 【sql】SQLyog
* 【markdown】MarkdownPad2
* 【markdown】MarkText
* 【markdown】Typora
* 【editor】Bracket
* 【editor】CudaText
* 【editor】Editplus
* 【editor】EmEditor
* 【editor】Everedit
* 【editor】Fleet
* 【editor】Geany
* 【editor】Kate
* 【editor】Notepad++
* 【editor】NotepadNext
* 【editor】Notepad--
* 【editor】Notepads
* 【editor】Notepad2
* 【editor】Notepad3
* 【editor】SciTE
* 【editor】skylark
* 【editor】Sublime
* 【editor】Ultraedit
* 【editor】Atom【已过时】
* 【file compare】Beyond Compare
* 【file compare】WinMerge
* 【IDE】DevC++
* 【IDE】Eclipse
* 【IDE】HbuilderX
* 【IDE】Aqua、Clion、Datagrip、Dataspell、Goland、Idea、Pycharm、Phpstorm、Rider、RubyMine、RustRover、Webstorm、Writerside
* 【IDE】Android Studio、华为 DevEco Studio
* 【IDE】MyEclipse
* 【IDE】Rstudio
* 【IDE】SpringToolSuite4
* 【IDE】VS Code
* 【IDE】Visual Studio
* 【IDE】Netbean 32 位 & Jmeter
* 【IDE】Netbean 64 位
* 【http调试】Apifox
* 【http调试】ApiPost
* 【http调试】HTTPie
* 【http调试】Postman
* Zeal
* 【git】GitHub 桌面版
* 【git】GitKraken
* 【git】SourceTree
* 【git】小乌龟 git 合并程序
* 【终端类】Bitvise SSH Client
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
* 【ftp】Filezilla
* 【ftp】FlashFXP
* 【ftp】Xftp
* 【pdf】Adobe Acrobat
* 【pdf】Right PDF Reader
* 【pdf】Sumatra PDF 主页
* 【pdf】UPDF
* 【pdf】福昕 PDF 编辑器
* 【pdf】福昕阅读器
* 【pdf】极速 PDF
* 【pdf】金山 PDF 独立版
* 【pdf】迅读 PDF
* 【pdf】永中 Office 版式阅读器
* 【pdf】可牛 PDF
* 【pdf】万兴 PDF 阅读器
* 【office】LibreOffice
* 【office】微软 Excel 2007、2021
* 【office】微软 PPT 2007、2021
* 【office】微软 Word 2007、2021
* 【office】ONLYOFFICE
* 【office】WPS Office
* 【office】永中简报 2024
* 【office】永中表格 2024
* 【office】永中文字 2024
* 【看图】2345 看图王
* 【看图】FSViewer
* 【看图】Honeyview or BandiView
* 【看图】ImageGlass
* 【看图】JPEGView
* 【看图】pineapple pictures 菠萝看图
* 【看图】Windows 照片查看器
* 【看图】WPS 图片查看器
* 【看图】xnview
* Motrix
* Snipaste
* Thunderbird 雷鸟
* 阿里云客户端
* 稻壳阅读器
* 炉石传说
* 腾讯 QQ
* 微信
* IDLE Shell

不支持的软件：

* 抖音
* 快压

无需适配的软件：

* 西瓜视频

### 已知 bug

* 适配不太好的软件：Right PDF Reader 的鼠标侧边后退键无效。
* Caps + x / ctrl + f4 关闭窗口对一些软件不奏效：极客卸载、注册表编辑器、windows 任务管理器（似乎屏蔽了 Ctrl 键）、高级系统设置等窗口、WGestures 的导入导出窗口。
* 当任务管理器或者高级系统设置等窗口激活时鼠标滚轮捕捉不到，会导致鼠标靠在边界调节音量功能失效

## 如何反馈

1. b 站私信
2. 软件完全免费开源，仓库地址 [AtomGit source](https://atomgit.com/acc8226/jiejian/) | [Github source](https://github.com/acc8226/jiejian)，有问题或需求欢迎提 [issue](https://github.com/acc8226/jiejian/issues)

## 支持作者

如果认为它有用/有帮助，欢迎任何形式的支持，不限于[充电](https://space.bilibili.com/107606582)、[follow](https://github.com/acc8226)、fork、star 和[微信打赏](https://github.com/acc8226/acc8226/blob/main/needYou.png)，这都将激励作者后续前进。

## 写在最后

由于 Autohotkey 这门语言容易学习。再加上我之前编程功底，从设计到开发均由我一人完成。部分源码参考了 Windows 软件 MyKeymap [主页][MyKeymap] | [源码][MyKeymap Github repo]、Capslock+ [主页][Capslock+] | [源码][Capslock+源码]。并从 Windows 软件 [Quicker][]、[uTools][] 和 macOS 软件 [BetterAndBetter][]、[HapiGo][] 和 [Raycast][] 中受到启发。因此依旧感谢开源和非开源。

  [MyKeymap]: https://xianyukang.com/MyKeymap.html ''
  [MyKeymap Github repo]: https://github.com/xianyukang/MyKeymap ""
  [WGestures 1]: https://www.yingdev.com/projects/wgestures ''
  [WGestures 2]: https://www.yingdev.com/projects/wgestures2 ""
  [WGestures 2付费链接]: https://store.lizhi.io/site/products/id/523?cid=46jjayiu "一款很屌的付费鼠标手势"
  [FastGestures]: https://fg.zhaokeli.com/ ""
  [Capslock+]: https://capslox.com/capslock-plus ""
  [Capslock+源码]: https://github.com/wo52616111/capslock-plus ""
  [Raycast]: https://www.raycast.com ""
  [HapiGo]: https://www.hapigo.com ""
  [BetterAndBetter]: https://www.better365.cn/bab2.html ""
  [Quicker]: https://getquicker.net/ ""
  [uTools]: https://www.u.tools/ ""
  [Hammerspoon]: https://www.hammerspoon.org/ ""
  [Espanso]: https://espanso.org/ ""

  [捷键]: https://atomgit.com/acc8226/jiejian/tags?tab=release "我的诚意之作"
