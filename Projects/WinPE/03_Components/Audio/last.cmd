rem 修复音量混合器对话框中无法识别的字符
rem // reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontLink\SystemLink" /v "Microsoft YaHei UI"
if "%APP_PE_LANG%"=="zh-CN" copy /y Malgun.ttf "%X_WIN%\Fonts\"

rem --no-sandbox option
reg add "HKLM\Tmp_Software\Policies\Google\Chrome" /v "AudioSandboxEnabled" /t REG_DWORD /d 0 /f
reg add "HKLM\Tmp_Software\Wow6432Node\Policies\Google\Chrome" /v "AudioSandboxEnabled" /t REG_DWORD /d 0 /f

reg add "HKLM\Tmp_Software\Policies\Microsoft\Edge" /v "AudioSandboxEnabled" /t REG_DWORD /d 0 /f
reg add "HKLM\Tmp_Software\Wow6432Node\Policies\Microsoft\Edge" /v "AudioSandboxEnabled" /t REG_DWORD /d 0 /f

SetACL.exe -on "HKLM\Tmp_Software\Policies" -ot reg -actn ace -ace "n:S-1-1-0;p:full"
SetACL.exe -on "HKLM\Tmp_Software\Wow6432Node\Policies" -ot reg -actn ace -ace "n:S-1-1-0;p:full"

if %VER[3]% GEQ 22621 call :AudioSrvPatch_22621
if exist "%X_SYS%\AudioSrvPolicyManager.dll.org" del /f /q "%X_SYS%\AudioSrvPolicyManager.dll.org"
goto :EOF

:AudioSrvPatch_22621
call :AudioSrvPatch -s "83 FB 01 0F 84 92 00 00 00" -r "83 FB 01 E9 93 00 00 00 00"
if %errorlevel% EQU 1 goto :EOF

:AudioSrvPatch_22621_900later
call :AudioSrvPatch -s "83 FE 01 74 FF" -S "FF FF FF FF 00" -r "83 FE 01 EB FF" -R "FF FF FF FF 00"
if %errorlevel% EQU 1 goto :EOF

:AudioSrvPatch_25300
call :AudioSrvPatch -s "83 FF 01 74 FF" -S "FF FF FF FF 00" -r "83 FF 01 EB FF" -R "FF FF FF FF 00"
if %errorlevel% EQU 1 goto :EOF
goto :EOF

:AudioSrvPatch
binmay.exe  -u "%X_SYS%\AudioSrvPolicyManager.dll" %*
fc /b "%X_SYS%\AudioSrvPolicyManager.dll" "%X_SYS%\AudioSrvPolicyManager.dll.org"
goto :EOF
