if "x%_WINXSHELL_COPIED%"=="x1" goto :EOF
call X2X
ren "%X_PF%\WinXShell\WinXShell_%APP_PE_ARCH%.exe" WinXShell.exe
ren "%X_PF%\WinXShell\WinXShellC_%APP_PE_ARCH%.exe" WinXShellC.exe
del /q "%X_PF%\WinXShell\WinXShell*_*.exe"

set _WINXSHELL_COPIED=1
