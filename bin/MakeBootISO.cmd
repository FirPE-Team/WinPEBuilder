@echo off

set APP_ISO_LABEL=BOOTPE
set APP_ISO_NAME=%APP_PROJECT%
if "x%ISO_DIR%"=="x" (
  echo Can't find the ISO_DIR.
  goto :EOF
)

if "x%APP_PROJECT%"=="x" (
  echo Can't find the APP_PROJECT.
  goto :EOF
)

if "x%APP_TMP_PATH%"=="x" (
  set "APP_TMP_PATH=%APP_ROOT%\target\%APP_PROJECT%\Temp"
)

rem auto create the _ISO_
call :MKPATH "%ISO_DIR%\sources\"
if not exist "%ISO_DIR%\bootmgr" (
  if exist "%APP_SRC_FOLDER%\boot" (
    xcopy /E /Y "%APP_SRC_FOLDER%\boot" "%ISO_DIR%\boot\"
    xcopy /E /Y "%APP_SRC_FOLDER%\efi" "%ISO_DIR%\efi\"
    copy /y "%APP_SRC_FOLDER%\bootmgr" "%ISO_DIR%\"
    copy /y "%APP_SRC_FOLDER%\bootmgr.efi" "%ISO_DIR%\"
  )
)

call :MKPATH "%ISO_DIR%\boot\"
if not exist "%ISO_DIR%\boot\etfsboot.com" (
  copy /y "%APP_ROOT%\bin\etfsboot.com" "%ISO_DIR%\boot\"
)

copy /y "%BUILD_WIM%" "%ISO_DIR%\sources\boot.wim"

rem call _CustomISO_
call :CustomISO

set EFI_BIN=efisys_noprompt.bin
ren "%ISO_DIR%\boot\bootfix.bin" bootfix.bin.bak
if exist "%ISO_DIR%\efi\Microsoft\boot\%EFI_BIN%" (
  oscdimg.exe -bootdata:2#p0,e,b"%ISO_DIR%\boot\etfsboot.com"#pEF,e,b"%ISO_DIR%\efi\Microsoft\boot\%EFI_BIN%" -h -l"%APP_ISO_LABEL%" -m -u2 -udfver102 "%ISO_DIR%" "%APP_ROOT%\target\%APP_PROJECT%\%APP_ISO_NAME%.iso"
) else (
  oscdimg.exe -b"%ISO_DIR%\boot\etfsboot.com" -h -l"%APP_ISO_LABEL%" -m -u2 -udfver102 "%ISO_DIR%" "%APP_ROOT%\target\%APP_PROJECT%\%APP_ISO_NAME%.iso"
)

echo \033[96mISO Created -* %APP_ROOT%\target\%APP_PROJECT%\%APP_ISO_NAME%.iso | cmdcolor.exe
set "APP_ISO_PATH=%APP_ROOT%\target\%APP_PROJECT%\%APP_ISO_NAME%.iso"
if ERRORLEVEL 1 (
  set APP_ISO_PATH=
  echo make boot iso failed.
) else (
  echo make boot iso successfully.
)
goto :EOF

:MKPATH
if not exist "%~dp1" mkdir "%~dp1"
goto :EOF

:CustomISO
rem set default boot to Legacy
bcdedit.exe /store "%ISO_DIR%\boot\bcd" /set {default} bootmenupolicy Legacy
goto :EOF
