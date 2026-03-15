rem WindowsPE 初始化之前

@echo off
setlocal enabledelayedexpansion
set "PATH=%~dp0;%PATH%"
call common setWinPEDrive

rem 自定义壁纸
if defined USBDrive (
  set "wallpaper="

  if exist "%USBDrive%\wp.jpg" set "wallpaper=%USBDrive%\wp.jpg"
  if not defined wallpaper if exist "%USBDrive%\wp.png" set "wallpaper=%USBDrive%\wp.png"
  if not defined wallpaper if exist "%USBDrive%\wp.bmp" set "wallpaper=%USBDrive%\wp.bmp"

  if defined wallpaper (
    call common Log "WinPE初始化" "正在设置自定义壁纸: !wallpaper!"
    copy /y "!wallpaper!" "%SystemRoot%\Web\Wallpaper\Windows\img0.jpg"
  )

  set "darkwallpaper="
  if exist "%USBDrive%\dark.jpg" set "darkwallpaper=%USBDrive%\dark.jpg"
  if not defined darkwallpaper if exist "%USBDrive%\dark.png" set "darkwallpaper=%USBDrive%\dark.png"
  if not defined darkwallpaper if exist "%USBDrive%\dark.bmp" set "darkwallpaper=%USBDrive%\dark.bmp"

  if defined darkwallpaper (
    call common Log "WinPE初始化" "正在设置自定义暗色壁纸: !darkwallpaper!"
    copy /y "!darkwallpaper!" "%SystemRoot%\Web\Wallpaper\Windows\img0_dark.jpg"
  )
)

if exist "!ConfigPath!" (
  call common readini !ConfigPath! "外观和个性化" "分辨率" ""
  if not "!value!"=="" (
    call common Log "WinPE初始化" "正在设置分辨率: !value!"
    for /f "tokens=1,* delims=*, " %%m in ("!value!") do PECMD DISP W%%m H%%n
  )

  call common readini !ConfigPath! "系统" "禁用网络"
  if !value!==1 (
    call common Log "WinPE初始化" "正在禁用网络"
    rd /q /s "%SystemRoot%\L2Schemas"
    del /A /F /Q "%SystemRoot%\System32\netsetupsvc.dll"
    del /A /F /Q "%SystemRoot%\System32\rasphone.pbk"

    rd /q /s "%ProgramFiles%\PENetwork"
    rd /q /s "%ProgramFiles(x86)%\网络工具"
    rd /q /s "%ProgramFiles%\Edgeless\EasyDown"
    rd /q /s "%ProgramFiles%\Edgeless\plugin_ept"
    del /A /F /Q "%ProgramFiles%\WinXShell\wxsUI\UI_WIFI.zip"
  )

  call common readini !ConfigPath! "系统" "默认亮度" ""
  if not "!value!"=="" (
    call common Log "WinPE初始化" "正在设置默认亮度: !value!"
    start "" "%ProgramFiles%\WinXShell\WinXShell.exe" -regist -daemon
    timeout /t 2 /nobreak >nul
    start "" "%ProgramFiles%\WinXShell\WinXShell.exe" -code "Screen:Set('brightness', !value!^)"
  )

  call common readini !ConfigPath! "系统" "默认音量" ""
  if not "!value!"=="" (
    call common Log "WinPE初始化" "正在设置默认音量: !value!"
    start "" "%ProgramFiles%\WinXShell\WinXShell.exe" -code app:call('Volume::SetLevel',!value!^)
  )
)

if defined CustomHooks if exist "%CustomHooks%\%~nx0" call %CustomHooks%\%~nx0
call common log 系统钩子模块结束 阶段：%~n0%
