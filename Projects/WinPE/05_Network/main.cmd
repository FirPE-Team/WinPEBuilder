rem // For Samba Servers
reg add HKLM\Tmp_System\ControlSet001\Control\Lsa /v LmCompatibilityLevel /t REG_DWORD /d 2 /f

if not exist "%X_SYS%\wlanapi.dll" (
  call WinPE-WiFi-Package.cmd
)

rem full registry regist
reg add "HKLM\Tmp_SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\Capabilities\wlanLocationBypass" /v RequireWindowsCert /t REG_DWORD /d 0 /f

call full_functional.cmd
