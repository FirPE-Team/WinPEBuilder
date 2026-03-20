if "x%~1"=="x" goto :EOF
set "project_path=%~1"

for /r "%project_path%" %%i in (.) do (
    if exist "%%~fi\main.cmd" (
        echo \033[93;46m [执行] %%~fi\main.cmd | CmdColor.exe
        pushd "%%~fi"
        call "%%~fi\main.cmd"
        popd
    )
)

for /r "%project_path%" %%i in (.) do (
    if exist "%%~fi\last.cmd" (
        echo \033[93;46m [执行] %%~fi\last.cmd | CmdColor.exe
        pushd "%%~fi"
        call "%%~fi\last.cmd"
        popd
    )
)
