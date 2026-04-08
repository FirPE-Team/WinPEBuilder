rem ==========update filesystem==========

call AddDrivers "bda.inf,c_media.inf,gameport.inf,ks.inf,kscaptur.inf,ksfilter.inf,modemcsa.inf,usbvideo.inf,wave.inf"
call AddFiles %0 :end_files
goto :end_files

; In Winre.wim \System32\drivers\drmk.sys,ks.sys(.mui),mmcss.sys,mskssrv.sys,mspclock.sys,mspqm.sys,mstee.sys,portcls.sys
\Windows\System32\drivers\beep.sys

; In Winre.wim \System32\audiodg.exe,AudioEndpointBuilder.dll,AudioEng.dll,AUDIOKSE.dll,
\Windows\System32\AudioSes.dll
\Windows\System32\audiosrv.dll
\Windows\System32\AudioSrvPolicyManager.dll
\Windows\System32\avrt.dll
\Windows\System32\coreaudiopolicymanagerext.dll
\Windows\System32\dciman32.dll
\Windows\System32\DWrite.dll
\Windows\System32\hidserv.dll
\Windows\System32\imaadp32.acm
\Windows\System32\ksuser.dll
\Windows\System32\linkinfo.dll
\Windows\System32\lz32.dll
\Windows\System32\MMDevAPI.dll
\Windows\System32\msacm32.dll
\Windows\System32\msadp32.acm
\Windows\System32\msg711.acm
\Windows\System32\msgsm32.acm
\Windows\System32\umpo.dll
\Windows\System32\utildll.dll
\Windows\System32\wdmaud.drv
\Windows\System32\Windows.Media.Devices.dll
\Windows\System32\winmm.dll
\Windows\System32\winmmbase.dll
\Windows\System32\WinTypes.dll
\Windows\System32\wsock32.dll
\Windows\System32\avicap32.dll
\Windows\System32\bdaplgin.ax
\Windows\System32\control.exe
\Windows\System32\ddraw.dll
\Windows\System32\ddrawex.dll
\Windows\System32\deviceaccess.dll
\Windows\System32\dsound.dll
\Windows\System32\dxtrans.dll
\Windows\System32\iyuv_32.dll
\Windows\System32\l3codeca.acm
\Windows\System32\midimap.dll
\Windows\System32\mmci.dll
\Windows\System32\mmcico.dll
\Windows\System32\mmcndmgr.dll
\Windows\System32\mmcshext.dll
\Windows\System32\mmres.dll
\Windows\System32\mmsys.cpl
\Windows\System32\msacm32.drv
\Windows\System32\MSDvbNP.ax
\Windows\System32\msrle32.dll
\Windows\System32\msvfw32.dll
\Windows\System32\msvidc32.dll
\Windows\System32\msyuv.dll
\Windows\System32\psisdecd.dll
\Windows\System32\psisrndr.ax
\Windows\System32\quartz.dll
\Windows\System32\SndVol.exe
\Windows\System32\SndVolSSO.dll
\Windows\System32\stobject.dll
\Windows\System32\tsbyuv.dll
\Windows\System32\WMADMOD.DLL
\Windows\System32\WMADMOE.DLL
\Windows\System32\WMASF.DLL

+ver > 18300
\Windows\System32\SysFxUI.dll
\Windows\System32\WMALFXGFXDSP.dll
+ver*

\Windows\SysWOW64\mmres.dll

; some characters in volume mixer dialog need malgun.ttf, but origin malgun.ttf is too big
\Windows\Fonts\Malgun.ttf

\Windows\Media\Windows Background.wav
\Windows\Media\Windows Foreground.wav

:end_files


rem ==========update registry==========

rem SSM class(Steam Streaming Microphone)
rem already in WinRE.wim
rem call RegCopy SYSTEM\\ControlSet001\Control\Class\{C166523C-FE0C-4A94-A586-F1A80CFBBF3E}

rem Sound Volume Bar
reg add "HKLM\Tmp_Software\Microsoft\Windows NT\CurrentVersion\MTCUVC" /v EnableMtcUvc /t REG_DWORD /d 0 /f

rem add services
rem AudioEndpointBuilder,HDAudBus,MMCSS,volmgr services (already in WinRE.wim)
call RegCopyEx Services Beep

reg copy HKLM\Src_NTUSER.DAT\AppEvents HKLM\Tmp_Default\AppEvents /s /f

rem // Microphone (Identified by noelBlanc)
call RegCopyEx Services camsvc
call AddFiles "\Windows\System32\CapabilityAccessManager.dll,CapabilityAccessManagerClient.dll"

rem // update for Windows 11
if %VER[3]% GEQ 22000 (
  call AddFiles "\Windows\System32\StateRepository.Core.dll"
)
