rd /s /q "%X%\Windows\WinSxS"

call AddFiles %0 :end_files
goto :end_files

; //- Language without fallback language should be enough for WinSxS
\Windows\WinSxS\amd64_microsoft.windows.c..-controls.resources_*_zh-CN*\*.*
\Windows\WinSxS\amd64_microsoft.windows.common-controls*\*.*
\Windows\WinSxS\amd64_microsoft.windows.gdiplus.systemcopy_*\*.*
\Windows\WinSxS\amd64_microsoft.windows.gdiplus_*\*.*
\Windows\WinSxS\amd64_microsoft.windows.isolationautomation_*\*.*
\Windows\WinSxS\amd64_microsoft.windows.i..utomation.proxystub_*\*.*
\Windows\WinSxS\amd64_microsoft-windows-servicingstack_*\*.*
; //-
\Windows\WinSxS\manifests\amd64_microsoft.windows.c..-controls.resources_*_zh-CN*.manifest
\Windows\WinSxS\manifests\amd64_microsoft.windows.common-controls*.manifest
\Windows\WinSxS\manifests\amd64_microsoft.windows.gdiplus.systemcopy_*.manifest
\Windows\WinSxS\manifests\amd64_microsoft.windows.gdiplus_*.manifest
\Windows\WinSxS\manifests\amd64_microsoft.windows.isolationautomation_*.manifest
\Windows\WinSxS\manifests\amd64_microsoft.windows.i..utomation.proxystub_*.manifest
\Windows\WinSxS\manifests\amd64_microsoft-windows-comdlg32_*.manifest
\Windows\WinSxS\manifests\amd64_microsoft-windows-comctl32-v5.resources_*_zh-CN*.manifest
\Windows\WinSxS\manifests\amd64_microsoft-windows-comdlg32.resources_*_zh-CN*.manifest
\Windows\WinSxS\manifests\amd64_microsoft.windows.systemcompatible_*.manifest
\Windows\WinSxS\manifests\amd64_microsoft-windows-a..core-base.resources_*.manifest
\Windows\WinSxS\manifests\amd64_microsoft-windows-blb-engine-main_*.manifest
\Windows\WinSxS\manifests\amd64_microsoft.windows.s...smart_card_library_*.manifest
\Windows\WinSxS\manifests\amd64_microsoft.windows.s..rt_driver.resources_*.manifest
\Windows\WinSxS\manifests\amd64_microsoft.windows.s..se.scsi_port_driver_*.manifest
\Windows\WinSxS\manifests\amd64_microsoft-windows-servicingstack_*.manifest
; //\Windows\WinSxS\manifests\x86_microsoft.windows.s..ation.badcomponents_*.manifest

:end_files
