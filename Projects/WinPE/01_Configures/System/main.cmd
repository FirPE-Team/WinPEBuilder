rem ==========update filesystem==========
call AddFiles %0 :end_files
goto :end_files

\Windows\Branding\Basebrd\basebrd.dll
\Windows\Branding\Basebrd\%APP_PE_LANG%\basebrd.dll.mui

\Windows\Cursors\aero_arrow.cur

\Windows\System32\wbem\xml

\Windows\System32\setx.exe

; ncsi.dll.mui is not included in winre.wim
\Windows\System32\%APP_PE_LANG%\ncsi.dll.mui

\Windows\System32\%APP_PE_LANG%\Windows.CloudStore.dll.mui

\Windows\System32\umpoext.dll

; Power management - In Winre.wim system32:powrprof.dll,workerdd.dll
\Windows\System32\powercfg.cpl
\Windows\System32\powercpl.dll

; 右键菜单的小箭头和默认用户头像字体
\Windows\Fonts\segoeui.ttf
\Windows\Fonts\SegoeIcons.ttf

\Windows\Fonts\mingliu.ttc
\Windows\Fonts\msyh.ttc
\Windows\Fonts\simsun.ttc
\Windows\Fonts\desktop.ini

\Windows\System32\ISM.exe

:end_files

call AddDrivers winusb.inf
copy /y System.evtx "%X_SYS%\winevt\Logs\"

rem ==========update registry==========

rem // Start Services after RS5
reg add HKLM\Tmp_System\ControlSet001\Services\BFE /v ImagePath /t REG_EXPAND_SZ /d "%%systemroot%%\system32\svchost.exe -k LocalServiceNoNetworkFirewall -p" /f
reg add HKLM\Tmp_System\ControlSet001\Services\BFE /v SvcHostSplitDisable /t REG_DWORD /d 1 /f
reg add HKLM\Tmp_System\ControlSet001\Services\BFE\Security /v Security /t REG_BINARY /d 01001480900000009c000000140000003000000002001c000100000002801400ff000f000101000000000001000000000200600004000000000014008500020001010000000000050b000000000014009f000e00010100000000000512000000000018009d000e0001020000000000052000000020020000000018008500000001020000000000052000000021020000010100000000000512000000010100000000000512000000 /f
rem // in pecmd.ini EXEC @!%WinDir%\System32\Net.exe Start Wlansvc - EXEC @!%WinDir%\System32\Net.exe Start WinHttpAutoProxySvc
rem // LanmanWorkstation,DNSCache,NlaSvc does not start alone with windows 10 1809
reg add HKLM\Tmp_System\Setup\AllowStart\LanmanWorkstation /f
reg add HKLM\Tmp_System\Setup\AllowStart\DNSCache /f
reg add HKLM\Tmp_System\Setup\AllowStart\NlaSvc /f

call "%~dp0ProductOptions.cmd"

rem // Environment
reg add "HKLM\Tmp_System\ControlSet001\Control\Session Manager\Environment" /v AppData /t REG_EXPAND_SZ  /d "%%SystemDrive%%\Users\Default\AppData\Roaming" /f

rem // Disable Telemetry
reg add HKLM\Tmp_System\ControlSet001\Control\WMI\Autologger\AutoLogger-Diagtrack-Listener /v Start /t REG_DWORD /d 0 /f
rem //-
rem // Taking Ownership, Appinfo and ProfSvc Services. ProfSvc Already Here
call RegCopyEx Services Appinfo
rem call RegCopyEx Services ProfSvc
reg add HKLM\Tmp_System\Setup\AllowStart\ProfSvc /f

call RegCopy HKLM\System\ControlSet001\Control\Lsa
call RegCopy HKLM\System\ControlSet001\Control\SecurityProviders
reg add HKLM\Tmp_System\ControlSet001\Control\Lsa /v "Security Packages" /t REG_MULTI_SZ /d tspkg /f
reg add HKLM\Tmp_System\ControlSet001\Control\SecurityProviders /v SecurityProviders /d credssp.dll /f

