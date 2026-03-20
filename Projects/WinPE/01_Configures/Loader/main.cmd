if exist "%~dp0winpeshl.ini" (
    copy /y "%~dp0winpeshl.ini" "%X_SYS%\"
    goto :EOF
)

call V2X PECMD -Copy "Pecmd_%_Vx8664%.exe" "%X_SYS%\Pecmd.exe"

rem 如果有 PECMD 配置文件，复制到 System32
if exist "%~dp0Pecmd.ini" (
    copy /y "%~dp0Pecmd.ini" "%X_SYS%\"

    rem 使用 PECMD 接管PE初始化
    reg add "HKLM\Tmp_SYSTEM\Setup" /v "CmdLine" /t REG_SZ /d "Pecmd.exe Main %%Windir%%\System32\Pecmd.ini" /f
)

rem 关联 WCS 文件类型
reg import WcsAssoc.reg
