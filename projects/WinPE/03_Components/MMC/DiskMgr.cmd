rem ==========update filesystem==========
call AddFiles %0 :end_files
goto :end_files

; Disk Management
\Windows\System32\diskmgmt.msc
\Windows\System32\%APP_PE_LANG%\diskmgmt.msc
\Windows\System32\dmdlgs.dll
\Windows\System32\dmdskmgr.dll
\Windows\System32\dmdskres.dll
\Windows\System32\dmdskres2.dll
\Windows\System32\dmintf.dll
\Windows\System32\dmocx.dll
\Windows\System32\dmutil.dll
\Windows\System32\dmvdsitf.dll
\Windows\System32\dmview.ocx
\Windows\System32\hhsetup.ocx

; Drive Optimizer (already in winre.wim)
;defragproxy.dll,defragres.dll,defragsvc.dll

:end_files

rem ==========update registry==========
