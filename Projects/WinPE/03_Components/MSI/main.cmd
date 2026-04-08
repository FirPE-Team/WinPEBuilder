rem ==========update filesystem==========

call AddFiles %0 :end_files
goto :end_files

\Windows\AppPatch\msimain.sdb
\Windows\AppPatch\sysmain.sdb
\Windows\Installer

+syswow64
\Windows\System32\msi.dll
\Windows\System32\msiexec.exe
\Windows\System32\msihnd.dll
\Windows\System32\msiltcfg.dll
\Windows\System32\msimsg.dll
\Windows\System32\msisip.dll
;mscoree.dll,pcacli.dll,RstrtMgr.dll,srpapi.dll
-syswow64

\Windows\System32\wbem\msi.mof
\Windows\System32\wbem\msiprov.dll
\Windows\System32\wbem\%APP_PE_LANG%\msi.mfl

:end_files

rem ==========update registry==========

call RegCopyEx Services "eventlog\Application\MsiInstaller"
call RegCopyEx Services "msiserver,TrustedInstaller"
reg add HKLM\Tmp_System\ControlSet001\Services\TrustedInstaller /v Start /t REG_DWORD /d 3 /f

rem 自启 MSiSCSI 服务
reg add HKLM\Tmp_System\Setup\AllowStart\MSiSCSI /f
reg add HKLM\Tmp_System\ControlSet001\Services\MSiSCSI /v Start /t REG_DWORD /d 2 /f

call RegCopyEx Classes ".msi,.msp,IMsiServer,Msi.Package,Msi.Patch"
call RegCopyEx Classes WindowsInstaller.Installer
call RegCopyEx Classes WindowsInstaller.Message

call RegCopy "HKLM\Software\Classes\AppID\{000C101C-0000-0000-C000-000000000046}"
rem CLSID,Interface,TypeLib already be copied

call :Reg_Msi \
call :Reg_Msi \Wow6432Node\
goto :EOF

:Reg_Msi
set "_rpath=HKLM\Software%1Microsoft\Cryptography\OID\EncodingType 0"
set _oid={000C10F1-0000-0000-C000-000000000046}

call RegCopy "%_rpath%\CryptSIPDllCreateIndirectData\%_oid%"
call RegCopy "%_rpath%\CryptSIPDllGetSignedDataMsg\%_oid%"
call RegCopy "%_rpath%\CryptSIPDllIsMyFileType2\%_oid%"
call RegCopy "%_rpath%\CryptSIPDllPutSignedDataMsg\%_oid%"
call RegCopy "%_rpath%\CryptSIPDllRemoveSignedDataMsg\%_oid%"
call RegCopy "%_rpath%\CryptSIPDllVerifyIndirectData\%_oid%"

set _rpath=
set _oid=

call RegCopy "HKLM\Software%1Microsoft\Windows\CurrentVersion\Installer"
call RegCopy "HKLM\Software%1Microsoft\Windows\CurrentVersion\Installer\Secure"
