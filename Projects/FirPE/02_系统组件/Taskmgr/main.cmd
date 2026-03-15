call AddFiles %0 :end_files
goto :end_files

; 添加 Taskmgr 任务管理器
; 增补支持 26100 任务管理器 DLL文件
\Windows\System32\TaskManagerDataLayer.dll

\Windows\System32\Taskmgr.exe
\Windows\System32\zh-CN\Taskmgr.exe.mui
\Windows\SystemResources\Taskmgr.exe.mun
\Windows\System32\D3D12.dll
\Windows\System32\pdh.dll
\Windows\System32\zh-CN\pdh.dll.mui

:end_files
