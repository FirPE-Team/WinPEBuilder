@echo off
if /i "%UserName%" == "SYSTEM" (Goto GotAdmin) else (reg query "HKLM\SYSTEM\ControlSet001\Control\MiniNT" 1>nul 2>nul&&Goto GotAdmin)
:BatchGotAdmin
Set _Args=&Set Args=%*
if `%1` neq `` Set "_Args=%Args:"=""%"
if exist %WinDir%\System32\fltMC.exe fltMC 1>nul 2>nul||(echo CreateObject^("Shell.Application"^).ShellExecute "cmd.exe","/c """"%~f0"" %_Args%""",,"runas",1 >"%TEMP%\getAdmin.vbs"&(CScript 1>nul 2>nul&&CScript //nologo "%TEMP%\getAdmin.vbs" 1>nul 2>nul||"%TEMP%\getAdmin.vbs" 2>nul)&del /f /q "%TEMP%\getAdmin.vbs" 2>nul&Exit /b)

:GotAdmin :: 内部参数初始化
Set "AutoOpen=1"        :: 自动打开共享：1 启用，0 禁用
Set "ShareOff=0"        :: 允许关闭共享：1 启用，0 禁用
Set "CUTPaths=1"        :: 允许地址栏记录共享路径：1 启用，0 禁用
Set "CheckURL=1"        :: 通过 Dir 检测路径有效性 (启用可能存在检测缓慢)：1 启用，0 禁用
Set "ClrCache=1"        :: 允许试错，清除登录缓存  (启用登录需清缓存较慢)：1 启用，0 禁用
Set "DumpNUPT=1"        :: 转存外置 NUPort.exe，用于检测 445 端口是否开放：1 启用，0 禁用
Set "CMDTitle=访问共享" :: CMD窗口默认标题
Set "DefCMode=Title %CMDTitle%&(if exist %WinDir%\System32\ureg.dll Mode 58,15 2>nul)&Color 2f"
Pushd "%CD%"&cd /d "%~dp0"&%DefCMode%
find /? 1>nul 2>nul&&Set "findstr=find /i "||Set findstr=
findstr /? 1>nul 2>nul&&Set "findstr=findstr /i /c:"
if not defined findstr Call :EchoX "cf.: 找不到 find.exe 文件。"&Call :Delay 5 +&Exit /b
reg /? 1>nul 2>nul||(Call :EchoX "cf.: 找不到 reg.exe 文件。"&Call :Delay 5 +&Exit /b)
sc query 1>nul 2>nul||(Call :EchoX "cf.: sc query 执行失败！"&Call :Delay 5 +&Exit /b)
net use 1>nul 2>nul||(Call :EchoX "cf.: net use 执行失败！"&Call :Delay 5 +&Exit /b)
ipconfig 1>nul 2>nul||(Call :EchoX "cf.: ipconfig 执行失败！"&Call :Delay 5 +&Exit /b)
Set "CertCa=if exist %WinDir%\System32\CertCa.dll"&for /f "tokens=2 delims=[]" %%a in ('ver') do for /f "tokens=2-4 delims=. " %%b in ("%%~a") do if %%~b%%~c leq 61 Set CertCa=
Set "NUPort=NUPort.exe"&if "%DumpNUPT%" == "1" NUPort 1>nul 2>nul||(Set NUPort="%TEMP%\NUPort.exe"&if not exist "%TEMP%\NUPort.exe" if exist %WinDir%\System32\CertCli.dll %CertCa% CertUtil -? 1>nul 2>nul&&CertUtil -f -decode "%~f0" "%TEMP%\NUPort.exe" 1>nul 2>nul)

:ChkSer :: 检测共享服务状态
sc query LanmanWorkstation|%findstr%" 1060:" 1>nul 2>nul&&(Cls&Call :EchoX "cf.: Workstation（LanmanWorkstation）服务不存在 ！！"&Call :Delay 5 +&Exit /b)
for /f "tokens=2*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation" /v "Start" 2^>nul') do if /i "%%~j" == "0x4" sc config LanmanWorkstation start= demand 1>nul 2>nul
sc query LanmanWorkstation 1>nul 2>nul&&net start LanmanWorkstation 1>nul 2>nul
sc query LanmanWorkstation|%findstr%"1  STOPPED" 1>nul 2>nul&&(Cls&Call :EchoX "cf.: Workstation（LanmanWorkstation）服务未开启 ！！"&Call :Delay 5 +&Exit /b)
sc query lmhosts|%findstr%" 1060:" 1>nul 2>nul&&(Cls&Call :EchoX "cf.: TCP／IP NetBIOS Helper（lmhosts）服务不存在 ！！"&Call :Delay 5 +&Exit /b)
for /f "tokens=2*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\lmhosts" /v "Start" 2^>nul') do if /i "%%~j" == "0x4" sc config lmhosts start= demand 1>nul 2>nul
sc query lmhosts 1>nul 2>nul&&net start lmhosts 1>nul 2>nul
sc query lmhosts|%findstr%"1  STOPPED" 1>nul 2>nul&&(Cls&Call :EchoX "cf.: TCP／IP NetBIOS Helper（lmhosts）服务未开启 ！！"&Call :Delay 5 +&Exit /b)

:RConfig :: 读取配置文件。优先级: new参数 > 参数1文件 > 脚本同名_参数1.txt > 脚本同名.txt
Set uni=无输入&Set unc=&Set user=&Set pass=&Set dsk=&Set val=
Set "Config=%~n0.txt"
if `%1` == `` Goto RC
if /i "%~1" == "new" (Goto Input) else Set "Config=%~1"
if not exist "%Config%" if not exist "%~n0_%Config%.txt" (Goto Input) else Set "Config=%~n0_%Config%.txt"
:RC
if exist "%Config%" for /f "usebackq tokens=1* delims=:=" %%i in ("%Config%") do (
    if "%%~i" == "路径" Set "unc=%%~j"
    if "%%~i" == "用户" Set "user=%%~j"
    if "%%~i" == "密码" Set "pass=%%j"
    if "%%~i" == "盘符" Set "dsk=%%~j"
    if "%%~i" == "验证" Set "val=%%~j"
)
if defined unc Set "路径=%unc:&=^&%"
if defined user Set "用户=%user%"
if defined pass Set "密码=%pass:&=^&%"
if defined dsk Set "盘符=%dsk%"
:: if defined val Set "验证=%dsk%"

:VstdURL :: 无参启动，获取注册表存储的已访问共享路径，并判断是否有权限访问 (不支持带半角 ！共享路径)
if `%1` neq `` (Goto SConfig) else echo.
Set /p="_  ① "<nul&Call :EchoX "9f.:获取已访问共享列表。。。"&echo.
if "%CheckURL%" == "1" (Set "#=可"&Set /p="_  ② "<nul&Call :EchoX "9f.:检测共享路径有效性。。。" "xx::     ") else (Set "#=已"&Call :EchoX "xx::     ")
Set cn=0&Set have=&for /f "skip=2 tokens=1,2* delims= " %%i in ('reg query "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths" 2^>nul') do Set /a cn+=1&if /i "%unc%" == "%%~k" Set have=1
if exist "%Config%" if not defined have Goto SConfig& :: 有配置文件且路径不在列表
Set /p="_[检测数%cn%]: "<nul
Setlocal EnableDelayedExpansion
Set dn=0&Set vn=0&for /f "skip=2 tokens=1,2* delims= " %%i in ('reg query "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths" 2^>nul') do (
    Set /p="_. "<nul&Set /a dn+=1&Title %CMDTitle% -^> [进度: !dn!/%cn%]
    echo "%%~k"|%findstr%"IPC$" 1>nul 2>nul||if "%CheckURL%" == "1" ( :: 根路径无法通过 Dir 检测
        Set nup=1&%NUPort% 1>nul 2>nul&&for /f "tokens=2* delims=\" %%l in ('echo "%%~k"') do (%NUPort% "%%~l" 445 1>nul 2>nul||Set nup=0)
        if !nup! == 1 net use|%findstr%"%%~k" 2>nul|%findstr%"OK   " 1>nul 2>nul&&(Set /a vn+=1&Set "url!vn!=%%~k")||(dir "%%~k" 1>nul 2>nul&&(Set /a vn+=1&Set "url!vn!=%%~k"))
    ) else Set /a vn+=1&Set "url!vn!=%%~k"
)
%DefCMode%
if !vn! == 0 Endlocal&if exist "%Config%" (Goto SConfig) else Goto Input
if !vn! gtr 7 Set /a n=!vn!+8&if exist %WinDir%\System32\ureg.dll Mode 58,!n! 2>nul
:VU
Cls&Call :EchoX "xx::  " "70::[%#%访问共享列表]" "xx.:↓"
echo  ┌→→→→→→→→→→→→→→→→→→→→→→→→→→→
for /l %%i in (1,1,!vn!) do if %%~i lss 10 (echo  丨%%~i^) !url%%~i!) else echo  丨%%~i)!url%%~i!
echo  └→→→→→→→→→→→→→→→→→→→→→→→→→→→
Call :EchoX "xx::          " "9f::[N]" "xx:: 回车打开新共享        " "9f::[Q]" "xx.: 退出窗口"
Set choice=&Call :EchoX "xx::>>"&Call :EchoX "70::选择：" "xx:: "&Set /p choice=||Set choice=n
Set "choice=!choice: =!"
if /i "%choice%" == "n" Endlocal&%DefCMode%&Set unc=&Goto Input
if /i "%choice%" == "q" Popd&Exit
if not defined url!choice! Goto VU
for /f %%i in ('echo !choice!') do %WinDir%\explorer.exe !url%%~i!
if !vn! == 1 (Popd&Exit&Endlocal) else Goto VU

