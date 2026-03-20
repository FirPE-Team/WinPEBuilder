if not exist "%X_WIN%\WinSxS\Catalogs\" mkdir "%X_WIN%\WinSxS\Catalogs"

call ACLRegKey Tmp_System
call ACLRegKey Tmp_Software
call ACLRegKey Tmp_Default
rem call ACLRegKey Tmp_Drivers

rem make things easy with Everyone(S-1-1-0)
rem AFAIK, FDResPub service needs the right(LOCAL SERVICE), otherwise fail to start
SetACL.exe -on "HKLM\Tmp_SYSTEM" -ot reg -actn ace -ace "n:S-1-1-0;p:full"

call RegCopy HKLM\Software\Classes\AppID
call ACLRegKey HKLM\Software\Classes\AppID

call RegCopy HKLM\Software\Classes\CLSID
call RegCopy HKLM\Software\Classes\Interface
call RegCopy HKLM\Software\Classes\TypeLib
rem //-
call RegCopy HKLM\Software\Classes\Folder
call RegCopy HKLM\Software\Classes\themefile
call RegCopy HKLM\Software\Classes\SystemFileAssociations
rem //-
call RegCopy "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Svchost"
call RegCopy HKLM\Software\Microsoft\SecurityManager
call RegCopy HKLM\Software\Microsoft\Ole

rem // WLAN AutoConfig
reg add "HKLM\Tmp_Software\Microsoft\Windows NT\CurrentVersion\Svchost" /v WlansvcGroup /t REG_MULTI_SZ /d wlansvc\0 /f

rem // policymanager.dll need:
call RegCopy HKLM\Software\Microsoft\PolicyManager
rem call RegCopy HKLM\Software\Classes\Unknown

rem show right version info for 23H2 and later
call RegCopy HKLM\System\Software\Microsoft\BuildLayers

call RegCopy HKLM\System\DriverDatabase
call RegCopy HKLM\Drivers\DriverDatabase

call "%~dp0Catalog.cmd"
