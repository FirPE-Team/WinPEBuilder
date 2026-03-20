echo [MACRO]DelFilesEX %*
setlocal enabledelayedexpansion

for /f "tokens=3 delims=." %%a in ("%APP_PE_VER%") do set BUILD_NUM=%%a

set "g_scan_pattern=%~1"

if "%~3"=="" (
  set "code_file="
  set "code_word=%~2"
) else (
  set "code_file=%~2"
  set "code_word=%3"
)

rem single line mode
if "%code_file%"=="" (
  for /f "delims=" %%G in ("%code_word%") do set "g_path=%%~pG"
  call :parser "%code_word%"
)

rem multi line mode
set "strStartCode=goto !code_word!"
set "strEndCode=!code_word!"

if "!code_word:~0,2!"==":[" (
  set "strStartCode=!code_word!"
  set "strEndCode=goto :EOF"
)

set bCode=0
for /f "delims=" %%i in (!code_file!) do (
  set "line=%%i"
  if !bCode!==0 (
    if /i "!line!"=="!strStartCode!" set "bCode=1"
  ) else (
    if /i "!line!"=="!strEndCode!" goto :end
    if "!code_word:~0,2!"==":[" if /i "!line!"=="goto :EOF" goto :end
    call :parser "!line!"
  )
)

:end
for %%I in ("%X%%g_scan_pattern%") do set "target_dir=%%~dpI"
if not exist "!target_dir!" goto :EOF

for /f "delims=" %%f in ('dir /a-d /b "!target_dir!" 2^>nul') do (
  set "cur_name=%%f"
  if not defined keep[!cur_name!] (
    echo !cur_name!
    del /f /a /q "!target_dir!!cur_name!" 2>nul
  )
)

endlocal
echo.
goto :EOF

:parser
set "line=%~1"

rem empty line
if "%line%"=="" goto :EOF

rem comment line
if "%line:~0,1%"==";" goto :EOF

rem parse prefix
if "%line:~0,1%"=="@" (
  set "prefix=%line:~1%"
  if "!prefix!"=="-" (
    set "g_path="
    goto :EOF
  )
  if not "!prefix:~0,1!"=="\" set "prefix=\!prefix!"
  if not "!prefix:~-1!"=="\" set "prefix=!prefix!\"
  set "g_path=!prefix!"
  goto :EOF
)

rem parse version check
if /i "!line:~0,4!"=="+ver" (
  call :check_ver "!line!"
  goto :EOF
)
if "!g_ver_skip!"=="1" goto :EOF

:split_loop
for /f "tokens=1* delims=," %%a in ("%line%") do (
  set "tmp_item=%%a"
  for %%F in ("!tmp_item!") do set "keep[%%~nxF]=1"
  if "%%b" neq "" (
    set "line=%%b"
    goto :split_loop
  )
)
goto :EOF

:check_ver
set "ver_cmd=%~1"

if /i "!ver_cmd!"=="+ver*" (
  set "g_ver_skip=0"
  goto :EOF
)

set "g_ver_skip=1"

set "content=!ver_cmd:~4!"
for /f "tokens=*" %%a in ("!content!") do set "content=%%a"

if "!content!"=="*" (
  set "g_ver_skip=0"
  goto :EOF
)

set "op=" & set "target="
for /f "tokens=1,2" %%a in ("!content!") do (
  set "op=%%a" & set "target=%%b"
)

if "!op!"==">"  if %BUILD_NUM% GTR !target! set "g_ver_skip=0"
if "!op!"=="<"  if %BUILD_NUM% LSS !target! set "g_ver_skip=0"
if "!op!"==">=" if %BUILD_NUM% GEQ !target! set "g_ver_skip=0"
if "!op!"=="<=" if %BUILD_NUM% LEQ !target! set "g_ver_skip=0"
if "!op!"=="==" if %BUILD_NUM% EQU !target! set "g_ver_skip=0"
goto :EOF
