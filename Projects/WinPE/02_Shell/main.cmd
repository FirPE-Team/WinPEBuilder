rem ==========update filesystem==========

call AddFiles %0 :end_files
goto :end_files

; Battery icon - In Winre.wim inf: hidbatt.inf,cmbatt.inf - drivers: battc.sys,HidBatt.sys,CmBatt.sys - system32: umpo.dll,umpnpmgr.dll
\Windows\INF\battery.inf
\Windows\INF\c_battery.inf
\Windows\System32\batmeter.dll

\Windows\System32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\Microsoft-Windows-Client-Desktop-Required-Package*.cat
\Windows\System32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\Microsoft-Windows-Client-Desktop-Required-WOW64-Package*.cat
\Windows\System32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\Microsoft-Windows-Client-Features-Package*.cat
\Windows\System32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\Microsoft-Windows-Client-Features-WOW64-Package*.cat

; in winre.wim
\Windows\System32\mlang.dat
\Windows\System32\mlang.dll
\Windows\System32\ieframe.dll

; resources for Computer Management
\Windows\System32\mycomput.dll

; resources for This PC's Properties
\Windows\System32\systemcpl.dll

; resources for desktop background contextmenu
\Windows\System32\Display.dll
\Windows\System32\themecpl.dll

; Microsoft FTP Folder
\Windows\System32\msieftp.dll
\Windows\System32\shdocvw.dll

; Add Network Location
\Windows\System32\shwebsvc.dll

; Create Shortcut Wizard
;AppWiz.cpl
;%APP_PE_LANG%\AppWiz.cpl.mui
;osbaseln.dll

; Details default folderview layout
\Windows\System32\windows.storage.dll

; Resolution settings for 24h2
+ver >= 26100
\Windows\System32\DispBroker.Desktop.dll
\Windows\System32\Windows.Graphics.dll

; remove ver check (add with any ver)
+ver*

; system tray icons stuck issue for 2025.08 update latter
\Windows\System32\CapabilityAccessManager.Desktop.Storage.dll
\Windows\System32\gamemode.dll

; 获取所有权 (Appinfo and ProfSvc services). ProfSvc services already here (profsvc.dll,profsvcext.dll,provsvc.dll,objsel.dll)
\Windows\System32\appinfo.dll
\Windows\System32\appinfoext.dll
\Windows\System32\objsel.dll

:end_files

rem ==========update registry==========

rem Computer Management Command
reg add HKLM\Tmp_Software\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Manage\command /ve /d "mmc.exe compmgmt.msc /s" /f

rem fix blank shortcut icons
reg add HKLM\Tmp_Software\Policies\Microsoft\Windows\Explorer /v EnableShellShortcutIconRemotePath /t REG_DWORD /d 1 /f

reg import Shell_RegDefault.reg
reg import Shell_RegSoftware.reg

pushd WinXShell
call submain.cmd
popd

pushd 360FileBrowser
call submain.cmd
popd
