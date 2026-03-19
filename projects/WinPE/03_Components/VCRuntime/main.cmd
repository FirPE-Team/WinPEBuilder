set "f0=%~f0"

if "%APP_PE_ARCH%"=="x64" (
    call :VCRuntimes amd64 System32
    call :VCRuntimes x86 SysWOW64
) else (
    call :VCRuntimes %APP_PE_ARCH% System32
)
goto :EOF

:VCRuntimes
set SxSArch=%1
set SysDir=%2

rem ==========update file system==========
call AddFiles "%f0%" :end_files
goto :end_files

@\Windows\%SysDir%\
; VC++ runtimes
; already in winre.wim but add for SysWOW64
msvcirt.dll
msvcp_win.dll
msvcp60.dll
msvcp110_win.dll
msvcrt.dll
ucrtbase.dll

msvcp120_clr0400.dll
msvcrt20.dll
msvcrt40.dll
msvcr100_clr0400.dll
msvcr120_clr0400.dll

; Additional Files for v1903
msvcp110.dll
msvcp140_clr0400.dll
msvcr110.dll
ucrtbase_clr0400.dll
ucrtbase_enclave.dll

+ver >= 22621
vcruntime140_1_clr0400.dll
+ver*

; WinSxS VC++ runtimes
\Windows\WinSxS\%SxSArch%_microsoft.vc80.crt*
\Windows\WinSxS\%SxSArch%_microsoft.vc90.crt*
\Windows\WinSxS\manifests\%SxSArch%_microsoft.vc80.crt*
\Windows\WinSxS\manifests\%SxSArch%_policy.8.0.microsoft.vc80.crt*
\Windows\WinSxS\manifests\%SxSArch%_microsoft.vc90.crt*
\Windows\WinSxS\manifests\%SxSArch%_policy.9.0.microsoft.vc90.crt*
:end_files

rem ==========update registry==========
call RegCopy HKLM\Software\Microsoft\Windows\CurrentVersion\SideBySide\Winners,%SxSArch%_microsoft.vc80.crt_*
call RegCopy HKLM\Software\Microsoft\Windows\CurrentVersion\SideBySide\Winners,%SxSArch%_microsoft.vc90.crt_*
call RegCopy HKLM\Software\Microsoft\Windows\CurrentVersion\SideBySide\Winners,%SxSArch%_policy.8.0.microsoft.vc80.crt_*
call RegCopy HKLM\Software\Microsoft\Windows\CurrentVersion\SideBySide\Winners,%SxSArch%_policy.9.0.microsoft.vc90.crt_*
