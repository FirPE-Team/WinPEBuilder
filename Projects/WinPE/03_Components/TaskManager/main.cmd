rem ==========update filesystem==========

call AddFiles %0 :end_files
goto :end_files

\Windows\System32\pdh.dll
\Windows\System32\d3d12.dll
\Windows\System32\TaskManagerDataLayer.dll
\Windows\System32\taskmgr.exe

; already in winre.wim
\Windows\System32\Windows.Web.dll

; real-time data of the connected drives in the Performance tab
\Windows\System32\diskperf.exe
\Windows\SysWOW64\diskperf.exe

:end_files

rem ==========update registry==========

reg add HKLM\Tmp_Software\Microsoft\Windows\CurrentVersion\Run /v DiskUsageInTaskmangerPerformanceTab /d "diskperf.exe -y" /f
reg import TaskManager_RegDefault.reg