rem // Disable Hibernate
reg add HKLM\Tmp_System\ControlSet001\Control\Power /v HibernateEnabled /t REG_DWORD /d 0 /f
reg add HKLM\Tmp_System\ControlSet001\Control\Power /v CustomizeDuringSetup /t REG_DWORD /d 0 /f

rem // Disable Fast Startup
reg add "HKLM\Tmp_System\ControlSet001\Control\Session Manager\Power" /v HiberbootEnabled /t REG_DWORD /d 0 /f

rem // Do Not Update the Last-Access Timestamp for Ntfs and Refs
reg add HKLM\Tmp_System\ControlSet001\Control\FileSystem /v NtfsDisableLastAccessUpdate /t REG_DWORD /d 1 /f
reg add HKLM\Tmp_System\ControlSet001\Control\FileSystem /v RefsDisableLastAccessUpdate /t REG_DWORD /d 1 /f

rem // Allow network users to access without password > Also display Share with in Context Menu!
reg add HKLM\Tmp_System\ControlSet001\Control\Lsa /v LimitBlankPasswordUse /t REG_DWORD /d 0 /f

call RegCopy "HKLM\Software\Microsoft\Windows NT\CurrentVersion\EditionVersion"
call RegCopy /-s "HKLM\Software\Microsoft\Windows NT\CurrentVersion"
reg add "HKLM\Tmp_Software\Microsoft\Windows NT\CurrentVersion" /f /v "SystemRoot" /t REG_SZ /d "X:\Windows"
reg add "HKLM\Tmp_Software\Microsoft\Windows NT\CurrentVersion" /f /v "InstallDate" /t REG_DWORD /d 0
reg delete "HKLM\Tmp_Software\Microsoft\Windows NT\CurrentVersion" /f /v "CompositionEditionID" 
reg delete "HKLM\Tmp_Software\Microsoft\Windows NT\CurrentVersion" /f /v "PathName" 
reg delete "HKLM\Tmp_Software\Microsoft\Windows NT\CurrentVersion" /f /v "ProductId" 
reg delete "HKLM\Tmp_Software\Microsoft\Windows NT\CurrentVersion" /f /v "DigitalProductId" 
reg delete "HKLM\Tmp_Software\Microsoft\Windows NT\CurrentVersion" /f /v "DigitalProductId4" 
reg delete "HKLM\Tmp_Software\Microsoft\Windows NT\CurrentVersion" /f /v "InstallTime" 

reg add "HKLM\Tmp_Software\Microsoft\Windows NT\CurrentVersion\ProfileList\S-1-5-18" /v ProfileImagePath /d X:\Users\Default /f
rem // Disable Telemetry
reg add HKLM\Tmp_Software\Microsoft\Windows\CurrentVersion\Policies\DataCollection /v AllowTelemetry /t REG_DWORD /d 0 /f

rem 设置X盘大小
call SystemDriveSize.cmd

rem High Performance PowerScheme
reg add HKLM\Tmp_System\ControlSet001\Control\Power\User\PowerSchemes /v "ActivePowerScheme" /d "8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c" /f

reg add "HKLM\Tmp_Software\Microsoft\Windows NT\CurrentVersion\WinPE" /v InstRoot /d X:\ /f
reg add "HKLM\Tmp_Software\Microsoft\Windows NT\CurrentVersion\WinPE" /v CustomBackground /t REG_EXPAND_SZ /d X:\Windows\Web\Wallpaper\Windows\img0.jpg /f
reg add "HKLM\Tmp_Software\Microsoft\Windows NT\CurrentVersion\WinPE\UGC" /v Microsoft-Windows-TCPIP /t REG_MULTI_SZ /d "netiougc.exe -online" /f

reg import TextAssoc.reg

rem // Disable MS PGothic Font
reg delete "HKLM\Tmp_SOFTWARE\Microsoft\Windows NT\CurrentVersion\Font Management" /v "MS PGothic" /f
