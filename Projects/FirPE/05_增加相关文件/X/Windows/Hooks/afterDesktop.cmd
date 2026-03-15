rem WindowsPE进入桌面之后

@echo off
setlocal enabledelayedexpansion
set "PATH=%~dp0;%PATH%"
call common setWinPEDrive
setx Path "%Path%;%ProgramFiles%\Edgeless\plugin_ept"

rem 变更WCS、WCZ文件图标
Reg add "HKCR\wcsfile\DefaultIcon" /ve /t REG_SZ /d "X:\Users\Icon\type\wcs.ico" /f >nul
Reg add "HKCR\wczfile\DefaultIcon" /ve /t REG_SZ /d "X:\Users\Icon\type\wcs.ico" /f >nul

rem 关联 7ZF 文件
Reg add "HKCR\.7zf" /ve /t REG_SZ /d "Edgeless.7zf" /f >nul
Reg add "HKCR\Edgeless.7zf" /ve /t REG_SZ /d "Edgeless 插件包资源文件" /f >nul
Reg add "HKCR\Edgeless.7zf\DefaultIcon" /ve /t REG_SZ /d "X:\Users\Icon\type\plugin.ico" /f >nul
Reg add "HKCR\Edgeless.7zf\shell" /ve /t REG_SZ /d "" /f >nul
Reg add "HKCR\Edgeless.7zf\shell\open" /ve /t REG_SZ /d "" /f >nul
Reg add "HKCR\Edgeless.7zf\shell\open\command" /ve /t REG_SZ /d "X:\Windows\system32\pecmd exec ^!X:\Program Files\Edgeless\plugin_loader\process7zf.cmd \"%%1\"" /f >nul

rem  注册7z右键加载Edgeless插件
Reg add "HKCR\7-Zip.7z\shell\LoadAsPlugin" /ve /t REG_SZ /d "作为插件包加载" /f >nul
Reg add "HKCR\7-Zip.7z\shell\LoadAsPlugin" /v "Icon" /t REG_SZ /d "X:\Users\Icon\type\plugin.ico" /f >nul
Reg add "HKCR\7-Zip.7z\shell\LoadAsPlugin\command" /ve /t REG_SZ /d "X:\Windows\system32\pecmd exec ^!\"X:\Program Files\Edgeless\plugin_loader\process7zf.cmd\" \"%%1\"" /f >nul
Reg add "HKCR\7-Zip.7z\shell\LoadAsPlugin\DefaultIcon" /ve /t REG_SZ /d "X:\Users\Icon\type\plugin.ico" /f >nul

rem 关联 Edgeless Theme 相关文件
Reg add "HKCR\.eis" /ve /t REG_SZ /d "Edgeless.eis" /f >nul
Reg add "HKCR\Edgeless.eis" /ve /t REG_SZ /d "Edgeless 图标资源包" /f >nul
Reg add "HKCR\Edgeless.eis\DefaultIcon" /ve /t REG_SZ /d "X:\Users\Icon\type\eis.ico" /f >nul
Reg add "HKCR\Edgeless.eis\shell" /ve /t REG_SZ /d "" /f >nul
Reg add "HKCR\Edgeless.eis\shell\open" /ve /t REG_SZ /d "" /f >nul
Reg add "HKCR\Edgeless.eis\shell\open\command" /ve /t REG_SZ /d "X:\Windows\system32\pecmd exec ^!X:\Program Files\Edgeless\theme_processer\processTheme.cmd \"%%1\"" /f >nul

rem 关联 Edgeless LoadScreen 资源包
Reg add "HKCR\.els" /ve /t REG_SZ /d "Edgeless.els" /f >nul
Reg add "HKCR\Edgeless.els" /ve /t REG_SZ /d "Edgeless LoadScreen资源包" /f >nul
Reg add "HKCR\Edgeless.els\DefaultIcon" /ve /t REG_SZ /d "X:\Users\Icon\type\els.ico" /f >nul
Reg add "HKCR\Edgeless.els\shell" /ve /t REG_SZ /d "" /f >nul
Reg add "HKCR\Edgeless.els\shell\open" /ve /t REG_SZ /d "" /f >nul
Reg add "HKCR\Edgeless.els\shell\open\command" /ve /t REG_SZ /d "X:\Windows\system32\pecmd exec ^!X:\Program Files\Edgeless\theme_processer\processTheme.cmd \"%%1\"" /f >nul

