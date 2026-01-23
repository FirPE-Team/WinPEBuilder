@echo off

if not "%1"=="" call :%* && goto :eof

:setWinPEDrive
set "USBDrive="
if exist "X:\Users\usbdrive.txt" (
  for /f "delims=" %%u in (X:\Users\usbdrive.txt) do (
    if exist %%u:\FirPE (
      set "USBDrive=%%u:\FirPE"
      set "ConfigPath=%%u:\FirPE\config.ini"
      set "CustomHooks=%%u:\FirPE\Hooks"
      goto :eof
    )
    del "X:\Users\usbdrive.txt"
  )
)

for %%u in (Z Y X W V U T S R Q P O N M L K J I H G F E D C) do (
  if exist "%%u:\FirPE\" (
    for /f "delims=" %%a in ('dir /b /a "%%u:\FirPE\" 2^>nul') do (
      call :log WinPE初始化 使用%%u:\作为WinPE自定义目录
      set "USBDrive=%%u:\FirPE"
      set "ConfigPath=%%u:\FirPE\config.ini"
      set "CustomHooks=%%u:\FirPE\Hooks"
      echo %%u>"X:\Users\usbdrive.txt"
      goto :eof
    )
  )
)
goto :eof

:getAction
rem 获取BCD启动参数（LoadOptionsString）
for /f "tokens=3*" %%a in ('REG QUERY "HKLM\SYSTEM\ControlSet001\Control" /v SystemStartOptions') do set action=%%a
goto :eof

:readini
rem 读取ini配置文件
rem 参数1：ini文件
rem 参数2：配置名
rem 参数3：配置项
rem 参数4：默认值
rem 返回值：value

if not exist "%~1" (
  set value=%~4
  goto :eof
)
set file=%~1
set area=[%~2]
set key=%~3
set currarea=
for /f "usebackq delims=" %%a in ("!file!") do (
  set ln=%%a
  if "x!ln:~0,1!"=="x[" (
      set currarea=!ln!
  ) else (
  for /f "tokens=1,2 delims==" %%b in ("!ln!") do (
      set currkey=%%b
      set value=%%c
      if "x!area!"=="x!currarea!" if "x!key!"=="x!currkey!" (
          rem echo !value!
          goto :eof
      )
    )
  )
)
set value=%~4
goto :eof

:log
rem 日志，使用方法：call common Log 日志类别 日志内容。注意：如参数有空格则需要使用引号
echo %time% %~1-%~2 >>X:\Users\Log.txt
goto :eof

:tips
rem 显示右下角提示
rem 参数1：标题
rem 参数2：内容
rem 参数3：延时时间
PECMD TIPS ""
start "" PECMD "TEAM TIPS %~1,%~2,%3,4, | WAIT %3"
goto :eof

:AutoInstallSystem
set imageName=%~1
set imageIndex=%2
set quiet=%3
set action=%4

rem 查找系统分区
for %%i in (C D E F G H I J K L M N O P Q R S T U V W Y Z) DO (
  if exist %%i:\windows\system32\cmd.exe (
    set /a n+=1	
    set xtp=%%i
  )
)
rem 系统盘不存在
if !n!a == a (
  echo 未检测到系统盘，按任意键退出程序
  pause>nul
  exit
)
rem 存在多个系统盘
if !n! GTR 1 (
  echo 检测到!n!个系统盘，程序无法自动处理，按任意键退出程序
  pause>nul
  exit
)

rem 搜索镜像文件
for %%d in (Z Y X W V U T S R Q P O N M L K J I H G F E D C) do (
  rem 搜索所有盘根目录
  for /f "delims=" %%f in ('dir /b "%%d:\*.wim" "%%d:\*.esd" "%%d:\*.gho" 2^>nul') do (
    if "%imageName%" == "%%f" set imageFile=%%d:\%%f
  )
  
  rem 搜索一级目录
  for /f "delims=" %%r in ('dir /ad /b "%%d:\*"2^>nul') do (
    for /f "delims=" %%f in ('dir /a-d-h/b "%%d:\%%r\*.wim" "%%d:\%%r\*.esd" "%%d:\%%r\*.gho" 2^>nul') do (
      if /I "%imageName%" == "%%f" set imageFile=%%d:\%%r\%%f
    )
  )
)
rem 镜像文件不存在
if not exist "%imageFile%" (
  echo 检测到指定映像不存在，按任意键退出程序
  pause>nul
  exit
)
echo 即将自动重装镜像："%imageFile%" 到系统盘: "%xtp%:"

if %quiet%==1 ( 
    echo 注意: 本程序将在2分钟后自动进行操作......
    PECMD WAIT 120000
) else (
    echo 请按任意键确认
    pause>nul
    echo 再次确认，此操作将重装系统盘: "%xtp%:", 请注意备份资料, 按任意键继续
    pause>nul
)

rem 生成CGI配置文件
set CGIProgramPath="%ProgramFiles(x86)%\备份还原\CGI.exe"
set CGIConfigPath="%ProgramFiles(x86)%\备份还原\CGI.ini"

if exist %CGIConfigPath% del /q %CGIConfigPath%

echo [operation]>%CGIConfigPath%
rem restore: 还原分区，backup: 备份分区
echo action=restore>>%CGIConfigPath%
echo silent=1 >>%CGIConfigPath%

echo [source]>>%CGIConfigPath%
echo %imageFile%^|^%imageIndex%>>%CGIConfigPath%

echo [destination]>>%CGIConfigPath%
rem 目标分区的盘符
echo DriveLetter = %xtp%:>>%CGIConfigPath%

echo [miscellaneous]>>%CGIConfigPath%
rem format: 是否快速格式化目标分区 0: 不格式化 1: 格式化 默认: 0
echo format=1 >>%CGIConfigPath%
rem 修复引导
echo fixboot=auto>>%CGIConfigPath%
rem 完成后是否关机/重启 0: 无动作 1: 关机 2: 重启 默认: 0
echo shutdown=%action% >>%CGIConfigPath%

rem 开始恢复系统
%CGIProgramPath% %CGIConfigPath%

goto :eof
