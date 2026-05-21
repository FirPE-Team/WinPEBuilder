echo [MACRO]AddEnv %*
setlocal EnableExtensions DisableDelayedExpansion

set "raw_path=%~1"
if not defined raw_path goto :EOF
call :NORMALIZE_PATH raw_path

reg add "HKLM\Tmp_DEFAULT\Environment" /f >nul 2>&1

set "current_path="
for /f "tokens=2*" %%a in ('reg query "HKLM\Tmp_DEFAULT\Environment" /v "Path" 2^>nul') do set "current_path=%%b"
if defined current_path (
    set "new_path=%current_path%;%raw_path%"
) else (
    set "new_path=%raw_path%"
)

reg add "HKLM\Tmp_DEFAULT\Environment" /v "Path" /t REG_SZ /d "%new_path%" /f >nul
goto :EOF

:NORMALIZE_PATH
setlocal EnableDelayedExpansion
set "value=!%~1!"
if defined X_PF(x86) set "value=!value:%X_PF(x86)%=X:\Program Files (x86)!"
if defined X_PF set "value=!value:%X_PF%=X:\Program Files!"
if defined X_WOW64 set "value=!value:%X_WOW64%=X:\Windows\SysWOW64!"
if defined X_SYS set "value=!value:%X_SYS%=X:\Windows\System32!"
if defined X_WIN set "value=!value:%X_WIN%=X:\Windows!"
if defined X set "value=!value:%X%=X:!"

set "value=!value:%%X_PF%%=X:\Program Files!"
set "value=!value:%%X_PF(x86)%%=X:\Program Files (x86)!"
set "value=!value:%%X_WOW64%%=X:\Windows\SysWOW64!"
set "value=!value:%%X_SYS%%=X:\Windows\System32!"
set "value=!value:%%X_WIN%%=X:\Windows!"
set "value=!value:%%X%%=X:!"

endlocal & set "%~1=%value%"
goto :EOF
