rem MACRO:RunHooks
rem     call RunHooks <hook-file-name>

if "x%~1"=="x" goto :EOF

if exist "%PROJECT_PATH%\%~1" (
  echo \033[93;46m [Hook] %~1 | CmdColor.exe
  call "%PROJECT_PATH%\%~1"
)
goto :EOF
