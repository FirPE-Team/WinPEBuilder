@echo off
cd /d "%~dp0"
cd ..

if not exist tests\tmp md tests\tmp

if exist tests\tmp\Windows rd /s /q tests\tmp\Windows

md tests\tmp\Windows\System32\drivers
md tests\tmp\Windows\System32\zh-CN
md tests\tmp\Windows\SysWOW64\zh-CN
md tests\tmp\Windows\SystemResources

echo. > tests\tmp\Windows\System32\test1.exe
echo. > tests\tmp\Windows\System32\test2.dll
echo. > tests\tmp\Windows\System32\test3.msc
echo. > tests\tmp\Windows\System32\drivers\test4.sys
echo. > tests\tmp\Windows\System32\drivers\test5.sys
echo. > tests\tmp\Windows\System32\zh-CN\test1.exe.mui
echo. > tests\tmp\Windows\System32\zh-CN\test2.dll.mui
echo. > tests\tmp\Windows\SysWOW64\test1.exe
echo. > tests\tmp\Windows\SysWOW64\test2.dll
echo. > tests\tmp\Windows\SysWOW64\zh-CN\test1.exe.mui
echo. > tests\tmp\Windows\SysWOW64\zh-CN\test2.dll.mui
echo. > tests\tmp\Windows\SystemResources\test1.exe.mun
echo. > tests\tmp\Windows\SystemResources\test2.dll.mun

echo. > tests\tmp\Windows\System32\test3.exe
echo. > tests\tmp\Windows\System32\test4.exe
echo. > tests\tmp\Windows\System32\zh-CN\test3.exe.mui
echo. > tests\tmp\Windows\SysWOW64\test3.exe
echo. > tests\tmp\Windows\SysWOW64\zh-CN\test3.exe.mui
echo. > tests\tmp\Windows\SystemResources\test3.exe.mun

echo. > tests\tmp\Windows\System32\test5.exe
echo. > tests\tmp\Windows\System32\test6.exe

md tests\tmp\Windows\System32\testdir
echo. > tests\tmp\Windows\System32\testdir\test1.exe
echo. > tests\tmp\Windows\System32\testdir\test2.exe

md tests\tmp\Windows\System32\testdir2
echo. > tests\tmp\Windows\System32\testdir2\test14.exe
echo. > tests\tmp\Windows\System32\testdir2\test15.dll

echo. > tests\tmp\Windows\System32\test16.exe
echo. > tests\tmp\Windows\System32\test17.exe
echo. > tests\tmp\Windows\System32\test18.dll
echo. > tests\tmp\Windows\System32\test19.dll

set "APP_TMP_PATH=%cd%\tests\tmp"
set "APP_PE_LANG=zh-CN"
set "APP_PE_VER=10.0.22631"
set "X=%~dp0tmp"

rem ============================================================================
call DelFiles "\Windows\System32\test1.exe"
call DelFiles "\Windows\System32\test2.dll,test3.msc"
call DelFiles "\Windows\System32\drivers"

if exist tests\tmp\Windows\System32\test1.exe echo [失败] 文件仍然存在
if exist tests\tmp\Windows\System32\test2.dll echo [失败] test2.dll 仍然存在
if exist tests\tmp\Windows\System32\test3.msc echo [失败] test3.msc 仍然存在
if exist tests\tmp\Windows\System32\drivers echo [失败] 目录仍然存在

rem ============================================================================
call DelFiles %0 :end_files
goto :end_files

@\Windows\System32\testdir\
test1.exe
test2.exe

+syswow64
\Windows\System32\test3.exe
\Windows\System32\test4.exe
-syswow64

+ver > 22600
\Windows\System32\test5.exe
+ver < 22650
\Windows\System32\test6.exe
+ver*
:end_files

if exist tests\tmp\Windows\System32\testdir\test1.exe echo [失败] test1.exe 仍然存在
if exist tests\tmp\Windows\System32\testdir\test2.exe echo [失败] test2.exe 仍然存在

if exist tests\tmp\Windows\System32\test3.exe echo [失败] test3.exe 仍然存在
if exist tests\tmp\Windows\System32\test4.exe echo [失败] test4.exe 仍然存在
if exist tests\tmp\Windows\System32\zh-CN\test3.exe.mui echo [失败] test3.exe.mui 仍然存在

if exist tests\tmp\Windows\SysWOW64\test3.exe echo [失败] SysWOW64\test3.exe 仍然存在
if exist tests\tmp\Windows\SysWOW64\zh-CN\test3.exe.mui echo [失败] SysWOW64\zh-CN\test3.exe.mui 仍然存在
if exist tests\tmp\Windows\SystemResources\test3.exe.mun echo [失败] test3.exe.mun 仍然存在

if exist tests\tmp\Windows\System32\test5.exe echo [失败] test5.exe 仍然存在
if exist tests\tmp\Windows\System32\test6.exe echo [失败] test6.exe 仍然存在

rem ============================================================================

call DelFiles "\Windows\System32\test1*.exe"
call DelFiles "\Windows\System32\test1*.dll"

if exist tests\tmp\Windows\System32\test16.exe echo [失败] test16.exe 仍然存在
if exist tests\tmp\Windows\System32\test17.exe echo [失败] test17.exe 仍然存在
if exist tests\tmp\Windows\System32\test18.dll echo [失败] test18.dll 仍然存在
if exist tests\tmp\Windows\System32\test19.dll echo [失败] test19.dll 仍然存在

rem ============================================================================
call DelFiles %0 :[DirectX_Files]
goto :test_files_5

:[DirectX_Files]
@\Windows\System32\testdir2\
test14.exe
test15.dll
goto :EOF

:test_files_5
if exist tests\tmp\Windows\System32\testdir2\test14.exe echo [失败] test14.exe 仍然存在
if exist tests\tmp\Windows\System32\testdir2\test15.dll echo [失败] test15.dll 仍然存在

if exist tests\tmp\Windows rd /s /q tests\tmp\Windows
pause
goto :EOF