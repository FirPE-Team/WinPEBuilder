rem WindowsPE 初始化之前

@echo off
setlocal enabledelayedexpansion
set "PATH=%~dp0;%PATH%"

call common setWinPEDrive
if defined CustomHooks if exist "%CustomHooks%\%~nx0" call %CustomHooks%\%~nx0

rem 自定义壁纸
if defined USBDrive if exist "%USBDrive%\wp.jpg" (
  call common Log "WinPE初始化" "正在设置自定义壁纸"
  rem 容错设置
  if exist "%USBDrive%\wp.jpg.jpg" ren "%USBDrive%\wp.jpg.jpg" "wp.jpg"
  rem 替换壁纸
  copy /y "%USBDrive%\wp.jpg" "%SystemRoot%\Web\Wallpaper\Windows\img0.jpg"
)
if defined USBDrive if exist "%USBDrive%\dark.jpg" (
  call common Log "WinPE初始化" "正在设置自定义暗色壁纸"
  rem 容错设置
  if exist "%USBDrive%\dark.jpg.jpg" ren "%USBDrive%\dark.jpg.jpg" "dark.jpg"
  rem 替换壁纸
  copy /y "%USBDrive%\dark.jpg" "%SystemRoot%\Web\Wallpaper\Windows\img0_dark.jpg"
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

call common log 系统钩子模块结束 阶段：%~n0%
