rem MACRO:TextReplace
rem 注意：仅支持简单字符串替换，不支持正则表达式
rem 用法: call TextReplace "file.txt" "old" "new"

if "x%~1"=="x" goto :EOF
echo [MACRO]TextReplace %*

set "file=%~1"
set "search=%~2"
set "replace=%~3"
set "tmpfile=%~1.tmp"

rem clear temp file
type nul>"%tmpfile%"

rem read file and replace text
set "content="
for /f "delims=" %%i in ('type "%file%"') do (
    set "line=%%i"
    setlocal enabledelayedexpansion
    set "line=!line:%search%=%replace%!"
    echo !line!>>"%tmpfile%"
    endlocal
)

rem replace original file
move /y "%tmpfile%" "%file%" >nul
goto :EOF
