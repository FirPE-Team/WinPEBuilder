@echo off

for /f "tokens=2*" %%i in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "AppsUseLightTheme"') do (set ault=%%j)
if %ault%==0x1 (
	set StartIsBack=0
	set Theme=dark
	set img=img0_dark.jpg
) else (
	set StartIsBack=16777215
	set Theme=light
	set img=img0.jpg
)

reg add "HKCU\Software\StartIsBack" /v "StartMenuColor" /t REG_DWORD /d "%StartIsBack%" /f
reg add "HKCU\Software\StartIsBack" /v "TaskbarColor" /t REG_DWORD /d "%StartIsBack%" /f
"%ProgramFiles%\WinXShell\WinXShell.exe" -code System:SysColorTheme('%Theme%')
"%ProgramFiles%\WinXShell\WinXShell.exe" -code System:AppsColorTheme('%Theme%')
PECMD WALL %SystemRoot%\Web\Wallpaper\Windows\%img%
goto :eof
