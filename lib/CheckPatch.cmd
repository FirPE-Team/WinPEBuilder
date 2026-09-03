set "HasPatch=true"

if "%~1"=="" exit /b 1
if not defined APP_PRESET_FILE exit /b 1

set "HasPatch=false"
for /f "usebackq eol=# delims=" %%i in ("%APP_PRESET_FILE%") do (
    if /i "%%i"=="%~1" (
        set "HasPatch=true"
        exit /b 1
    )
)
exit /b 0
