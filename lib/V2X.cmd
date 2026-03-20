echo [MACRO]V2X.cmd %*
rem      V2X.cmd -init
rem      V2X.cmd name [-extract|-copy|-xcopy|version] ...

if "x%_V_xArch%"=="x" call :INIT_VARCHS
if /i "x%~1"=="x-init" goto :EOF

set "_V_Name=%~1"
set _V_Ver=*
set _V_File=

if "x%~2"=="x" set _V_Ver=*

if not "x%_V_Name%"=="x" (
    pushd "%V%\%_V_Name%"
) else (
  pushd "%V%"
)

if /i "x%~2"=="x-extract" call :ACT_EXTRACT "%~3" "%~4" && goto :ACT_END
if /i "x%~2"=="x-copy" call :ACT_COPY "%~3" "%~4" "%~5" && goto :ACT_END
if /i "x%~2"=="x-xcopy" call :ACT_XCOPY "%~3" "%~4" "%~5" && goto :ACT_END

:ACT_END

if not "x%_V_Name%"=="x" (
    if exist main.cmd call "%V%\%_V_Name%\main.cmd" %*
)

popd
goto :EOF

:INIT_VARCHS
set _V_xArch=%APP_PE_ARCH%
set _Vx8664=%_V_xArch%
set _V8664=86
set _V3264=32
set _V64=
set _V-64=
set _V_64=
set _Vx64=
set _V-x64=
set _V_x64=

if "%_V_xArch%"=="x64" (
    set _V8664=64
    set _V3264=64
    set _V64=64
    set _V-64=-64
    set _V_64=_64
    set _Vx64=x64
    set _V-x64=-x64
    set _V_x64=_x64
)
set _V
goto :EOF

:ACT_GETFILE
set "_V_Pat=%~1"
if "x%_V_Ver%"=="x*" (
  for /f "delims=" %%i in ('dir /b /on "%_V_Pat%"') do (
      set "_V_File=%%i"
  )
) else (
  set "_V_File=%_V_Pat%"
)
goto :EOF

:ACT_EXTRACT
call :ACT_GETFILE "%~1"
call Extract2X "%_V_File%" "%~2"
goto :EOF

:ACT_COPY
copy %~3 "%~1" "%~2"
goto :EOF

:ACT_XCOPY
xcopy %~3 "%~1" "%~2"
goto :EOF