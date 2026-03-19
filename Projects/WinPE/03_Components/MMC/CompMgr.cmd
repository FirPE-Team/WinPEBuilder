rem ==========update filesystem==========

call AddFiles %0 :end_files
goto :end_files

; CompMgr
\Windows\System32\compmgmt.msc
\Windows\System32\%APP_PE_LANG%\compmgmt.msc
\Windows\System32\CompMgmtLauncher.exe

; Filesystem Management
\Windows\System32\fsmgmt.msc
\Windows\System32\%APP_PE_LANG%\fsmgmt.msc

:end_files

rem ==========update registry==========
