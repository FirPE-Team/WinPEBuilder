@echo off
cd /d "%~dp0"
cd ..

if not exist tests\tmp md tests\tmp

del /f /a /q tests\tmp\AddFiles.txt
copy /y tests\AddFiles\AddFiles_SYSMUI.txt tests\tmp\ > nul
copy /y tests\AddFiles\AddFiles_SYSRES.txt tests\tmp\ > nul

set "APP_TMP_PATH=%cd%\tests\tmp"
set "APP_PE_LANG=zh-CN"
set "X=%~dp0tmp"
set ADDFILES_INITED=1
for /f "delims=" %%i in ('type "%APP_TMP_PATH%\AddFiles_SYSMUI.txt"') do set "MUI_LIST[%%i]=1"
for /f "delims=" %%i in ('type "%APP_TMP_PATH%\AddFiles_SYSRES.txt"') do set "MUN_LIST[%%i]=1"

rem ============================================================================
call AddFiles "mspaint.exe"
call AddFiles "\Windows\System32\mspaint.exe"
call AddFiles "\Windows\System32\services.msc"
call AddFiles "\Windows\System32\pdh.dll,taskmgr.exe"
call AddFiles "\Windows\SysWOW64\activeds.dll"
call AddFiles "\Windows\System32\bde*.exe,fve*.exe"
call AddFiles \Windows\System32\catroot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\

rem ============================================================================
call AddFiles %0 :end_files
goto :end_files

@\Windows\system32\
compmgmt.msc,CompMgmtLauncher.exe

; Filesystem Management
fsmgmt.msc

:end_files
rem ============================================================================

call AddFiles %0 :[DirectX_Files]

pause
goto :EOF

:[DirectX_Files]
@\Windows\System32\
drivers\gm.dls

+syswow64

;Microsoft Direct2D
d2d1.dll
goto :EOF
