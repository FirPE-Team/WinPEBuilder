echo [MACRO]DelFiles %*
setlocal enabledelayedexpansion

for /f "tokens=3 delims=." %%a in ("%APP_PE_VER%") do set BUILD_NUM=%%a

if "%~2"=="" (
  set "code_file="
  set "code_word=%~1"
) else (
  set "code_file=%~1"
  set "code_word=%2"
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
  call :delfile "%%a"
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

:delfile
set "fn=%~1"

rem trim leading and trailing spaces
:trim
if "%fn:~0,1%"==" " set "fn=%fn:~1%" & goto :trim
if "%fn:~-1%"==" " set "fn=%fn:~0,-1%" & goto :trim

rem complete absolute path
if not "%fn:~0,1%"=="\" set "fn=%g_path%%fn%"

if not exist "%X%%fn%" goto :EOF

dir/ad "%X%%fn%" >nul 2>nul && (
  rem delete dir
  echo %fn%
  rd /s /q "%X%%fn%" >nul 2>nul
) || (
  rem delete file
  echo %fn%
  del /f /a /q "%X%%fn%" >nul 2>nul

  for %%F in ("%fn%") do set "name=%%~nxF"
  rem delete mui file
  if /i "%fn:~0,18%"=="\Windows\System32\" (
    if exist "%X%\Windows\System32\%APP_PE_LANG%\%name%.mui" (
      echo \Windows\System32\%APP_PE_LANG%\%name%.mui
      del /f /a /q "%X%\Windows\System32\%APP_PE_LANG%\%name%.mui" >nul 2>nul
    )
  )
  rem delete mui file (SysWOW64)
  if /i "%fn:~0,18%"=="\Windows\SysWOW64\" (
    if exist "%X%\Windows\SysWOW64\%APP_PE_LANG%\%name%.mui" (
      echo \Windows\SysWOW64\%APP_PE_LANG%\%name%.mui
      del /f /a /q "%X%\Windows\SysWOW64\%APP_PE_LANG%\%name%.mui" >nul 2>nul
    )
  )
  rem delete mun file
  if /i "%fn:~0,9%"=="\Windows\" if exist "%X%\Windows\SystemResources\%name%.mun" if not exist "%X%\Windows\System32\%name%" if not exist "%X%\Windows\SysWOW64\%name%" (
    echo \Windows\SystemResources\%name%.mun
    del /f /a /q "%X%\Windows\SystemResources\%name%.mun" >nul 2>nul
  )
)

goto :EOF