:SConfig :: 显示配置参数
Cls&Call :EchoX "xx::  " "70::[配置文件]"&echo  ^> %Config%
echo  ┌→→→→→→→→→→→→→→→→→→→→→→→→→→→
echo  丨⊙共享路径：%路径%
echo  丨○登录用户：%用户%
echo  丨○登录密码：%密码%
echo  丨○映射盘符：%盘符%
:: echo  丨○验证方式：%验证%
echo  └→→→→→→→→→→→→→→→→→→→→→→→→→→→

:Auto :: 自动化处理
(if not defined unc Goto Input)&(if not defined user Goto Input)
if "%AutoOpen%" == "1" Call :ChkUNC&Call :ChkLR&Goto Login

:Manual :: 手动处理
Call :EchoX "xx::  " "70:: 　选择操作：" "e5::继续打开共享（S）丨 修改配置（C）" "xx:: "&choice /c sc
if '%ErrorLevel%' == '1' Call :ChkUNC&Call :ChkLR&Goto Login
if '%ErrorLevel%' == '2' Goto Input

:Input :: 输入配置参数
Cls&Call :EchoX "xx::  " "70::[配置文件]"&echo  ^> %Config%
echo  ┌→→→→→→→→→→→→→→→→→→→→→→→→→→→
Call :EchoX "xx:: 丨" "cf::⊙" "共享路径："&if not defined unc (Set uni=有输入&Set /p unc=) else (Set uni=无输入&echo %unc:&=^&%)
if "%uni%" neq "无输入" Set "uni=%unc%"&Call :ChkUNC&if ErrorLevel 9 Goto Input
Set user=&Call :EchoX "xx:: 丨○登录用户："&Set /p user=
Set pass=&Call :EchoX "xx:: 丨○登录密码："&Set /p pass=
Set dsk=&Call :EchoX "xx:: 丨○映射盘符："&Set /p dsk=
:: Set val=&Call :EchoX "xx:: 丨○验证方式："&Set /p val=
echo  └→→→→→→→→→→→→→→→→→→→→→→→→→→→
Call :ChkLR&if ErrorLevel 9 (Exit /b) else Goto Login

