rem MMC base

rem ==========add files==========

call AddFiles %0 :end_files
goto :end_files

\Windows\System32\mmc.exe
\Windows\System32\mmcbase.dll
\Windows\System32\mmcndmgr.dll
\Windows\System32\mmcshext.dll

; mmc resources
\Windows\System32\filemgmt.dll
\Windows\System32\OnDemandConnRouteHelper.dll

; DevMgr
\Windows\System32\devmgmt.msc
\Windows\System32\%APP_PE_LANG%\devmgmt.msc
\Windows\System32\devmgr.dll

; SrvMgr
\Windows\System32\services.msc
\Windows\System32\%APP_PE_LANG%\services.msc

:end_files
call CompMgr.cmd
call DiskMgr.cmd

rem ==========update registry==========

rem Classes\AppID,CLSID,Interface,TypeLib already copied
reg add HKLM\Tmp_Software\Classes\Applications\MMC.exe /v NoOpenWith /f
reg add HKLM\Tmp_Software\Classes\.msc /ve /d MSCFile /f
call RegCopy HKLM\Software\Classes\mscfile
call RegCopy HKLM\Software\Microsoft\MMC
