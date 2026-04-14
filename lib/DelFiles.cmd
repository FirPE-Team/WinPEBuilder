echo [MACRO]DelFiles %*
setlocal enabledelayedexpansion

for /f "tokens=3 delims=." %%a in ("%APP_PE_VER%") do set BUILD_NUM=%%a
set "g_if_skip=0"
set "g_syswow64="

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
  goto :end
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

rem parse if condition
if /i "!line:~0,3!"=="+if" (
  call :check_if !line:~4!
  if !ERRORLEVEL! EQU 0 (
    set "g_if_skip=0"
  ) else (
    set "g_if_skip=1"
  )
  goto :EOF
)
if /i "!line!"=="-if" (
  set "g_if_skip=0"
  goto :EOF
)
if "!g_if_skip!"=="1" goto :EOF

rem parse syswow64 toggle
if /i "!line!"=="+syswow64" (
  set "g_syswow64=\Windows\SysWOW64\"
  goto :EOF
)
if /i "!line!"=="-syswow64" (
  set "g_syswow64="
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

:check_if
if %* (
  exit /b 0
) else (
  exit /b 1
)

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
if "%fn:~-1%"=="\" set "fn=%fn:~0,-1%"

rem complete absolute path
if not "%fn:~0,1%"=="\" set "fn=%g_path%%fn%"

if not exist "%X%%fn%" goto :EOF
if exist "%X%%fn%\" (
  rem delete dir
  echo %fn%
  rd /s /q "%X%%fn%" >nul 2>nul
) else if exist "%X%%fn%" (
  rem delete file
  echo %fn%
  del /f /a /q "%X%%fn%" >nul 2>nul

  rem delete syswow64 version
  if not "%g_syswow64%"=="" if exist "%X%%g_syswow64%\!fn:~18!" (
    echo %g_syswow64%!fn:~18!
    del /f /a /q "%X%%g_syswow64%!fn:~18!" >nul 2>nul
  )

  rem delete mui file
  set muifile=
  if /i "%fn:~0,18%"=="\Windows\System32\" set "muifile=\Windows\System32\%APP_PE_LANG%\!fn:~18!.mui"
  if /i "%fn:~0,18%"=="\Windows\SysWOW64\" set "muifile=\Windows\SysWOW64\%APP_PE_LANG%\!fn:~18!.mui"
  if not "%muifile%"=="" if exist "%X%%muifile%" (
    echo %muifile%
    del /f /a /q "%X%%muifile%" >nul 2>nul
  )
  if not "%g_syswow64%"=="" if exist "%X%%g_syswow64%%APP_PE_LANG%\!fn:~18!.mui" (
    echo %g_syswow64%%APP_PE_LANG%\!fn:~18!.mui
    del /f /a /q "%X%%g_syswow64%%APP_PE_LANG%\!fn:~18!.mui" >nul 2>nul
  )

  rem delete mun file
  if /i "%fn:~0,9%"=="\Windows\" if exist "%X%\Windows\SystemResources\!fn:~18!.mun" if not exist "%X%\Windows\System32\!fn:~18!" if not exist "%X%\Windows\SysWOW64\!fn:~18!" (
    echo \Windows\SystemResources\!fn:~18!.mun
    del /f /a /q "%X%\Windows\SystemResources\!fn:~18!.mun" >nul 2>nul
  )
)

goto :EOF
