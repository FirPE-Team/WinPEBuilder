rem WindowsPE 初始化之前

@echo off
setlocal enabledelayedexpansion
set "PATH=%~dp0;%PATH%"
call common setWinPEDrive

rem 自定义壁纸
if defined USBDrive (
  set "wallpaper="

  if exist "%USBDrive%\wp.jpg" set "wallpaper=%USBDrive%\wp.jpg"
  if not defined wallpaper if exist "%USBDrive%\wp.png" (
    ren "%USBDrive%\wp.png" "wp.jpg"
    set "wallpaper=%USBDrive%\wp.jpg"
  )
  if not defined wallpaper if exist "%USBDrive%\wp.bmp" (
    ren "%USBDrive%\wp.bmp" "wp.jpg"
    set "wallpaper=%USBDrive%\wp.jpg"
  )

  if defined wallpaper (
    call common Log "WinPE初始化" "正在设置自定义壁纸"
    rem 替换壁纸
    copy /y "%wallpaper%" "%SystemRoot%\Web\Wallpaper\Windows\img0.jpg"
  )

  set "darkpaper="
  if exist "%USBDrive%\dark.jpg" set "darkpaper=%USBDrive%\dark.jpg"
  if not defined darkpaper if exist "%USBDrive%\dark.png" (
    ren "%USBDrive%\dark.png" "dark.jpg"
    set "darkpaper=%USBDrive%\dark.jpg"
  )
  if not defined darkpaper if exist "%USBDrive%\dark.bmp" (
    ren "%USBDrive%\dark.bmp" "dark.jpg"
    set "darkpaper=%USBDrive%\dark.jpg"
  )

  if defined darkpaper (
    call common Log "WinPE初始化" "正在设置暗色壁纸"
    copy /y "%darkpaper%" "%SystemRoot%\Web\Wallpaper\Windows\img0_dark.jpg"
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
