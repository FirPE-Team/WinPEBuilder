rem FileExplorer In SeparateProcess
reg add "HKLM\Tmp_Default\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "SeparateProcess" /t REG_DWORD /d 1

rem hide the version watermark on Desktop
reg add "HKLM\Tmp_Default\Control Panel\Desktop" /v PaintDesktopVersion /t REG_DWORD /d 0 /f

rem NavPane Hide Libraries
reg add HKLM\Tmp_SOFTWARE\Classes\CLSID\{031E4825-7B94-4dc3-B131-E946B44C8DD5}\ShellFolder /v Attributes /t REG_DWORD /d 0xb090010d /f

rem Apply Theme Color for Taskbar
reg add HKLM\Tmp_Default\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize /v ColorPrevalence /t REG_DWORD /d 0 /f

rem show This PC on Desktop
reg add "HKLM\Tmp_Default\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v {20D04FE0-3AEA-1069-A2D8-08002B30309D} /t REG_DWORD /d 0 /f

rem hide Recycle Bin on Desktop
reg add "HKLM\Tmp_Default\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v {645FF040-5081-101B-9F08-00AA002F954E} /t REG_DWORD /d 1 /f

rem 桌面图标大小
reg add "HKLM\Tmp_Default\Software\Microsoft\Windows\Shell\Bags\1\Desktop" /v IconSize /t REG_DWORD /d 48 /f

rem 隐藏此电脑里的库文件夹
rem 隐藏“下载”
reg delete HKLM\Tmp_Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f} /f
rem 隐藏“图片”
reg delete HKLM\Tmp_Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8} /f
rem 隐藏“音乐”
reg delete HKLM\Tmp_Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de} /f
rem 隐藏“视频”
reg delete HKLM\Tmp_Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a} /f
rem 隐藏“3D对象”
reg delete HKLM\Tmp_Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A} /f
rem 隐藏“文档”
reg delete HKLM\Tmp_Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{d3162b92-9365-467a-956b-92703aca08af} /f
rem 隐藏“桌面”
rem reg delete HKLM\Tmp_Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641} /f

rem Wallpaper
call AddFiles "\Windows\Web\Wallpaper\Windows\img0.jpg"
reg add "HKLM\Tmp_Default\Control Panel\Desktop" /v Wallpaper /d X:\Windows\Web\Wallpaper\Windows\img0.jpg /f
reg add "HKLM\Tmp_Default\Software\Microsoft\Internet Explorer\Desktop\General" /v WallpaperSource /d X:\Windows\Web\Wallpaper\Windows\img0.jpg /f
reg add "HKLM\Tmp_Software\Microsoft\Windows NT\CurrentVersion\WinPE" /v CustomBackground /t REG_EXPAND_SZ /d X:\Windows\Web\Wallpaper\Windows\img0.jpg /f

rem 隐藏任务栏上的平板电脑输入工具
reg add "HKLM\Tmp_DEFAULT\Software\Microsoft\TabletTip\1.7" /v "TipbandDesiredVisibility" /t REG_DWORD /d "0" /f

REM 隐藏开始菜单启动文件夹
reg add "HKLM\Tmp_Software\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{B97D20BB-F46A-4C97-BA10-5E3608430854}" /v "Attributes" /t REG_DWORD /d "2" /f

rem 默认显示鼠标指针（或者运行winpeshl.exe显示鼠标指针）
reg add HKLM\Tmp_Software\Microsoft\Windows\CurrentVersion\Policies\System /v EnableCursorSuppression /t REG_DWORD /d 0 /f

rem Explorer 设置

rem 最小化功能区
reg add "HKLM\Tmp_DEFAULT\Software\Policies\Microsoft\Windows\Explorer" /v "ExplorerRibbonStartsMinimized" /t REG_DWORD /d "1" /f

rem 禁用创建快捷方式
reg delete "HKLM\Tmp_SOFTWARE\Classes\.lnk\ShellNew" /f

rem 使用Win7样式的托盘时钟、电池和音量调整（Win10早期版本 或 Win11安装StartAllback 后生效）
reg add "HKLM\Tmp_Software\Microsoft\Windows\CurrentVersion\ImmersiveShell" /f /v "UseWin32TrayClockExperience" /t REG_DWORD /d 1
reg add "HKLM\Tmp_Software\Microsoft\Windows\CurrentVersion\ImmersiveShell" /f /v "UseWin32BatteryFlyout" /t REG_DWORD /d 1
reg add "HKLM\Tmp_Software\Microsoft\Windows NT\CurrentVersion\MTCUVC" /f /v "EnableMTCUVC" /t REG_DWORD /d 0

rem 电源选项只显示关机和重启（仅SYSTEM账户需要）
reg add "HKLM\Tmp_Default\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /f /v "StartMenuLogOff" /t REG_DWORD /d 1
reg add "HKLM\Tmp_Default\Software\Microsoft\Windows\CurrentVersion\Policies\System" /f /v "DisableLockWorkstation" /t REG_DWORD /d 1
reg add "HKLM\Tmp_Default\Software\Microsoft\Windows\CurrentVersion\Policies\System" /f /v "HideFastUserSwitching" /t REG_DWORD /d 1
reg add "HKLM\Tmp_Software\Microsoft\Windows\CurrentVersion\Policies\System" /f /v "HideFastUserSwitching" /t REG_DWORD /d 1

rem 更改X盘的图标为系统盘图标`
reg add "HKLM\Tmp_Software\Microsoft\Windows\CurrentVersion\Explorer\DriveIcons\X\DefaultIcon" /f /ve /t REG_SZ /d "imageres.dll,31"

rem use cmd.exe on directorybackground than powershell.exe
call :SHOW_CMD_CONTEXTMENU Directory\background
call :SHOW_CMD_CONTEXTMENU Directory
call :SHOW_CMD_CONTEXTMENU Drive

rem // Shortcuts with 'shortcut' name and transparent icon
copy /y transparent.ico "%X_SYS%\"
reg add "HKLM\Tmp_Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 29 /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\transparent.ico" /f

rem Remove "Shortcut" suffix for new Shortcuts
reg add HKLM\Tmp_Default\Software\Microsoft\Windows\CurrentVersion\Explorer /v link /t REG_BINARY /d 00000000 /f

goto :EOF

:SHOW_CMD_CONTEXTMENU
reg delete HKLM\Tmp_Software\Classes\%1\shell\Powershell /v ShowBasedOnVelocityId /f
reg add HKLM\Tmp_Software\Classes\%1\shell\Powershell /v HideBasedOnVelocityId /t REG_DWORD /d 0x639bc8 /f
reg delete HKLM\Tmp_Software\Classes\%1\shell\cmd /v HideBasedOnVelocityId /f
reg add HKLM\Tmp_Software\Classes\%1\shell\cmd /v ShowBasedOnVelocityId /t REG_DWORD /d 0x639bc8 /f
rem add icon
reg add HKLM\Tmp_Software\Classes\%1\shell\cmd /v Icon /d cmd.exe /f
rem always show the menu item
rem reg delete HKLM\Tmp_Software\Classes\%1\shell\cmd /v Extended /f
goto :EOF
