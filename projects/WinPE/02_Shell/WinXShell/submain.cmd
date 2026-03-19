call V2X WinXShell
md "%X%\Program Files\WinXShell\%APP_PE_LANG%"
copy /y "%X_SYS%\%APP_PE_LANG%\systemcpl.dll.mui" "%X%\Program Files\WinXShell\%APP_PE_LANG%\"

reg add "HKLM\Tmp_SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Shell /t REG_SZ /d WinXShell.exe /f

rem Grant right for Administrator
call ACLRegKey "Tmp_Software\Classes\ms-settings"
call ACLRegKey Tmp_Software\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}

copy /y "WinXShell.jcfg" "%X%\Program Files\WinXShell\"