rem 关联 Edgeless 鼠标样式资源包
Reg add "HKCR\.ems" /ve /t REG_SZ /d "Edgeless.ems" /f >nul
Reg add "HKCR\Edgeless.ems" /ve /t REG_SZ /d "Edgeless 鼠标样式资源包" /f >nul
Reg add "HKCR\Edgeless.ems\DefaultIcon" /ve /t REG_SZ /d "X:\Users\Icon\type\ems.ico" /f >nul
Reg add "HKCR\Edgeless.ems\shell" /ve /t REG_SZ /d "" /f >nul
Reg add "HKCR\Edgeless.ems\shell\open" /ve /t REG_SZ /d "" /f >nul
Reg add "HKCR\Edgeless.ems\shell\open\command" /ve /t REG_SZ /d "X:\Windows\system32\pecmd exec ^!X:\Program Files\Edgeless\theme_processer\processTheme.cmd \"%%1\"" /f >nul

rem 关联 Edgeless 开始菜单样式资源文件
Reg add "HKCR\.esc" /ve /t REG_SZ /d "Edgeless.esc" /f >nul
Reg add "HKCR\Edgeless.esc" /ve /t REG_SZ /d "Edgeless 开始菜单样式资源文件" /f >nul
Reg add "HKCR\Edgeless.esc\DefaultIcon" /ve /t REG_SZ /d "X:\Users\Icon\type\esc.ico" /f >nul
Reg add "HKCR\Edgeless.esc\shell" /ve /t REG_SZ /d "" /f >nul
Reg add "HKCR\Edgeless.esc\shell\open" /ve /t REG_SZ /d "" /f >nul
Reg add "HKCR\Edgeless.esc\shell\open\command" /ve /t REG_SZ /d "X:\Windows\system32\pecmd exec ^!X:\Program Files\Edgeless\theme_processer\processTheme.cmd \"%%1\"" /f >nul

rem 关联 Edgeless 系统图标资源包
Reg add "HKCR\.ess" /ve /t REG_SZ /d "Edgeless.ess" /f >nul
Reg add "HKCR\Edgeless.ess" /ve /t REG_SZ /d "Edgeless 系统图标资源包" /f >nul
Reg add "HKCR\Edgeless.ess\DefaultIcon" /ve /t REG_SZ /d "X:\Users\Icon\type\ess.ico" /f >nul
Reg add "HKCR\Edgeless.ess\shell" /ve /t REG_SZ /d "" /f >nul
Reg add "HKCR\Edgeless.ess\shell\open" /ve /t REG_SZ /d "" /f >nul
Reg add "HKCR\Edgeless.ess\shell\open\command" /ve /t REG_SZ /d "X:\Windows\system32\pecmd exec ^!X:\Program Files\Edgeless\theme_processer\processTheme.cmd \"%%1\"" /f >nul

rem 关联 Edgeless 主题包
Reg add "HKCR\.eth" /ve /t REG_SZ /d "Edgeless.eth" /f >nul
Reg add "HKCR\Edgeless.eth" /ve /t REG_SZ /d "Edgeless 主题包" /f >nul
Reg add "HKCR\Edgeless.eth\DefaultIcon" /ve /t REG_SZ /d "X:\Users\Icon\type\eth.ico" /f >nul
Reg add "HKCR\Edgeless.eth\shell" /ve /t REG_SZ /d "" /f >nul
Reg add "HKCR\Edgeless.eth\shell\open" /ve /t REG_SZ /d "" /f >nul
Reg add "HKCR\Edgeless.eth\shell\open\command" /ve /t REG_SZ /d "X:\Windows\system32\pecmd exec ^!X:\Program Files\Edgeless\theme_processer\processTheme.cmd \"%%1\"" /f >nul

