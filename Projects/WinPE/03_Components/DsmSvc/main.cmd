rem ==========update filesystem==========

call AddFiles %0 :end_files
goto :end_files

\Windows\System32\DDOres.dll
\Windows\System32\DeviceCenter.dll
\Windows\System32\DeviceEject.exe
\Windows\System32\DeviceSetupManager.dll
\Windows\System32\DeviceSetupManagerAPI.dll
\Windows\System32\DeviceSetupStatusProvider.dll
\Windows\System32\DevPropMgr.dll
\Windows\System32\StorageContextHandler.dll

:end_files

rem ==========update registry==========

call RegCopy HKLM\SYSTEM\ControlSet001\Services\DsmSvc
reg add HKLM\Tmp_SYSTEM\Setup\AllowStart\DsmSvc /f

rem display info
call RegCopy "HKLM\Software\Microsoft\Windows NT\CurrentVersion\DeviceDisplayObjects"

rem DsmSvc Patch Feature
binmay.exe -u "%X_SYS%\DeviceSetupManager.dll" -s u:SystemSetupInProgress -r u:DisableDeviceSetupMgr
fc /b "%X_SYS%\DeviceSetupManager.dll.org" "%X_SYS%\DeviceSetupManager.dll"
del /f /q "%X_SYS%\DeviceSetupManager.dll.org"

if "%APP_PE_ARCH%"=="x64" (
  binmay.exe -u "%X_SYS%\DeviceSetupManager.dll" -s "81 FE 20 03 00 00" -r "81 FE 02 00 00 00"
) else (
  binmay.exe -u "%X_SYS%\DeviceSetupManager.dll" -s "45 F8 3D 20 03 00 00" -r "45 F8 3D 02 00 00 00"
)
fc /b "%X_SYS%\DeviceSetupManager.dll.org" "%X_SYS%\DeviceSetupManager.dll"
del /f /q "%X_SYS%\DeviceSetupManager.dll.org"
