set "f0=%~f0"

set SysDir=System32
call :Ime_Files

del /f /a /q "%X_SYS%\Windows.Networking.Connectivity.dll"

rem WOW64 Support
set SysDir=SysWOW64
call :Ime_Files

binmay.exe -u "%X_SYS%\InputService.dll" -s u:MiniNT -r u:NiniNT
fc /b "%X_SYS%\InputService.dll.org" "%X_SYS%\InputService.dll"
del /f /q "%X_SYS%\InputService.dll.org"

rem ==========update registry==========

call RegCopy HKLM\Software\Microsoft\FuzzyDS
call RegCopy HKLM\Software\Microsoft\Input

call :Ime_Reg HKLM\Software
call :Ime_Reg HKLM\Software\WOW6432Node
goto :EOF

:Ime_Files
call AddFiles "%f0%" :end_files
goto :end_files

\Windows\IME\SPTIP.DLL
\Windows\IME\zh-CN\SpTip.dll.mui

@\Windows\%SysDir%\
IME\SHARED
InputMethod\SHARED
inputLocaleManager.dll,inputHost.dll,inputService.dll
msctfime.ime,Msctfp.dll,MSWB7.dll,NOISE.DAT
MTF.dll,MTFServer.dll,TextInputFramework.dll,Winsta.dll

Ctfmon.exe,Globinputhost.dll,input.dll,inputSwitch.dll,msctf.dll,msutb.dll
MsCtfMonitor.dll,MsctfuiManager.dll,Windows.Globalization.dll,Winlangdb.dll

+ver > 18300
umpdc.dll
clbcatq.dll,dusmapi.dll
netprofm.dll,npmproxy.dll
Windows.Networking.HostName.dll
TextInputMethodFormatter.dll,WordBreakers.dll
Language*.dll
Windows.UI.Core.TextInput.dll
+ver > 18960
Windows.Web.dll
+ver >= 20251
ime_textinputhelpers.dll
+ver >= 20313
CorePrivacySettingsStore.dll
+ver >= 26100
;IME icons
\Windows\SystemApps\MicrosoftWindows.Client.Core_cw5n1h2txyewy\SystemTray\Assets\AXPIcons.ttf
+ver*

:end_files
goto :EOF

:Ime_Reg
call RegCopy %1\Microsoft\CTF
call RegCopy %1\Microsoft\IME
if "x%APP_PE_LANG%"=="xko-KR" call RegCopy %1\Microsoft\IMEKR
if "x%APP_PE_LANG%"=="xzh-CN" call RegCopy %1\Microsoft\IMETC
if "x%APP_PE_LANG%"=="xzh-TW" call RegCopy %1\Microsoft\IMETC
call RegCopy %1\Microsoft\InputMethod
