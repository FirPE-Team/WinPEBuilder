rem ==========update filesystem==========

call AddFiles %0 :end_files
goto :end_files

; Theme and dwm
\Windows\System32\dcomp.dll
\Windows\System32\d3d11.dll
\Windows\System32\dxgi.dll
\Windows\System32\dwm.exe
\Windows\System32\dwmcore.dll
\Windows\System32\dwmghost.dll
\Windows\System32\dwminit.dll
\Windows\System32\dwmredir.dll
\Windows\System32\hotplug.dll
\Windows\System32\themeservice.dll
\Windows\System32\themeui.dll
\Windows\System32\twinapi.appcore.dll
\Windows\System32\twinui.dll
\Windows\System32\ubpm.dll
\Windows\System32\uDWM.dll
\Windows\System32\wdi.dll
\Windows\System32\Windows.Gaming.Input.dll
\Windows\System32\Windows.UI.Immersive.dll
\Windows\System32\CoreMessaging.dll
\Windows\System32\CoreUIComponents.dll
\Windows\System32\ISM.dll
\Windows\System32\rmclient.dll

+ver > 18950
\Windows\System32\GameInput.dll
+ver >= 22000
\Windows\System32\wuceffects.dll
+ver >= 25300
\Windows\System32\DispBroker.dll
+ver >= 25900
\Windows\System32\Microsoft.Internal.WarpPal.dll
+ver*

; already in winre.wim, add for others, like winpe.wim(ADK)
\Windows\System32\d2d1.dll
\Windows\System32\d3d10warp.dll
\Windows\System32\D3DCompiler_47.dll
\Windows\System32\DXCore.dll

:end_files

rem ==========update registry==========
call RegCopy HKLM\SYSTEM\ControlSet001\Services\CoreMessagingRegistrar
reg add HKLM\Tmp_SYSTEM\Setup\AllowStart\CoreMessagingRegistrar /f

call RegCopy HKLM\Software\Microsoft\Windows\DWM
reg add HKLM\Tmp_Software\Microsoft\Windows\DWM /v OneCoreNoBootDWM /t REG_DWORD /d 0 /f

rem 启用圆角窗口（Windows 11 22621+）
reg add HKLM\Tmp_Software\Microsoft\Windows\DWM /v ForceEffectMode /t REG_DWORD /d 2 /f

rem No shadow effect, so force ColorPrevalence to 1
reg add HKLM\Tmp_Software\Microsoft\Windows\DWM /v ColorPrevalence /t REG_DWORD /d 1 /f

reg add HKLM\Tmp_Default\Software\Microsoft\Windows\DWM /v Composition /t REG_DWORD /d 1 /f
reg add HKLM\Tmp_Default\Software\Microsoft\Windows\DWM /v ColorizationGlassAttribute /t REG_DWORD /d 0 /f
reg add HKLM\Tmp_Default\Software\Microsoft\Windows\DWM /v ColorPrevalence /t REG_DWORD /d 1 /f

rem   // For dwm.exe or StateRepository
rem   //RegCopyKey,HKLM,Tmp_Software\Microsoft\WindowsRuntime\Server\StateRepository
rem   //RegCopyKey,HKLM,Tmp_Software\Microsoft\WindowsRuntime\ActivatableClassId
call RegCopy HKLM\Software\Microsoft\WindowsRuntime
call RegCopy "HKLM\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppModel"
call RegCopy HKLM\Software\Microsoft\Windows\CurrentVersion\AppModel
call RegCopy HKLM\Software\Microsoft\Windows\CurrentVersion\AppX
