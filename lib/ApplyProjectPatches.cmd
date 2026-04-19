if "x%~1"=="x" goto :EOF
set "project_path=%~f1"
if "%project_path:~-1%"=="\" set "project_path=%project_path:~0,-1%"

for /r "%project_path%" %%i in (.) do (
    if exist "%%~fi\main.cmd" (
        echo \033[93;46m [执行] %%~fi\main.cmd | CmdColor.exe
        pushd "%%~fi"
        call "%%~fi\main.cmd"
        popd
    )
)

for /r "%project_path%" %%i in (.) do (
    if /i not "%%~fi"=="%project_path%" (
        if exist "%%~fi\last.cmd" (
            echo \033[93;46m [执行] %%~fi\last.cmd | CmdColor.exe
            pushd "%%~fi"
            call "%%~fi\last.cmd"
            popd
        )
    )
)

if exist "%project_path%\last.cmd" (
    echo \033[93;46m [执行] %project_path%\last.cmd | CmdColor.exe
    pushd "%project_path%"
    call "%project_path%\last.cmd"
    popd
)