rem 关联 HPM 文件
Reg add "HKCR\.hpm" /ve /t REG_SZ /d "HotPEModule.hpm" /f >nul
Reg add "HKCR\HotPEModule.hpm" /ve /t REG_SZ /d "HotPE Module" /f >nul
Reg add "HKCR\HotPEModule.hpm\DefaultIcon" /ve /t REG_SZ /d "%ProgramFiles%\HotPEModule\hpm_cli.exe" /f >nul
Reg add "HKCR\HotPEModule.hpm\shell" /ve /t REG_SZ /d "" /f >nul
Reg add "HKCR\HotPEModule.hpm\shell\open" /ve /t REG_SZ /d "" /f >nul
Reg add "HKCR\HotPEModule.hpm\shell\open\command" /ve /t REG_SZ /d "%ProgramFiles%\HotPEModule\hpm_cli.exe -i \"%%1\"" /f >nul

if exist "!ConfigPath!" (
  call common readini !ConfigPath! "外观和个性化" "开机温馨提示" ""
  if not "!value!"=="" (
    call common tips 温馨提示 !value! 3000
  )

  call common readini !ConfigPath! "外观和个性化" "桌面图标大小" ""
  rem 此项在进入桌面后会自动修改默认值，目前WinXShell有效
  if "!value!"=="小" (
    reg add "HKCU\Software\Microsoft\Windows\Shell\Bags\1\Desktop" /v "IconSize" /t REG_DWORD /d "32" /f
    start "" "%ProgramFiles%\WinXShell\WinXShell.exe" -code Desktop:SetIconSize('S'^)
  )
  if "!value!"=="中" (
    reg add "HKCU\Software\Microsoft\Windows\Shell\Bags\1\Desktop" /v "IconSize" /t REG_DWORD /d "48" /f
    start "" "%ProgramFiles%\WinXShell\WinXShell.exe" -code Desktop:SetIconSize('M'^)
  )
  if "!value!"=="大" (
    reg add "HKCU\Software\Microsoft\Windows\Shell\Bags\1\Desktop" /v "IconSize" /t REG_DWORD /d "96" /f
    start "" "%ProgramFiles%\WinXShell\WinXShell.exe" -code Desktop:SetIconSize('L'^)
  )

  call common readini !ConfigPath! "网络和Internet" "IP" ""
  if not "!value!"=="" (
    PECMD PCIP !value!
  )

  call common readini !ConfigPath! "网络和Internet" "DNS" ""
  if not "!value!"=="" (
    PECMD PCIP -,-,-,!value!
  )

  call common readini !ConfigPath! "网络和Internet" "开启防火墙"
  if !value!==1 (
    wpeutil.exe EnableFirewall
  )

  call common readini !ConfigPath! "应用程序" "桌面显示硬件信息"
  if !value!==1 (
    start "" "%ProgramFiles(x86)%\硬件检测\DesktopInfo\DesktopInfo.exe"
  )

  call common readini !ConfigPath! "应用程序" "禁用Ghost"
  if !value!==1 (
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Ghost.exe" /v debugger /t reg_sz /d debugfile.exe /f
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Ghost32.exe" /v debugger /t reg_sz /d debugfile.exe /f
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Ghost64.exe" /v debugger /t reg_sz /d debugfile.exe /f
  )

  call common readini !ConfigPath! "系统" "自动加载本地网卡驱动"
  if !value!==1 (
    call common Log "WinPE初始化" "正在加载本地网卡驱动"
    DrvIndex.exe -net
  )

  call common readini !ConfigPath! "系统" "自动加载本地驱动"
  if !value!==1 (
    call common Log "WinPE初始化" "正在加载本地驱动"
    DrvIndex.exe -y -hide
  )

  call common readini !ConfigPath! "网络和Internet" "自动连接已保存网络"
  if !value!==1 (
    call common Log "WinPE初始化" "正在连接已保存网络"
    start "" PECMD.exe LOAD "%ProgramFiles(x86)%\网络工具\AutoWiFi\AutoWiFi.wcs"
  )

  rem 导入自定义WIFI信息
  for /l %%i in (1,1,5) do (
    call common readini !ConfigPath! "网络和Internet" "自定义WIFI%%i" ""
    if not "!value!"=="" (
      call common Log "WinPE初始化" "正在配置WIFI信息: !value!"
      PECMD ADSL-wlan -start !value!
    )
  )

  rem 自动连接文件共享 
  for /l %%i in (1,1,5) do (
    call common readini !ConfigPath! "网络和Internet" "自动文件共享%%i" ""
    if not "!value!"=="" ( 
      call common Log "WinPE初始化" "正在配置文件共享: !value!"
      for /f "tokens=1-3" %%a in ("!value!") do net use \\%%a "%%c" /user:%%b 
    )
  )

  rem ZeroTier
  call common readini !ConfigPath! "ZeroTier" "NetworkID" ""
  if not "!value!"=="" (
    if exist "%USBDrive%\ProgramData\ZeroTier\One" xcopy /s /r /y "%USBDrive%\ProgramData\ZeroTier\One\*" "%ALLUSERSPROFILE%\ZeroTier\One\*"
    net start ZeroTierOneService

    rem 等待 1 秒确保控制台 API 可用
    timeout /nobreak /t 1
    "%ALLUSERSPROFILE%\ZeroTier\One\zerotier-one_x64.exe" -q join !value!

    rem ZeroTier Moon
    call common readini !ConfigPath! "ZeroTier" "MoonID" ""
    if not "!value!"=="" (
      "%ALLUSERSPROFILE%\ZeroTier\One\zerotier-one_x64.exe" -q orbit !value! !value!
    )

    if not exist "%USBDrive%\ProgramData\ZeroTier\One\identity.secret" (
      mkdir "%USBDrive%\ProgramData\ZeroTier\One"
      copy /y "%ALLUSERSPROFILE%\ZeroTier\One\identity.public" "%USBDrive%\ProgramData\ZeroTier\One"
      copy /y "%ALLUSERSPROFILE%\ZeroTier\One\identity.secret" "%USBDrive%\ProgramData\ZeroTier\One"
      copy /y "%ALLUSERSPROFILE%\ZeroTier\One\authtoken.secret" "%USBDrive%\ProgramData\ZeroTier\One"
    )
  )
)

