@echo off
if /i "%UserName%" == "SYSTEM" (Set PE=1&Goto GotAdmin) else (reg query "HKLM\SYSTEM\ControlSet001\Control\MiniNT" 1>nul 2>nul&&(Set PE=1&Goto GotAdmin))
:BatchGotAdmin
Set _Args=%*
if `%1` neq `` Set "_Args=%_Args:"=""%"
if exist %WinDir%\System32\fltMC.exe fltMC 1>nul 2>nul||mshta VBScript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c """"%~f0"" %_Args%""",,"runas",1)(Window.Close) 2>nul&&Exit /b

:GotAdmin
Title 访问共享&Color 2f
MODE 1>nul 2>nul&&MODE con: Cols=54 Lines=15
Pushd "%CD%"&cd /d "%~dp0"

:Init :: 内部参数初始化
Set Auto=1
Set ShareOff=1
find /? 1>nul 2>nul&&Set "findstr=find.exe"
findstr /? 1>nul 2>nul&&Set "findstr=findstr.exe"
if not defined findstr Call :EchoX "cf.: 找不到 find.exe 文件，按任意键退出 。。。"&Pause >nul&Exit /b

:ChkSer :: 检测共享服务状态
%WinDir%\System32\sc query LanmanWorkstation|%findstr% " 1060:" 1>nul 2>nul
if '%ErrorLevel%' == '0' Set err= Workstation（LanmanWorkstation）服务不存在 ！！&Goto SErr
%WinDir%\System32\sc query LanmanWorkstation|%findstr% "1  STOPPED" 1>nul 2>nul
if '%ErrorLevel%' == '0' Set err= Workstation（LanmanWorkstation）服务未开启 ！！&Goto SErr
%WinDir%\System32\sc query lmhosts|%findstr% " 1060:" 1>nul 2>nul
if '%ErrorLevel%' == '0' Set err= TCP／IP NetBIOS Helper（lmhosts）服务不存在 ！！&Goto SErr
%WinDir%\System32\sc query lmhosts|%findstr% "1  STOPPED" 1>nul 2>nul
if '%ErrorLevel%' == '0' Set err= TCP／IP NetBIOS Helper（lmhosts）服务未开启 ！！&Goto SErr

:RConfig :: 读取配置文件。优先级: new参数 > 参数1文件 > 脚本同名_参数1.txt > 脚本同名.txt
Set "Config=%~n0.txt"
if `%1` neq `` (if /i `%1` neq `new` (Set "Config=%1") else Goto Input)
Set "Config=%Config:"=%"
if not exist "%Config%" (if not exist "%~n0_%Config%.txt" (Goto Input) else Set "Config=%~n0_%Config%.txt")
for /f "usebackq tokens=1* delims=:=" %%i in ("%Config%") do (
    if "%%i" == "路径" Set "unc=%%j"
    if "%%i" == "用户" Set "user=%%j"
    if "%%i" == "密码" Set "pass=%%j"
    if "%%i" == "盘符" Set "dsk=%%j"
)
if defined unc Set "路径=%unc:&=^&%"
if defined user Set "用户=%user%"
if defined pass Set "密码=%pass:&=^&%"
if defined dsk Set "盘符=%dsk%"

:SConfig :: 显示配置参数
Call :EchoX "xx::  " "70.:[配置参数]"
echo  ┌→→→→→→→→→→→→→→→→→→→→→→→→┐
echo  丨⊙共享路径：%路径%
echo  丨○登录用户：%用户%
echo  丨○登录密码：%密码%
echo  丨○映射盘符：%盘符%
echo  └→→→→→→→→→→→→→→→→→→→→→→→→┘

:Auto :: 自动化处理
if not defined unc Goto Input&if not defined user Goto Input
if "%Auto%" == "1" Goto Check

:Manual :: 手动处理
Call :EchoX "xx::               " "e5::打开共享（O）丨 修改参数（S）"&choice /c os
if '%ErrorLevel%' == '1' Goto Check
if '%ErrorLevel%' == '2' Goto Input

