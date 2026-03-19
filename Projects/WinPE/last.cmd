echo Update registry (C:\ =^> X:\) ...
regfind.exe -p HKEY_LOCAL_MACHINE\Tmp_SOFTWARE -y C:\ -y -r X:\ > nul 2>&1
regfind.exe -p HKEY_LOCAL_MACHINE\Tmp_SOFTWARE -y D:\ -y -r X:\ > nul 2>&1
regfind.exe -p HKEY_LOCAL_MACHINE\Tmp_SOFTWARE -y  X:\$windows.~bt\ -r  X:\ > nul 2>&1
regfind.exe -p HKEY_LOCAL_MACHINE\Tmp_SYSTEM -y  X:\$windows.~bt\ -r  X:\ > nul 2>&1

set Check_SysWOW64=0
if exist "%X_WIN%\SysWOW64\wow32.dll" set Check_SysWOW64=1

rem remove usless mui & mun files
if not exist "%X_WIN%\SystemResources" goto :END_DEL_MUN

for /f %%i in ('dir /a-d /b "%X_WIN%\SystemResources"') do (
  if not exist "%X_SYS%\%%~ni" (
    if %Check_SysWOW64% EQU 0 (
      call :DELEX "/f /a /q" "%X_WIN%\SystemResources\%%i" "Remove orphan "
    ) else (
      if not exist "%X_WIN%\SysWOW64\%%~ni" (
        call :DELEX "/f /a /q" "%X_WIN%\SystemResources\%%i" "Remove orphan "
      )
    )
  )
)
:END_DEL_MUN
rem ignore *.msc files
for /f %%i in ('dir /a-d /b "%X_SYS%\%APP_PE_LANG%\*.mui"') do (
  if not exist "%X_SYS%\%%~ni" (
    call :DELEX "/f /a /q" "%X_SYS%\%APP_PE_LANG%\%%i" "Remove orphan "
  )
)
if %Check_SysWOW64% EQU 0 goto :END_DEL_MUI

for /f %%i in ('dir /a-d /b "%X_WIN%\SysWOW64\%APP_PE_LANG%\*.mui"') do (
  if not exist "%X_WIN%\SysWOW64\%%~ni" (
    call :DELEX "/f /a /q" "%X_WIN%\SysWOW64\%APP_PE_LANG%\%%i" "Remove orphan "
  )
)

:END_DEL_MUI
goto :EOF

:DELEX
if exist "%~2" (
  if not "x%~3"=="x" echo %~3%~2
  del %~1 "%~2"
)
goto :EOF
