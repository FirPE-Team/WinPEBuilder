echo Update APP_PE_BUILD, VER[] environment variables with %APP_SRC%
for /f "tokens=3 usebackq" %%i in (`reg query "HKLM\Src_SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v CurrentBuild`) do set /a VER[3]=%%i

for /f "tokens=3 usebackq" %%i in (`reg query "HKLM\Src_SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v UBR`) do set /a APP_PE_BUILD=%%i
set VER[4]=%APP_PE_BUILD%
set VER[3.4]=%VER[3]%.%VER[4]%

set VER
