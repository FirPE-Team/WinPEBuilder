rem 关机/重启之前

@echo off
setlocal enabledelayedexpansion
set "PATH=%~dp0;%PATH%"

call common setWinPEDrive
if defined CustomHooks if exist "%CustomHooks%\%~nx0" call %CustomHooks%\%~nx0
