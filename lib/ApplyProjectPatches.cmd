if "x%~1"=="x" goto :EOF
set "_APP_PROJECT_PATH=%~f1"
if "%_APP_PROJECT_PATH:~-1%"=="\" set "_APP_PROJECT_PATH=%_APP_PROJECT_PATH:~0,-1%"
set "_APP_PRESET_PATH="
if not "x%~2"=="x" set "_APP_PRESET_PATH=%~f2"

if defined _APP_PRESET_PATH (
    echo [Preset] Loading %_APP_PRESET_PATH%

    rem Missing preset paths warning
    for /f "usebackq eol=# delims=" %%i in ("%_APP_PRESET_PATH%") do (
        if not exist "%_APP_PROJECT_PATH%\%%i\" (
            echo [Warning] Preset path not found: %%i
        )
    )

    rem Apply patches in preset order
    if exist "%_APP_PROJECT_PATH%\main.cmd" (
        call :applyPatch "%_APP_PROJECT_PATH%\main.cmd"
    )
    for /f "usebackq eol=# delims=" %%i in ("%_APP_PRESET_PATH%") do (
        if exist "%_APP_PROJECT_PATH%\%%i\main.cmd" (
            call :applyPatch "%_APP_PROJECT_PATH%\%%i\main.cmd"
        )
    )
    for /f "usebackq eol=# delims=" %%i in ("%_APP_PRESET_PATH%") do (
        if exist "%_APP_PROJECT_PATH%\%%i\last.cmd" (
            call :applyPatch "%_APP_PROJECT_PATH%\%%i\last.cmd"
        )
    )
    if exist "%_APP_PROJECT_PATH%\last.cmd" (
        call :applyPatch "%_APP_PROJECT_PATH%\last.cmd"
    )
    goto :EOF
) else (
    rem Apply patches in project order
    for /r "%_APP_PROJECT_PATH%" %%i in (main.cmd) do (
        call :applyPatch "%%~fi"
    )
    for /r "%_APP_PROJECT_PATH%" %%i in (last.cmd) do (
        if /i not "%%~fi"=="%_APP_PROJECT_PATH%\last.cmd" (
            call :applyPatch "%%~fi"
        )
    )
    if exist "%_APP_PROJECT_PATH%\last.cmd" (
        call :applyPatch "%_APP_PROJECT_PATH%\last.cmd"
    )
    goto :EOF
)
goto :EOF

:applyPatch
if not exist "%~1" goto :EOF
echo \033[93;46m [执行] %~1 | CmdColor.exe
pushd "%~dp1"
call "%~1"
popd
goto :EOF
