rem set "RunAs"="Interactive User" -* "RunAs"=""
rem regfind.exe -p HKEY_LOCAL_MACHINE\Tmp_SOFTWARE -y Interactive User -r > nul 2>&1

echo REGEDIT4 > "%APP_TMP_PATH%\RunAsUpdateTmp.reg"
echo. >> "%APP_TMP_PATH%\RunAsUpdateTmp.reg"
for /F %%i IN ('Reg Query HKLM\Tmp_Software\Classes\AppID /s /f "Interactive User" ^|%findcmd% Tmp_Software') do (
    echo [%%i]
    echo "RunAs"=""
) >> "%APP_TMP_PATH%\RunAsUpdateTmp.reg"
reg import "%APP_TMP_PATH%\RunAsUpdateTmp.reg"