:Login :: 共享路径登录验证 (已存在共享路径判断：net use 全路径匹配；net use 根路径匹配且可访问)
Set UR=&for /f "tokens=2* delims=\" %%i in ('echo "%unc%%sub%"') do Set "UR=\\%%~i"
Set "UR=%UR:"=%"
Set OC=&if "%ShareOff%" == "1" (net use|%findstr%"%unc%%sub%" 2>nul|%findstr%"OK   " 1>nul 2>nul||((net use|%findstr%"%UR%" 2>nul|%findstr%"OK   " 1>nul 2>nul&&if "%CheckURL%" == "1" dir "%unc%%sub%" 1>nul 2>nul)||Goto LogOff)) else Goto LogOff
Call :EchoX "xx::  " "70:: 共享已存在：" "e5::直接回车打开共享 丨 任意键回车关闭共享"&Set /p OC=：
:LogOff :: 若共享路径登录成功过，则删除登录后短时间内仍能访问 (存在延迟)
echo.&if defined OC (Set #=3&Call :EchoX "  " "e5.: メ正在关闭共享路径 。。。") else (Set #=7&if "%Guest%" neq "1" Call :EchoX "  " "e5.: √正在登录共享路径 。。。")
Setlocal EnableDelayedExpansion
for /f "delims=\" %%i in ('echo "%unc:~2%%sub%"') do for /f "tokens=1,* delims=\" %%j in ('net use^|%findstr%"%%~i" 2^>nul') do (Set "var=%%~k"&Set "var=\\!var:~0,-25!"&Call :DelRChar var " "&net use "!var!" /delete 1>nul 2>nul)
Endlocal
Call :EchoX "xx:: "&Call :Prog 1 %#% "关闭共享路径"&1>nul 2>nul echo.|net use "%unc%%sub%" /delete 1>nul 2>nul
if defined dsk (
    1>nul 2>nul echo.|net use %dsk% /delete 1>nul 2>nul
    if exist "%dsk%" (
        echo.&Call :EchoX "xx::   已存在与 %dsk% 的连接，是否强行断开并关闭？(Y/N)："
        net use %dsk% /delete 1>nul 2>nul&Set /p="_ "<nul
    )
)
%NUPort% 1>nul 2>nul&&(Call :Prog 1 %#% "检测 445 端口"&%NUPort% "%UR:~2%" 445 1>nul 2>nul||(Cls&Call :EchoX "cf.: 目标主机 445 端口连接超时！！"&Goto RInput))
if not defined val Set val=0
Call :Prog 2 %#% "正在试错，清登录缓存"&(if %val% geq 0 if "%ClrCache%" == "1" 1>nul 2>nul echo.|net use "%unc%%sub%" /user:"%user%" "试错，清登录缓存！" 1>nul 2>nul)
Call :Prog 3 %#% "正在试错，清登录缓存"&(if %val% leq 0 if "%ClrCache%" == "1" 1>nul 2>nul echo.|net use "%unc%%sub%" /user:".\%user%" "试错，清登录缓存！" 1>nul 2>nul)
if defined OC Title %CMDTitle%&echo.&Call :EchoX "  " "cf:: 已关闭共享，但存在延迟，短时间内仍能访问共享！"&Call :Delay 5&Exit /b
Call :Prog 4 %#% "用户密码，验证登录"&(if %val% geq 0 if defined pass (1>nul 2>nul echo.|net use %dsk% "%unc%%sub%" /user:"%user%" "%pass%" 1>nul 2>nul&&Set val=1) else 1>nul 2>nul echo.|net use %dsk% "%unc%%sub%" /user:"%user%" 1>nul 2>nul&&Set val=1)
if '%ErrorLevel%' neq '0' Call :Prog 5 %#% "用户空密，验证登录"&(if %val% geq 0 if not defined pass 1>nul 2>nul echo.|net use %dsk% "%unc%%sub%" /user:"%user%" "" 1>nul 2>nul&&Set val=1)
if '%ErrorLevel%' neq '0' Call :Prog 6 %#% ".\用户密码，验证登录"&(if %val% leq 0 if defined pass (1>nul 2>nul echo.|net use %dsk% "%unc%%sub%" /user:".\%user%" "%pass%" 1>nul 2>nul&&Set val=-1) else 1>nul 2>nul echo.|net use %dsk% "%unc%%sub%" /user:".\%user%" 1>nul 2>nul&&Set val=-1)
if '%ErrorLevel%' neq '0' Call :Prog 7 %#% ".\用户空密，验证登录"&(if %val% leq 0 if not defined pass 1>nul 2>nul echo.|net use %dsk% "%unc%%sub%" /user:".\%user%" "" 1>nul 2>nul&&Set val=-1)
if '%ErrorLevel%' neq '0' if "%Guest%" == "0" (Set Guest=1&Set "user=guest"&Goto Login)
if '%ErrorLevel%' neq '0' if exist "%dsk%" Cls&Call :EchoX "cf.: %dsk:~0,1% 盘符已存在，且无法主动断开连接 ！！"&Goto RInput
if '%ErrorLevel%' neq '0' (dir "%unc%%sub%" 1>nul 2>nul||if %val% == 0 (Cls&Call :EchoX "cf.: 验证不通过，请检查参数配置或为非内网用户 ！！"&Goto RInput) else Set val=0&(if defined Guest Set Guest=0&Set "user=administrator")&Goto Login)
if defined subdsk if not defined dsk (Title %CMDTitle%&Call :SelDir&echo.&Set dsk=%subdsk%&Set subdsk=&Goto Login)
%WinDir%\explorer.exe "%unc%%sub%"
if "%CUTPaths%" == "1" Call :CUTPaths "%unc%%sub%"

:Success
if /i "%~1" == "new" if exist "%~n0.txt" for /l %%i in (1,1,100) do if not exist "%~n0_%%i.txt" (copy /y "%~n0.txt" "%~n0_%%i.txt"&Goto WConfig)
:WConfig :: 登录成功，参数写入配置文件
(echo 路径:=%unc:&=^&%
 echo 用户:=%user%
 echo 密码:=%pass:&=^&%
 echo 盘符:=%dsk%
 echo 验证:=%val%
) >"%Config%"
Exit /b

:SelDir :: 不支持选择带 ! 二级目录
Setlocal EnableDelayedExpansion
:SDLoop
Set n=0&for /f "skip=7 delims=*" %%i in ('net view "%unc%"') do Set /a n+=1
if !n! gtr 5 Set /a n+=9&if exist %WinDir%\System32\ureg.dll Mode 58,!n! 2>nul
Cls&Call :EchoX "cf.:  根路径不允许映射盘符，请选择二级目录！"&Call :EchoX "9f.:  (不支持选择带半角 ！二级目录↓)"&echo.
Set n=0&for /f "skip=7 delims=*" %%i in ('net view "%unc%"') do (
    if !n! gtr 0 if !n! leq 9 (echo         !n! .!share!) else echo         !n!.!share!
    Set /a n+=1&Set "share=%%~i"
    for /l %%j in (0,1,100) do if "!share:~%%j,8!" == "  Disk  " Set "share=!share:~0,%%j!"&Call :DelRChar share " "
    Set "sub!n!=!share!"
)
if !n! == 0 echo   资源列表是空的。
echo.&echo ---------------------------------------------------------
Set choice=&Call :EchoX "xx::>>"&Call :EchoX "70::选择：" "xx:: "&Set /p choice=
Set "choice=%choice: =%"
(if not defined sub%choice% Goto SDLoop)&(if "%choice%" == "!n!" Goto SDLoop)
Set "sub=\!sub%choice%!"
Endlocal&Set "sub=%sub%"
%DefCMode%&Goto :eof

:ChkUNC :: 检测与补充UNC路径
:: if not defined unc Cls&Call :EchoX "cf.: 参数不完整，共享路径不能为空 ！！"&Goto RInput
for /f "tokens=2*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\ComputerName\ActiveComputerName" /v "ComputerName" 2^>nul') do Set "ACName=%%~j"
if not defined unc Set "unc=%ACName%"
Call :DelRChar unc "\"
Set "unc=%unc:/=\%"
if "%unc:~0,2%" neq "\\" Set "unc=\\%unc%"
(if /i "%unc:~2,9%" == "localhost" Set "unc=\\%ACName%%unc:~11%")&(if "%unc:~2,5%" == "127.1" Set "unc=\\127.0.0.1%unc:~7%")
Set IP=&Set /a "#=%unc:~2%" 2>nul&&if %unc:~2% gtr 0 if %unc:~2% lss 255 Call :LocalIP IP
if defined IP Set "unc=\\%IP%.%unc:~2%"
for /f "tokens=1,2* delims=." %%i in ('echo "%unc:~2%"') do if "%%~i" neq "" if "%%~j" neq "" if "%%~k" == "" Set "unc=\\192.168.%%~i.%%~j"
Set "unc=%unc:"=%"
if "%uni%" neq "无输入" if /i "%uni%" neq "%unc%" (Exit /b 9) else cd.&Goto :eof

:ChkLR :: 检测是否为本机资源
Set "un=%unc:~2%"&Set sub=&for /f "tokens=1,* delims=\" %%i in ('echo "%unc:~2%"') do if "%%~j" neq "" Set "un=%%~i"&Set "sub=%%~j"
Set "un=%un:"=%"&Set "sub=%sub:"=%"
(if /i "%un%" == "%ACName%" Call :LocalRes&Exit /b 9)&(if /i "%un%" == "127.0.0.1" Call :LocalRes&Exit /b 9)
for /f "tokens=1,* delims=:" %%i in ('ipconfig^|%findstr%"IPv4"') do if "%%~j" == " %un%" Call :LocalRes&Exit /b 9
Call :DelRChar dsk "\"
Call :DelRChar dsk "/"
Set "dsk=%dsk::=%"
if "%dsk%" == ":=" (Set dsk=) else Set "dsk=%dsk%:"
if not defined sub (if defined dsk Set "subdsk=%dsk%"&Set dsk=) else Set sub=
if not defined user (Set Guest=0&Set "user=administrator") else Set Guest=
cd.&Goto :eof

:LocalRes :: 访问本机资源
echo.&Call :EchoX "  " "e5.: √正在打开本机共享路径 。。。"
sc query LanmanServer|%findstr%" 1060:" 1>nul 2>nul
if '%ErrorLevel%' == '0' Cls&Call :EchoX "cf.: Server 服务不存在 ！！"&Call :Delay 5 +&Exit /b
for /f "tokens=2*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer" /v "Start" 2^>nul') do if /i "%%~j" == "0x4" sc config LanmanServer start= demand 1>nul 2>nul
sc query LanmanServer 1>nul 2>nul&&net start LanmanServer 1>nul 2>nul
sc query LanmanServer|%findstr%"1  STOPPED" 1>nul 2>nul
if '%ErrorLevel%' == '0' Cls&Call :EchoX "cf.: Server 服务未开启 ！！"&Call :Delay 5 +&Exit /b
dir "%unc%" 1>nul 2>nul&&(%WinDir%\explorer.exe "%unc%"&cd.)||%WinDir%\explorer.exe "\\%un%"
Goto :eof

:LocalIP :: 获取本机第一个存在网关的物理网卡有效IP段 <%1=strVar>
Setlocal EnableDelayedExpansion
Set IP=&for /f "delims=" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkCards" 2^>nul') do (
    if not defined IP for /f "tokens=1,2*" %%b in ('reg query "%%~a" 2^>nul') do if /i "%%~b" == "Description" Set flag=0&for /f "tokens=1* delims=:" %%i in ('ipconfig /all 2^>nul') do (
        Set "key=%%~ix"&Set "value=%%~jx"
        if "!flag!" == "0" if "!value:%%~dx=!" neq "!value!" Set flag=1
        if "!flag!" == "1" if "!key:IPv4=!" neq "!key!" Set "IP=!value:~1,-1!"&Set flag=2
        if "!flag!" == "2" ( :: 网关存在判断为有效IP
            if "!key:网关=!" neq "!key!" if "!value:~1,-1!" == "" (Set IP=&Set flag=0) else Set flag=x
            if "!key:Gateway=!" neq "!key!" if "!value:~1,-1!" == "" (Set IP=&Set flag=0) else Set flag=x
        )
    )
)
Endlocal&Set IP=%IP%
if defined IP for /f "tokens=1,2,3* delims=." %%i in ('echo "%IP%"') do Set "IP=%%~i.%%~j.%%~k"
Set "%~1=%IP%"&Goto :eof

:CUTPaths :: 地址栏共享路径 <%1=%unc%%sub%|共享路径> [%2=-|删除路径]
if "%~2" == "-" Goto DelCUTP
Set STP=0&for /f "tokens=2*" %%i in ('reg query "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackProgs" 2^>nul') do Set /a STP=%%~j
if "%STP%" neq "1" reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v "Start_TrackProgs" /t REG_DWORD /d 1 1>nul 2>nul&GPUpdate /Target:User /Force 1>nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /f /v "ClearRecentDocsOnExit" /t REG_DWORD /d 1 1>nul 2>nul
Set n=0&Set have=&for /l %%i in (1,1,50) do for /f "tokens=2*" %%j in ('reg query "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths" /v "url%%~i" 2^>nul') do (Set n=%%~i&if /i "%unc%%sub%" == "%%~k" Set have=1)
if defined have (Goto :eof) else Set /a n+=1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths" /f /v "url%n%" /t REG_SZ /d "%~1" 1>nul 2>nul
Goto :eof
:DelCUTP :: 弃用，序号中断会导致地址栏不显示断号之后的路径
Set key=&Set item=&for /f "delims= " %%i in ('reg query "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths" /s /d /f "%~1" 2^>nul') do if not defined key (Set "key=%%~i") else if not defined item Set "item=%%~i"
if defined key if defined item reg delete "%key%" /f /v "%item%" 1>nul 2>nul
Goto :eof

:DelRChar :: 删除变量尾部字符 <strVar> <Char>
Setlocal EnableDelayedExpansion
Set "str=!%~1!"&Set "char=%~2"
:DRLoop
if "!str:~-1!" == "!char!" (
Set "str=!str:~0,-1!"&Goto DRLoop)
Endlocal&Set "%~1=%str%"&Goto :eof

:RInput :: 验证报错，重新配置参数
Call :EchoX "e5.: 按任意键，重新配置参数 。。。"&Title %CMDTitle%&Pause >nul&Set unc=&Set uni=无输入&Goto Input

:Prog :: 进度显示 Call :Prog 1 %#%
Title %CMDTitle% -^> [%~1/%~2] %~3&Call :EchoX "xx:: ."&if '%ErrorLevel%' == '0' (cd.) else x_Error_x 1>nul 2>nul
Goto :eof

:Delay :: 延迟操作 <%1=Sec|延迟秒数> [%2=+|显示倒计时]。
if "%~2" == "+" (Set #=2) else Set #=1
if exist %WinDir%\System32\timeout.exe (timeout /t %~1 %#%>nul) else if exist %WinDir%\System32\choice.exe (choice /t %~1 /d y /n >nul) else ping 127.1 -n %~1 >nul
Goto :eof

:EchoX :: 显示彩色文字 (不支持半角字符 \ / : * ? " < >|. % ! ~)。
Setlocal EnableDelayedExpansion
Set echox=EchoX.exe&&!echox! 1>nul 2>nul||(Set echox=&mkdir "%TEMP%\EchoX" 2>nul&&attrib +s +h "%TEMP%\EchoX" 2>nul)
for %%a in (%*) do (
    Set "param=%%~a"&Set "color=!param:~0,2!"&(if not exist %WinDir%\System32\findstr.exe if not defined echox Set "color=xx")
    Set n=0&(if "!param:~2,2!" == "::" Set n=1)&(if "!param:~2,2!" == ".:" Set n=2)
    if !n! gtr 0 (
        if /i "!color!" == "xx" (Set /p="_!param:~4!"<nul) else (Set param=%%~nxa&if defined echox (!echox! -c !color! -n "!param:~4!") else (Pushd "%TEMP%\EchoX" 2>nul&>"!param:~4!",Set /p= <nul&findstr /a:!color! .* "!param:~4!*"&del "!param:~4!"&Popd))
        if !n! == 2 echo.
    ) else if defined param Set /p="_!param!"<nul
)
Endlocal&Goto :eof

-----BEGIN CERTIFICATE-----
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
-----END CERTIFICATE-----