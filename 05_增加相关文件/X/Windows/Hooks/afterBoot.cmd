rem WinPE初始化之后

@echo off
setlocal enabledelayedexpansion
set "PATH=%~dp0;%PATH%"
call common setWinPEDrive

if exist "!ConfigPath!" (
  call common readini !ConfigPath! "应用程序" "自动理顺盘符"
  if !value!==1 (
    call common Log "WinPE初始化" "正在理顺盘符"
    start /wait "" "%ProgramFiles%\Others\orderdrv.exe"
    call common setWinPEDrive
  )

  call common readini !ConfigPath! "系统" "隐藏WinPE系统盘"
  if !value!==1 (
    call common Log "WinPE初始化" "正在隐藏WinPE系统盘"
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoDrives" /t REG_DWORD /d "8388608" /f
  )

  call common readini !ConfigPath! "系统" "电源计划" ""
  if "!value!"=="节能" (
    call common Log "WinPE初始化" "正在设置电源计划: 节能"
    powercfg.exe /S a1841308-3541-4fab-bc81-f71556f20b4a
  )
  if "!value!"=="平衡" (
    call common Log "WinPE初始化" "正在设置电源计划: 平衡"
    powercfg.exe /S 381b4222-f694-41f0-9685-ff5bb260df2e
  )
  if "!value!"=="高性能" (
    call common Log "WinPE初始化" "正在设置电源计划: 高性能"
    powercfg.exe /S 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
  )

  call common readini !ConfigPath! "系统" "自动关闭屏幕时间" ""
  if not "!value!"=="" (
    call common Log "WinPE初始化" "正在设置关闭屏幕时间: !value!"
    powercfg.exe /X /monitor-timeout-ac !value!
    powercfg.exe /X /monitor-timeout-dc !value!
  )

  call common readini !ConfigPath! "系统" "开启小键盘"
  if !value!==1 (
    call common Log "WinPE初始化" "正在开启小键盘"
    PECMD NUMK 1
  )
)

rem 加载自定义驱动
dir /a /b "%USBDrive%\Drivers"|findstr .>nul 2>nul &&(
  call common Log "WinPE初始化" "正在加载自定义驱动"
  call common Tips WinPE初始化 正在加载自定义驱动 5000
  for /r "%USBDrive%\Drivers" %%i in (*.*) do (
    call common Log "WinPE初始化" "正在安装驱动: %%~nxi"
    DriverIndexer.exe --log %SystemRoot%\Logs\DriverIndexer.log install "%%i" -m
  )
)

rem 补充Windows文件夹内容 
if defined USBDrive if exist "%USBDrive%\Windows" (
  call common Log "WinPE初始化" "正在补充Windows文件夹内容"
  if exist "%USBDrive%\Windows\SystemResources\imageres.dll.mun" (
    call common Log "WinPE初始化" "正在替换图标文件"
    takeown /f %Systemroot%\SystemResources\imageres.dll.mun
    icacls %Systemroot%\SystemResources\imageres.dll.mun /grant administrators:F
    rename %Systemroot%\SystemResources\imageres.dll.mun imageres.dll.mun.bak
  )
  xcopy /s /r /y "%USBDrive%\Windows\*" "X:\Windows\*"
)

rem 自定义字体
if defined USBDrive if exist "%USBDrive%\Fonts" (
  call common Log "WinPE初始化" "正在增加自定义字体"
  copy /y "%USBDrive%\Fonts\*.ttf" "%SystemRoot%\Fonts"
  copy /y "%USBDrive%\Fonts\*.ttc" "%SystemRoot%\Fonts"
  copy /y "%USBDrive%\Fonts\*.fon" "%SystemRoot%\Fonts"
  PECMD FONT "%SystemRoot%\Fonts"
  rem 修复字体渲染模糊
  PECMD call $gdi32.dll,EnableEUDC
)

rem 自定义LOGO
if defined USBDrive if exist "%USBDrive%\LOGO.bmp" (
  call common Log "WinPE初始化" "正在设置自定义LOGO"
  copy /y "%USBDrive%\LOGO.bmp" "%SystemRoot%\Web\Wallpaper\Windows\LOGO.bmp"
  reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation /v Logo /t REG_SZ /d "%SystemRoot%\Web\Wallpaper\Windows\LOGO.bmp" /f
  copy /y "%USBDrive%\LOGO.bmp" "%ProgramData%\Microsoft\User Account Pictures\user-200.bmp"
  Reg add "HKCU\Software\StartIsBack" /v "HideUserFrame" /t REG_DWORD /d "0" /f
)

if defined CustomHooks if exist "%CustomHooks%\%~nx0" call %CustomHooks%\%~nx0
call common log 系统钩子模块结束 阶段：%~n0%