rem 显示系统盘图标
for %%d in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do if exist "%%d:\Windows\System32\cmd.exe" (
  reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\DriveIcons\%%d\DefaultIcon" /ve /t REG_SZ /d "imageres.dll,31" /f
)

rem 为System文件夹（放置系统镜像）创建桌面快捷方式
for %%d in (Z Y X W V U T S R Q P O N M L K J I H G F E D C) do if exist %%d:\System (
  dir /b /a-d "%%d:\System\*.wim" "%%d:\System\*.esd" "%%d:\System\*.iso" 2>nul | findstr /i "\.wim$ \.esd$ \.iso$" >nul
  if not errorlevel 1 (
    if not defined FLAG (
      call common Log "WinPE初始化" "正在创建系统镜像快捷方式"
      set FLAG=1
    )
      
    rem 创建带驱动器标识的快捷方式
    PECMD LINK "X:\Users\Default\Desktop\系统镜像_%%d","%%d:\System",,"X:\Users\Icon\shortcut\system.ico",0
  )
)

rem 补充自定义程序目录
if defined USBDrive if exist "%USBDrive%\Program Files" xcopy /s /r /y "%USBDrive%\Program Files\*" "X:\Program Files\*"
if defined USBDrive if exist "%USBDrive%\Program Files (x86)" xcopy /s /r /y "%USBDrive%\Program Files (x86)\*" "X:\Program Files (x86)\*"
if defined USBDrive if exist "%USBDrive%\Desktop" xcopy /s /r /y "%USBDrive%\Desktop\*" "%USERPROFILE%\Desktop\*"

rem 外置EasyRC配置文件
if defined USBDrive if exist "%USBDrive%\EasyRC.ini" copy /y "%USBDrive%\EasyRC.ini" "X:\Program Files (x86)\备份还原\EasyRC"

rem 开机自动运行程序
dir /a /b "%USBDrive%\Startup" | findstr . >nul 2>nul && (
  call common Log "WinPE初始化" "正在运行自定义程序"
  for %%a in ("%USBDrive%\Startup\*.lnk" "%USBDrive%\Startup\*.exe" "%USBDrive%\Startup\*.cmd" "%USBDrive%\Startup\*.bat") do (
    if /i not "%%~xa"==".lnk" copy /y "%%a" "%ProgramFiles%\%%~nxa" >nul
    start "" "%ProgramFiles%\%%~nxa"
  )
  for %%a in ("%USBDrive%\Startup\*.reg") do reg import "%%a"
)

