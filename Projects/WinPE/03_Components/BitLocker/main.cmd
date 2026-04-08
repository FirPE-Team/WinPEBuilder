rem ==========update filesystem==========
rem Explorer BitLocker integration

rem full feature
rem call AddFiles "\Windows\System32\bde*.exe,fve*.exe,bde*.dll,fve*.dll,BitLocker*.*,EhStor*.*"

call AddFiles %0 :end_files
goto :end_files

\windows\System32\bdesvc.dll
\windows\System32\bdeunlock.exe
\windows\System32\fvenotify.exe
\windows\System32\Windows.UI.Immersive.dll

\Windows\System32\bdeui.dll
\Windows\System32\fveapi.dll
\Windows\System32\en-US\fveapi.dll.mui
\Windows\System32\fvecerts.dll
\Windows\System32\fveui.dll

; control Panel
\Windows\System32\advpack.dll
\Windows\System32\BdeHdCfgLib.dll
\Windows\System32\BitLockerWizard.exe
\Windows\System32\BitLockerWizardElev.exe
\Windows\System32\dsreg.dll
\Windows\System32\fvecpl.dll
\Windows\System32\fveskybackup.dll
\Windows\System32\fvewiz.dll
\Windows\System32\ReAgent.dll
\Windows\System32\shdocvw.dll
\Windows\System32\vssapi.dll
\Windows\System32\vsstrace.dll

; auto contextmenu
\Windows\System32\StructuredQuery.dll
\Windows\System32\Windows.Storage.Search.dll

:end_files
rem ==========update registry==========

rem call RegCopy HKLM\System\ControlSet001\Services\BDESVC
call RegCopy HKLM\Software\Classes\Drive\shell\unlock-bde
reg add HKLM\Tmp_Software\Classes\Drive\shell\unlock-bde /v Icon /d bdeunlock.exe /f

rem remove unsupported menu
reg delete HKLM\Tmp_Software\Classes\Drive\shell\encrypt-bde-elev /f

binmay.exe -u "%X_SYS%\dsreg.dll" -s u:MiniNT -r u:MiniPE
fc /b "%X_SYS%\dsreg.dll.org" "%X_SYS%\dsreg.dll"
del /f /q "%X_SYS%\dsreg.dll.org"
