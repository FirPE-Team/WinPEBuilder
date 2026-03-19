echo [MACRO]AddFiles %*

if "x%ADDFILES_INITED%"=="x" (
  wimlib-imagex.exe dir "%APP_SRC%" %APP_SRC_INDEX% --path=\Windows\System32\%APP_PE_LANG%\ >"%APP_TMP_PATH%\AddFiles_SYSMUI.txt"
  wimlib-imagex.exe dir "%APP_SRC%" %APP_SRC_INDEX% --path=\Windows\SysWOW64\%APP_PE_LANG%\ >>"%APP_TMP_PATH%\AddFiles_SYSMUI.txt"
  for /f "delims=" %%i in ('type "%APP_TMP_PATH%\AddFiles_SYSMUI.txt"') do set "MUI_LIST[%%i]=1"
  
  rem *.mun files present from 19H1
  if exist "%X%\Windows\SystemResources\shell32.dll.mun" (
    wimlib-imagex.exe dir "%APP_SRC%" %APP_SRC_INDEX% --path=\Windows\SystemResources\ >"%APP_TMP_PATH%\AddFiles_SYSRES.txt"
    for /f "delims=" %%i in ('type "%APP_TMP_PATH%\AddFiles_SYSRES.txt"') do set "MUN_LIST[%%i]=1"
  )
  set ADDFILES_INITED=1
)

setlocal enabledelayedexpansion

for /f "tokens=3 delims=." %%a in ("%APP_PE_VER%") do set BUILD_NUM=%%a

type nul>"%APP_TMP_PATH%\AddFiles.txt"

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

type "%APP_TMP_PATH%\AddFiles.txt
echo.

rem extract AddFiles.txt to mounted directory with wimlib
wimlib-imagex.exe extract %APP_SRC% %APP_SRC_INDEX% @"%APP_TMP_PATH%\AddFiles.txt" --dest-dir="%X%" --no-acls --nullglob
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
  call :addfile "%%a"
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

:addfile
set fn=%~1

rem trim leading and trailing spaces
:trim
if "%fn:~0,1%"==" " set "fn=%fn:~1%" & goto :trim
if "%fn:~-1%"==" " set "fn=%fn:~0,-1%" & goto :trim

rem complete absolute path
if not "%fn:~0,1%"=="\" set fn=%g_path%%fn%

rem write to extract list file
echo %fn%>>"%APP_TMP_PATH%\AddFiles.txt"

rem handle MUI and MUN
echo "%fn%" | findstr /c:"*" /c:"?" >nul && goto :EOF
for %%F in ("%fn%") do set "name=%%~nxF"

rem append mui file
set muifile=
if /i "%fn:~0,18%"=="\Windows\System32\" set "muifile=\Windows\System32\%APP_PE_LANG%\%name%.mui"
if /i "%fn:~0,18%"=="\Windows\SysWOW64\" set "muifile=\Windows\SysWOW64\%APP_PE_LANG%\%name%.mui"
if not "%muifile%"=="" (
  rem findstr /i /c:"!muifile!" "%APP_TMP_PATH%\AddFiles_SYSMUI.txt">nul && echo !muifile!>>"%APP_TMP_PATH%\AddFiles.txt"
  if defined MUI_LIST[!muifile!] echo !muifile!>>"%APP_TMP_PATH%\AddFiles.txt"
)

rem append mun file
if /i "%fn:~0,18%"=="\Windows\System32\" (
  set "munfile=\Windows\SystemResources\%name%.mun"
  rem findstr /i /c:"!munfile!" "%APP_TMP_PATH%\AddFiles_SYSRES.txt">nul && echo !munfile!>>"%APP_TMP_PATH%\AddFiles.txt"
  if defined MUN_LIST[!munfile!] echo !munfile!>>"%APP_TMP_PATH%\AddFiles.txt"
)

goto :EOF
