Del /A /F /Q "%X%\Windows\System32\OpenWith.exe"
Del /A /F /Q "%X%\Windows\System32\zh-CN\OpenWith.exe.mui"

if not "%APP_PE_ARCH%"=="x64" (
  copy /y "%~dp0x86\*" "%X%\Windows\System32"
) else (
  copy /y "%~dp0x64\*" "%X%\Windows\System32"
)

rem need VC9 Runtime
call AddFiles \Windows\System32\winhttp.dll
reg import OpenWith.reg