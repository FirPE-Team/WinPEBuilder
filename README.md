# FirPE

## 介绍

FirPE 项目

## 使用说明

### 构建

使用 boot.wim 卷 2 进行构建，WinRE 可能会黑屏

## WinPE 测试

### 注意事项

Hook 钩子脚本需要 CR+LF 换行，否则 CMD 会执行出错。

### 网络版

1. MTP、Rndis 功能
2. 网络共享
3. mtsc 远程桌面

### 维护版

1. 引导修复工具

## WinPE 排错指南

### 360Chrome 没有声音

将 SOFTWARE 注册表权限改为 everyone

```
[HKEY_LOCAL_MACHINE\Tmp_SOFTWARE\Policies\Google\Chrome]
"AudioSandboxEnabled"=dword:00000000
```

### 脚本排查指南

- 如提示 `cd "X:\Program Files\Edgeless" 命令语法不正确。`，请检查自定义 WinPE 配置相关代码

## 壁纸

[壁纸](https://wallhaven.cc/search?q=like%3A6dzwm7&page=5)

## 内置驱动

- KVM: (KVM 虚拟机所需驱动)[https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/]
- Intel 11-13 代 CPU 磁盘驱动[https://www.intel.com/content/www/us/en/download/720755/intel-rapid-storage-technology-driver-installation-software-with-intel-optane-memory-11th-up-to-13th-gen-platforms.html?]
  提取驱动：`SetupRST.exe -extractdrivers SetupRST_extracted`

## 内置软件

- [PECMD](https://www.lanzoui.com/b279972)

- [StartAllBack](https://www.123pan.com/s/jKNSVv-Woutv.html)

- [StartAllBack(破解)](https://rutracker.net/forum/tracker.php?nm=startallback)

- [WinXShell](https://www.lanzoux.com/b011xhbsh) 密码: shell

- [7-Zip-zstd](https://github.com/mcmilk/7-Zip-zstd/releases)

- [Notepad4](https://github.com/zufuliu/notepad4/releases)

- [Vtoydump](https://github.com/ventoy/vtoydump)（`bin`目录内有成品）

- [HashTab （右键属性校验）](http://implbits.com/products/hashtab/)

- [OpenWith Enhanced（打开方式）](http://extensions.frieger.com/owdesc.php)

- [ScreenCapture (截图工具)](https://github.com/xland/ScreenCapture)

## 外置软件

### 备份还原

- [DISM++](http://www.chuyu.me/zh-Hans)

- [WinNTSetup](https://www.423down.com/2478.html)

- [CGI](http://bbs.wuyou.net/forum.php?mod=viewthread&tid=429508)

### 磁盘工具

- [DiskGenius](https://www.diskgenius.cn/download.php)（单文件版位于下方）

- [分区助手](https://www.disktool.cn/download.html)

> 提示：分区助手在WinPE下会修改分辨率（开发者执意不予修复），通过修改 `ChangeDisplaySettingsW`=>`ChangeDisplaySettingsA`可实现屏蔽修改分辨率

- [WinHex](https://www.423down.com/995.html)

### 网络工具

- [迅雷](https://kkocdko.github.io/post/201907240022)（需要增加 ThunderS_RuntimePatch 运行库）

### 文件工具

- [Everything](https://www.voidtools.com/zh-cn)

- [7-Data](https://www.ghpym.com/7datarecovery.html)

### 硬件检测

- [CPU-Z](https://www.cpuid.com/softwares/cpu-z.html)

- [Aida64](https://www.423down.com/887.html)

- [CrystalDiskInfo](https://www.423down.com/5432.html)

## 移植 Edgeless 组件

将`7-Zip_x64\7z.exe`替换为`7-Zip\7z.exe`

### Ept

1. `\Edgeless\Resource\`替换为`\FirPE\Resource\`
2. 将判断 `\Edgeless\version.txt` 改为判断 `\FirPE`
3. aria2c 调用时加入 `--check-certificate=false`

## Windows 2003 PE

温馨提醒：PECMD.ini 配置文件不用优化，不知道什么原因优化之后会影响智能 ABC 输入法卡系统

### 更新驱动

1. 替换 USBOS PE: nt5.wim\WXPE\System32\drivers
2. 替换 USBOS PE: nt5.wim\WXPE\TXTSETUP.sif
3. 补充 TXTSETUP.sif 支持双核

## ISO 外壳

### EFI

（可以直接使用 USM 的 EFI 文件）

- \efi\boot\bootx64.efi
  提取 \Windows\Boot\EFI\bootmgfw.efi，并改名为 bootx64.efi

- \efi\boot\zh-CN\bootx64.efi.mui
  提取 \Windows\Boot\EFI\zh-CN\bootmgfw.efi.mui，并改名为 bootx64.efi.mui