:Input :: 输入配置参数
Cls&for /f "usebackq" %%i in (`echo %Config%`) do Set "title=%%~ni%%~xi"
Title -^>%title%
Call :EchoX "xx::  " "70.:[配置参数]"
echo  ┌→→→→→→→→→→→→→→→→→→→→→→→→→
Set unc=&Call :EchoX "xx:: 丨" "cf::⊙" "共享路径："&Set /p unc=
Set user=&Call :EchoX "xx:: 丨○登录用户："&Set /p user=
Set pass=&Call :EchoX "xx:: 丨○登录密码："&Set /p pass=
Set dsk=&Call :EchoX "xx:: 丨○映射盘符："&Set /p dsk=
echo  └→→→→→→→→→→→→→→→→→→→→→→→→→

:Check :: 检测配置参数
if not defined unc Set err= 参数不完整，共享路径不能为空 ！！&Goto NErr
if "%unc:~0,2%" neq "\" Set "unc=\\%unc%"
if "%unc:~-1%" == "" Set "unc=%unc:~0,-1%"
for /f "usebackq tokens=1,* delims=" %%i in (`echo %unc:~2%`) do Set sub=%%j
Set "dsk=%dsk::=%"
if "%dsk%" == ":=" (Set dsk=) else Set "dsk=%dsk%:"
if not defined sub (if defined dsk Set subdsk=%dsk%&Set dsk=) else Set sub=
if not defined user (Set Guest=0&Set "user=administrator")

:Login :: 共享路径登录验证
REM 已存在共享路径处理
Set OC=&if "%ShareOff%" == "1" (net use|find /i "%unc%%sub%" 1>nul 2>nul||Goto LogOff) else Goto LogOff
Call :EchoX "xx::  " "70:: 共享已存在，" "e5::继续打开（O）丨 关闭共享（C）"&choice /c OC
Set OC=%ErrorLevel%
:LogOff :: 若共享路径登录成功过，则删除登录后短时间内仍能访问 (存在延迟)
net use "%unc%%sub%" /delete 1>nul 2>nul
if defined dsk if exist "%dsk%" (
    echo.|net use %dsk% /delete 1>nul 2>nul
    if exist "%dsk%" (
        echo.&Call :EchoX "xx::   已存在与 %dsk% 的连接，是否强行断开并关闭？(y/n): "
        net use %dsk% /delete 1>nul 2>nul
    )
)
net use "%unc%%sub%" /user:"%user%" "试错，清除登录缓存！" 1>nul 2>nul
net use "%unc%%sub%" /user:".\%user%" "试错，清除登录缓存！" 1>nul 2>nul
if "%OC%" == "2" (echo.&Call :EchoX "  " "cf.: 共享已关闭，但存在延迟短时间内仍能访问！"&Call :Delay 5 +&Exit /b) else echo.&Call :EchoX "xx::  " "e5.: √正在登录共享路径 。。。    　"
if defined pass (net use %dsk% "%unc%%sub%" /user:"%user%" "%pass%" 1>nul 2>nul) else (echo.|net use %dsk% "%unc%%sub%" /user:"%user%" 1>nul 2>nul)
if '%ErrorLevel%' neq '0' if defined pass (net use %dsk% "%unc%%sub%" /user:"%user%" "%pass%" 1>nul 2>nul) else (echo.|net use %dsk% "%unc%%sub%" /user:"%user%" "" 1>nul 2>nul)
if '%ErrorLevel%' neq '0' if defined pass (net use %dsk% "%unc%%sub%" /user:".\%user%" "%pass%" 1>nul 2>nul) else (echo.|net use %dsk% "%unc%%sub%" /user:".\%user%" 1>nul 2>nul)
if '%ErrorLevel%' neq '0' if defined pass (net use %dsk% "%unc%%sub%" /user:".\%user%" "%pass%" 1>nul 2>nul) else (echo.|net use %dsk% "%unc%%sub%" /user:".\%user%" "" 1>nul 2>nul)
if '%ErrorLevel%' neq '0' if "%Guest%" == "0" (Set Guest=1&Set "user=guest"&Goto Login)
if '%ErrorLevel%' neq '0' if exist "%dsk%" Set err= %dsk:~0,1% 盘符已存在，且无法主动断开连接 ！！&Goto NErr
if '%ErrorLevel%' neq '0' Set err= 验证不通过，请检查参数配置或非内网用户 ！！&Goto NErr
if defined subdsk if not defined dsk (Call :SelSub&echo.&Set dsk=%subdsk%&Set subdsk=&Goto Login)
%WinDir%\explorer.exe "%unc%%sub%"
if not defined PE (Goto Success) else (Set n=0&Set have=)
for /l %%i in (1,1,50) do for /f "tokens=2*" %%j in ('reg query "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths" /v "url%%i" 2^>nul') do (Set n=%%i&if /i "%unc%%sub%" == "%%k" Set have=1)
if defined have (Goto Success) else (Set /a n+=1)
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths" /f /v "url%n%" /t REG_SZ /d "%unc%%sub%" 1>nul 2>nul