rem 自定义工具
dir /a /b "%USBDrive%\Tools" | findstr /v /x /i "Tools.toml" | findstr . >nul 2>nul && (
  call common Log "WinPE初始化" "正在加载自定义工具"
  call common Tips "WinPE初始化" "正在加载自定义工具" 3000
  if exist "%USBDrive%\Tools\Tools.toml" set "ToolConfig=--config %USBDrive%\Tools\Tools.toml"
  rem 处理绿色软件、单文件软件
  AutoShortcut.exe -i "%USBDrive%\Tools" "%Desktop%" !ToolConfig! >>"%SystemRoot%\Logs\AutoShortcut.log"
  AutoShortcut.exe -d "%USBDrive%\Tools" "%Programs%" !ToolConfig! >>"%SystemRoot%\Logs\AutoShortcut.log"
  rem 处理软件包
  for %%i in ("%USBDrive%\Tools\*.7z" "%USBDrive%\Tools\*.zip" "%USBDrive%\Tools\*.rar" "%USBDrive%\Tools\*.wim") do (
    "%ProgramFiles%\7-Zip\7z.exe" x "%%i"  -y -aos -o"%ProgramFiles%\%%~ni"
    AutoShortcut.exe -i "%ProgramFiles%\%%~ni" "%Desktop%" !ToolConfig! >>"%SystemRoot%\Logs\AutoShortcut.log"
    AutoShortcut.exe -d "%ProgramFiles%\%%~ni" "%Programs%" !ToolConfig! >>"%SystemRoot%\Logs\AutoShortcut.log"
  )
  rem 刷新桌面
  PECMD ENVI @@DeskTopFresh=1
)

rem 加载Edgeless插件
dir /s /b "%USBDrive%\Resource\*.7z">nul 2>nul
if not errorlevel 1 (
  call common Log "WinPE初始化" "正在加载Edgeless插件"
  call common Tips "WinPE初始化" "正在加载Edgeless插件" 5000
  rem 创建安装程序目录
  md "%ProgramFiles%\Edgeless\安装程序"
  echo 本目录存放插件包的插件安装脚本 > "%ProgramFiles%\Edgeless\安装程序\说明.txt"
  echo 如需使用，请将其移到上级目录后运行 >> "%ProgramFiles%\Edgeless\安装程序\说明.txt"
  for /r "%USBDrive%\Resource" %%i in (*.7z) do (
    rem 解压插件包
    "%ProgramFiles%\7-Zip\7z.exe" x "%%i"  -y -aos -o"%ProgramFiles%\Edgeless"
    rem 运行cmd文件
    for /f "delims=" %%a in ('dir "%ProgramFiles%\Edgeless\*.cmd" /b') do (
      PECMD EXEC ^^!^^"%ProgramFiles%\Edgeless\%%a"
      PECMD wait 100
      move /y "%ProgramFiles%\Edgeless\*.cmd" "%ProgramFiles%\Edgeless\安装程序"
    )
    rem 运行wcs文件
    for /f "delims=" %%a in ('dir "%ProgramFiles%\Edgeless\*.wcs" /b') do (
      PECMD LOAD "%ProgramFiles%\Edgeless\%%a"
      PECMD wait 100
      move /y "%ProgramFiles%\Edgeless\*.wcs" "%ProgramFiles%\Edgeless\安装程序"
    )
  )
  call common Log "WinPE初始化" "完成Edgeless插件加载"
  rem 刷新桌面
  PECMD ENVI @@DeskTopFresh=1
)

rem 加载HotPEModule插件
dir /s /b "%USBDrive%\HotPEModule\*.hpm">nul 2>nul
if not errorlevel 1 (
  call common Log "WinPE初始化" "正在加载HPM插件"
  call common Tips "WinPE初始化" "正在加载HPM插件" 5000
  for /r "%USBDrive%\HotPEModule" %%i in (*.hpm) do (
    PECMD EXEC ^^!^^="%ProgramFiles%\HotPEModule\hpm_cli.exe" -i "%%i"
  )
  call common Log "WinPE初始化" "完成HPM插件加载"
  rem 刷新桌面
  PECMD ENVI @@DeskTopFresh=1
)

if defined CustomHooks if exist "%CustomHooks%\%~nx0" call %CustomHooks%\%~nx0
call common log 系统钩子模块结束 阶段：%~n0%
