rem WindowsPE进入桌面之前

@echo off
setlocal enabledelayedexpansion
set "PATH=%~dp0;%PATH%"
call common setWinPEDrive

dir /a /b "%USBDrive%\Default"|findstr .>nul 2>nul &&(
  rem 应用系统图标资源包（ess）
  PECMD EXEC^!"%ProgramFiles%\Edgeless\theme_processer\setTheme.cmd" autoESS
  rem 应用默认主题资源（除了ess，ess在上面被应用）
  PECMD EXEC^!"%ProgramFiles%\Edgeless\theme_processer\setTheme.cmd" auto
  rem 显示自定义鼠标样式提示
  if exist "X:\Users\RunMSTip" (
    PECMD LOAD "%WinDir%\System32\0tipMS.wcs"
    rd /s /q "X:\Users\RunMSTip"
  )
)

if exist "!ConfigPath!" (
  call common readini !ConfigPath! "系统" "登录密码"
  if not "!value!"=="" (
    (
      echo {
      echo   "name":"UI_Logon",
      echo   "title":"wxsLogon",
      echo   "nobaricon":true,
      echo   "customstyle":true,
      echo   "style":2415919104,
      echo   "startup_win":"max",
      echo   "OnEscKey":"none",
      echo   "==========":"==========",
      echo   "shadow":"Administrator:;\\nSYSTEM:!value!;",
      echo   "logon_user":"SYSTEM",
      echo   "auto_logon_second":0
      echo }
    ) > "%temp%\UI_LogonPE.jcfg"
    PECMD LOGO
    start /wait "" "%ProgramFiles%\WinXShell\WinXShell.exe" -ui -jcfg "%temp%\UI_LogonPE.jcfg"
  )

  call common readini !ConfigPath! "系统" "计算机名称"
  if not "!value!"=="" (
    reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName" /v "ComputerName" /t REG_SZ /d "!value!" /f
    reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\ComputerName\ActiveComputerName" /v "ComputerName" /t REG_SZ /d "!value!" /f
    reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "Hostname" /t REG_SZ /d "!value!" /f
    reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "NV Hostname" /t REG_SZ /d "!value!" /f
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "AltDefaultDomainName" /t REG_SZ /d "!value!" /f
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "DefaultDomainName" /t REG_SZ /d "!value!" /f
    net stop WlanSvc>nul
    net stop Wcmsvc>nul
    net start Wcmsvc>nul
    net start WlanSvc>nul
  )

  call common readini !ConfigPath! "系统" "制造商"
  if not "!value!"=="" (
    reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation /v Manufacturer /t REG_SZ /d "!value!" /f
  )

  call common readini !ConfigPath! "系统" "型号"
  if not "!value!"=="" (
    reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation /v Model /t REG_SZ /d "!value!" /f
  )

  call common readini !ConfigPath! "系统" "网站"
  if not "!value!"=="" (
    reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation /v SupportURL /t REG_SZ /d "!value!" /f
  )
  
  call common readini !ConfigPath! "系统" "保留数据目录"
  if !value!==1 (
    call common Log "WinPE初始化" "正在重定向数据目录"

    if not exist %USBDrive%\Users md %USBDrive%\Users

    if not exist %USBDrive%\Users\Desktop (
      md %USBDrive%\Users\Desktop
      xcopy /C /S /I "%USERPROFILE%\Desktop" "%USBDrive%\Users\Desktop"
    )
    rd /s /q %USERPROFILE%\desktop
    mklink /D %USERPROFILE%\desktop %USBDrive%\Users\Desktop

    if not exist %USBDrive%\Users\AppData (
      md %USBDrive%\Users\AppData
      xcopy /C /S /I /H "%USERPROFILE%\AppData\Roaming" "%USBDrive%\Users\AppData\Roaming"
    )
    rd /s /q %USERPROFILE%\AppData\Roaming
    mklink /D %USERPROFILE%\AppData\Roaming %USBDrive%\Users\AppData\Roaming
    
    md %USBDrive%\Users\Documents
    rd /s /q %USERPROFILE%\Documents
    mklink /D %USERPROFILE%\Documents %USBDrive%\Users\Documents

    md %USBDrive%\Users\Pictures
    rd /s /q %USERPROFILE%\Pictures
    mklink /D %USERPROFILE%\Pictures %USBDrive%\Users\Pictures

    md %USBDrive%\Users\Music
    rd /s /q %USERPROFILE%\Music
    mklink /D %USERPROFILE%\Music %USBDrive%\Users\Music

    md %USBDrive%\Users\Videos
    rd /s /q %USERPROFILE%\Videos
    mklink /D %USERPROFILE%\Videos %USBDrive%\Users\Videos
  )
  
  call common readini !ConfigPath! "系统" "禁用提高指针精确度"
  if !value!==1 (
    reg add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "0" /f
    reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d "0" /f
    reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d "0" /f
  )

  call common readini !ConfigPath! "外观和个性化" "自动切换夜间模式"
  if !value!==1 (
    if %time:~0,2% GEQ 18 call %SystemRoot%\System32\SwitchTheme.cmd
    if %time:~0,2% LEQ 07 call %SystemRoot%\System32\SwitchTheme.cmd
  )
  
  call common readini !ConfigPath! "外观和个性化" "默认夜间模式"
  if !value!==1 (
    call %SystemRoot%\System32\SwitchTheme.cmd
  )

  call common readini !ConfigPath! "外观和个性化" "桌面取消自动对齐"
  if !value!==1 (
    Reg add "HKCU\Software\Microsoft\Windows\Shell\Bags\1\Desktop" /v "FFlags" /t REG_DWORD /d "1075839524" /f
  )

  call common readini !ConfigPath! "外观和个性化" "资源管理器显示文件复选框"
  if !value!==1 (
    Reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "AutoCheckSelect" /t REG_DWORD /d "1" /f
  )

  call common readini !ConfigPath! "外观和个性化" "资源管理器隐藏文件扩展名"
  if !value!==1 (
    Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d "1" /f
  )

  call common readini !ConfigPath! "外观和个性化" "资源管理器取消显示隐藏文件"
  if !value!==1 (
    Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t REG_DWORD /d "0" /f
    Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSuperHidden" /t REG_DWORD /d "0" /f
  )

  call common readini !ConfigPath! "外观和个性化" "资源管理器显示中等图标"
  if !value!==1 (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Streams" /v "Settings" /t REG_BINARY /d "080000000100000001000000e0d057007335cf11ae6908002b2e1262040000000100000043000000" /f
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Streams\Defaults" /v "{5C4F28B5-F869-4E84-8E60-F11DB97C5CC7}" /t REG_BINARY /d "1c000000000000000000000000000000000000000000000000000000f1f1f1f114000000000000000000000000000000d0020000cc0200003153505305d5cdd59c2e1b10939708002b2cf9ae830000002200000000470072006f0075007000420079004b00650079003a0046004d005400490044000000080000004e0000007b00300030003000300030003000300030002d0030003000300030002d0030003000300030002d0030003000300030002d003000300030003000300030003000300030003000300030007d0000000000330000002200000000470072006f00750070004200790044006900720065006300740069006f006e00000013000000010000005b0000000a0000000053006f00720074000000420000001e000000700072006f0070003400320039003400390036003700320039003500000000001c0000000100000030f125b7ef471a10a5f102608c9eebac0a00000001000000250000001400000000470072006f0075007000560069006500770000000b000000000000001b0000000a000000004d006f006400650000001300000001000000230000001200000000490063006f006e00530069007a00650000001300000030000000bd000000100000000043006f006c0049006e0066006f000000420000001e000000700072006f00700034003200390034003900360037003200390035000000000078000000fddfdffd100000000000000000000000040000001800000030f125b7ef471a10a5f102608c9eebac0a0000001001000030f125b7ef471a10a5f102608c9eebac0e0000007800000030f125b7ef471a10a5f102608c9eebac040000007800000030f125b7ef471a10a5f102608c9eebac0c000000500000002f0000001e00000000470072006f0075007000420079004b00650079003a00500049004400000013000000000000001f0000000e00000000460046006c00610067007300000013000000010020413100000020000000004c006f0067006900630061006c0056006900650077004d006f0064006500000013000000030000000000000000000000" /f
  )

  call common readini !ConfigPath! "外观和个性化" "资源管理器行间距紧凑模式"
  if !value!==1 (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "UseCompactMode" /t REG_DWORD /d "1" /f
  )

  call common readini !ConfigPath! "外观和个性化" "开始菜单默认选择关机"
  if !value!==1 (
    reg add "HKCU\Software\StartIsBack\ShutdownChoices" /v "关机" /t REG_DWORD /d "2" /f
    reg add "HKU\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_PowerButtonAction" /t REG_DWORD /d "2" /f
  )

  call common readini !ConfigPath! "外观和个性化" "开始菜单居左"
  if !value!==1 (
    Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAl" /t REG_DWORD /d "0" /f
  )

  call common readini !ConfigPath! "外观和个性化" "任务栏大小" ""
  if "!value!"=="小" (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarSi" /t REG_DWORD /d "0" /f
  )
  if "!value!"=="中" (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarSi" /t REG_DWORD /d "1" /f
  )
  if "!value!"=="大" (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarSi" /t REG_DWORD /d "2" /f
  )

  call common readini !ConfigPath! "外观和个性化" "任务栏取消合并"
  if !value!==1 (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarGlomLevel" /t REG_DWORD /d "2" /f
  )

  call common readini !ConfigPath! "外观和个性化" "任务栏图标居左"
  if !value!==1 (
    reg add "HKCU\Software\StartIsBack" /v "TaskbarCenterIcons" /t REG_DWORD /d "0" /f
  )
  
  call common readini !ConfigPath! "外观和个性化" "任务栏托盘图标边距"
  if "!value!"=="小" (
    reg add "HKCU\Software\StartIsBack" /v "SysTraySpacierIcons" /t REG_DWORD /d "4294967295" /f
  )
  if "!value!"=="中" (
    reg add "HKCU\Software\StartIsBack" /v "SysTraySpacierIcons" /t REG_DWORD /d "0" /f
  )
  if "!value!"=="大" (
    reg add "HKCU\Software\StartIsBack" /v "SysTraySpacierIcons" /t REG_DWORD /d "1" /f
  )
 
  call common readini !ConfigPath! "外观和个性化" "任务栏隐藏通知区域图标"
  if !value!==1 (
    Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "EnableAutoTray" /t REG_DWORD /d "1" /f
  )
)

if defined CustomHooks if exist "%CustomHooks%\%~nx0" call %CustomHooks%\%~nx0
call common log 系统钩子模块结束 阶段：%~n0%