:Success
if /i `%1` == `new` if exist "%~n0.txt" for /l %%i in (1,1,100) do if not exist "%~n0_%%i.txt" (copy /y "%~n0.txt" "%~n0_%%i.txt"&Goto WConfig)
:WConfig :: 登录成功，参数写入配置文件
(echo 路径:=%unc:&=^&%
echo 用户:=%user%
echo 密码:=%pass:&=^&%
echo 盘符:=%dsk%
) >"%Config%"
Exit /b

:SelSub :: 不支持选择带空格二级目录
setlocal enabledelayedexpansion
:SSLoop
Set n=0&for /f "skip=7 tokens=1,* delims= " %%i in ('net view "%unc%"') do Set /a n+=1
if !n! gtr 5 (Set /a n+=9&MODE 1>nul 2>nul&&MODE con: Cols=54 Lines=!n!)
Cls&Call :EchoX "cf.:  根路径不允许映射盘符，请选择二级目录↓"
Set n=0&for /f "skip=7 tokens=1,* delims= " %%i in ('net view "%unc%"') do (
    if !n! gtr 0 echo         !n!.!share!
    Set /a n+=1&Set sub!n!=%%i&Set share=%%i
)
if !n! == 0 echo   资源列表是空的。
echo -----------------------------------------------------
Set choice=&Call :EchoX "xx::  "&Set /p choice=选择:
Set "choice=%choice: =%"
(if not defined sub%choice% Goto SSLoop)&(if "%choice%" == "!n!" Goto SSLoop)
Set sub=\!sub%choice%!
endlocal&Set sub=%sub%
Goto :eof

:SErr :: 服务报错
if defined err (Cls&Call :EchoX "cf.:%err%"&Pause >nul&Exit /b) else Goto :eof

:NErr :: 验证报错
if defined err (Cls&Call :EchoX "cf.:%err%"&Call :EchoX "e5.: 按任意键，重新配置参数 。。。"&Pause >nul&Goto Input) else Goto :eof

:Delay :: 延迟操作 <%1=Sec|延迟秒数> [%2=+|显示倒计时]。
if `%2` == `+` (Set n=2) else Set n=1
if exist %WinDir%\System32\timeout.exe (timeout /t %1 %n%>nul) else if exist %WinDir%\System32\choice.exe (choice /t %1 /d y /n >nul) else ping 127.1 -n %1 >nul
Goto :eof

:EchoX :: 显示彩色文字 (不支持半角字符 \ / : * ? " < >|. % ! ~)。
setlocal enabledelayedexpansion
Set echox=EchoX.exe&&!echox! 1>nul 2>nul||(Set echox=&mkdir "%TEMP%\EchoX" 2>nul)
for %%a in (%*) do (
    Set "param=%%a"&Set "param=!param:"=!"
    Set "color=!param:~0,2!"&(if not exist %WinDir%\System32\findstr.exe if not defined echox Set "color=xx")
    Set n=0&(if "!param:~2,2!" == "::" Set n=1)&(if "!param:~2,2!" == ".:" Set n=2)
    if !n! gtr 0 (
        if /i "!color!" == "xx" (Set /p="_!param:~4!"<nul) else (Set param=%%~nxa&if defined echox (!echox! -c !color! -n "!param:~4!") else (Pushd "%TEMP%\EchoX" 2>nul&>"!param:~4!",Set /p= <nul&findstr /a:!color! .* "!param:~4!*"&del "!param:~4!"&Popd))
        if !n! == 2 echo.
    ) else if defined param Set /p="_!param!"<nul
)
endlocal
Goto :eof