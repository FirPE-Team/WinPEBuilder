@echo off
cd /d "%~dp0"
cd ..

if not exist tests\tmp md tests\tmp

if not exist tests\tmp\Windows\zh-cn md tests\tmp\Windows\zh-cn
if not exist tests\tmp\Windows\en-us md tests\tmp\Windows\en-us
if not exist tests\tmp\Windows\System32 md tests\tmp\Windows\System32
if not exist tests\tmp\Windows\System32\drivers md tests\tmp\Windows\System32\drivers

echo test > tests\tmp\Windows\zh-cn\notepad.exe.mui
echo test > tests\tmp\Windows\zh-cn\regedit.exe.mui
echo test > tests\tmp\Windows\zh-cn\calc.exe.mui
echo test > tests\tmp\Windows\zh-cn\mspaint.exe.mui
echo test > tests\tmp\Windows\zh-cn\cmd.exe.mui
echo test > tests\tmp\Windows\zh-cn\explorer.exe.mui
echo test > tests\tmp\Windows\zh-cn\iexplore.exe.mui
echo test > tests\tmp\Windows\zh-cn\mmc.exe.mui
echo test > tests\tmp\Windows\zh-cn\msconfig.exe.mui
echo test > tests\tmp\Windows\zh-cn\services.msc
echo test > tests\tmp\Windows\zh-cn\compmgmt.msc
echo test > tests\tmp\Windows\zh-cn\devmgmt.msc
echo test > tests\tmp\Windows\zh-cn\eventvwr.msc
echo test > tests\tmp\Windows\zh-cn\gpedit.msc
echo test > tests\tmp\Windows\zh-cn\secpol.msc
echo test > tests\tmp\Windows\zh-cn\taskmgr.exe.mui
echo test > tests\tmp\Windows\zh-cn\regedt32.exe.mui
echo test > tests\tmp\Windows\zh-cn\control.exe.mui
echo test > tests\tmp\Windows\zh-cn\rstrui.exe.mui
echo test > tests\tmp\Windows\zh-cn\msinfo32.exe.mui

echo test > tests\tmp\Windows\en-us\explorer.exe.mui
echo test > tests\tmp\Windows\en-us\shell32.dll.mui
echo test > tests\tmp\Windows\en-us\user32.dll.mui
echo test > tests\tmp\Windows\en-us\kernel32.dll.mui
echo test > tests\tmp\Windows\en-us\advapi32.dll.mui
echo test > tests\tmp\Windows\en-us\gdi32.dll.mui

echo test > tests\tmp\Windows\System32\notepad.exe
echo test > tests\tmp\Windows\System32\calc.exe
echo test > tests\tmp\Windows\System32\mspaint.exe
echo test > tests\tmp\Windows\System32\cmd.exe
echo test > tests\tmp\Windows\System32\powershell.exe
echo test > tests\tmp\Windows\System32\regedit.exe
echo test > tests\tmp\Windows\System32\explorer.exe
echo test > tests\tmp\Windows\System32\mmc.exe
echo test > tests\tmp\Windows\System32\services.exe
echo test > tests\tmp\Windows\System32\svchost.exe
echo test > tests\tmp\Windows\System32\winlogon.exe
echo test > tests\tmp\Windows\System32\lsass.exe
echo test > tests\tmp\Windows\System32\csrss.exe
echo test > tests\tmp\Windows\System32\smss.exe

echo test > tests\tmp\Windows\System32\drivers\ntfs.sys
echo test > tests\tmp\Windows\System32\drivers\cng.sys
echo test > tests\tmp\Windows\System32\drivers\disk.sys
echo test > tests\tmp\Windows\System32\drivers\classpnp.sys
echo test > tests\tmp\Windows\System32\drivers\pci.sys
echo test > tests\tmp\Windows\System32\drivers\usbport.sys
echo test > tests\tmp\Windows\System32\drivers\usbhub.sys
echo test > tests\tmp\Windows\System32\drivers\usbuhci.sys
echo test > tests\tmp\Windows\System32\drivers\usbehci.sys
echo test > tests\tmp\Windows\System32\drivers\wmiacpi.sys

echo test > tests\tmp\Windows\System32\dm1.dll
echo test > tests\tmp\Windows\System32\dm2.dll
echo test > tests\tmp\Windows\System32\dm3.dll
echo test > tests\tmp\Windows\System32\dm4.dll
echo test > tests\tmp\Windows\System32\dm5.dll
echo test > tests\tmp\Windows\System32\dm6.dll

echo test > tests\tmp\Windows\System32\kernel32.dll
echo test > tests\tmp\Windows\System32\kernelbase.dll
echo test > tests\tmp\Windows\System32\kernel.appcore.dll

set "APP_TMP_PATH=%cd%\tests\tmp"
set "APP_PE_LANG=zh-CN"
set "X=%~dp0tmp"

rem ============================================================================

call DelFilesEX \Windows\zh-cn\* "notepad.exe.mui,regedit.exe.mui"
call DelFilesEX \Windows\System32\dm*.dll "dm1.dll,dm2.dll"
call DelFilesEX \Windows\System32\drivers\*.sys "ntfs.sys,cng.sys"

rem ============================================================================

call DelFilesEX \Windows\System32\drivers\*.sys %0 :end_files
goto :end_files

ntfs.sys
cng.sys
disk.sys
classpnp.sys
pci.sys

:end_files
rem ============================================================================

call DelFilesEX \Windows\System32\*.exe %0 :[keep_exe_files]
goto :EOF

:[keep_exe_files]
notepad.exe
calc.exe
mspaint.exe
cmd.exe
powershell.exe
goto :EOF
