echo [MACRO]AddEnvVar %*

setlocal enabledelayedexpansion
set "raw_path=%~1"

rem Convert absolute build paths to relative WinPE paths
if defined X set "raw_path=!raw_path:%X%=X!"
if defined X_WIN set "raw_path=!raw_path:%X_WIN%=X:\Windows!"
if defined X_SYS set "raw_path=!raw_path:%X_SYS%=X:\Windows\System32!"
if defined X_WOW64 set "raw_path=!raw_path:%X_WOW64%=X:\Windows\SysWOW64!"
if defined X_PF set "raw_path=!raw_path:%X_PF%=X:\Program Files!"
if defined X_PF86 set "raw_path=!raw_path:%X_PF86%=X:\Program Files (x86)!"

rem Handling cases of delayed expansion with double percent signs
set "replace_list=%%X_PF%%=X:\Program Files;%%X_PF(x86)%%=X:\Program Files (x86);%%X_WIN%%=X:\Windows;%%X_SYS%%=X:\Windows\System32;%%X_WOW64%%=X:\Windows\SysWOW64;%%X%%=X:"
for %%m in ("!replace_list:;=" "!") do (
  for /f "tokens=1,2 delims==" %%a in (%%m) do set "raw_path=!raw_path:%%a=%%b!"
)

reg add "HKLM\Tmp_DEFAULT\Environment" /f >nul 2>&1

set "current_path="
for /f "tokens=2*" %%a in ('reg query "HKLM\Tmp_DEFAULT\Environment" /v "Path" 2^>nul') do (
  set "current_path=%%b"
)

if defined current_path (
  set "new_path=!current_path!;!raw_path!"
) else (
  set "new_path=!raw_path!"
)

reg add "HKLM\Tmp_DEFAULT\Environment" /v "Path" /t REG_SZ /d "!new_path!" /f

endlocal
