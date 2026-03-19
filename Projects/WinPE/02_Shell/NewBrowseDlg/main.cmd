rem ==========update filesystem==========

call AddFiles %0 :end_files
goto :end_files

\Windows\System32\comctl32.dll
\Windows\System32\ExplorerFrame.dll

\Windows\System32\AppHelp.dll

;"Security" tab
\Windows\System32\rshx32.dll

;"Security" tab - change Owner
;\Windows\System32\comsvcs.dll

; shellstyle.dll(.mui) is now in \Windows\resources\themes\aero\shell\normalcolor
\Windows\resources\Themes\aero\shell

\Windows\System32\shellstyle.dll
\Windows\System32\en-US\shellstyle.dll.mui

; DragAndDrop (d2d1.dll,ksuser.dll already in Winre.wim)
\Windows\System32\DataExchange.dll
\Windows\System32\dcomp.dll
\Windows\System32\d3d11.dll
\Windows\System32\dxgi.dll
;d2d1.dll,ksuser.dll

; CopyProgress
\Windows\System32\chartv.dll
\Windows\System32\OneCoreUAPCommonProxyStub.dll

; Overwrite confirmation dialog
\Windows\System32\actxprxy.dll

; filter
\Windows\System32\StructuredQuery.dll

; text preview
\Windows\System32\prevhost.exe

; image preview
\Windows\SystemResources\imageres.dll.mun
\Windows\System32\PhotoMetadataHandler.dll
\Windows\System32\thumbcache.dll
\Windows\System32\capisp.dll
\Windows\System32\IconCodecService.dll

:end_files

rem ;For "Security" tab (rshx32.dll)
reg add HKLM\Tmp_SOFTWARE\Classes\*\shellex\PropertySheetHandlers\{1f2e5c40-9550-11ce-99d2-00aa006e086c} /f
reg add HKLM\Tmp_SOFTWARE\Classes\Directory\shellex\PropertySheetHandlers\{1f2e5c40-9550-11ce-99d2-00aa006e086c} /f
rem reg add HKLM\Tmp_SOFTWARE\Classes\Drive\shellex\PropertySheetHandlers\{1f2e5c40-9550-11ce-99d2-00aa006e086c}] /f

rem ;For "Security" tab - change Owner
reg add HKLM\Tmp_SOFTWARE\Classes\new /ve /d "New Moniker" /f
reg add HKLM\Tmp_SOFTWARE\Classes\new\CLSID /ve /d "{ecabafc6-7f19-11d2-978e-0000f8757e2a}" /f

goto :EOF

rem explorerframe.dll CLSID
rem HKLM\SOFTWARE\Classes\CLSID\{056440FD-8568-48e7-A632-72157243B55B} required
rem already added by RegCopy HKLM\SOFTWARE\Classes\CLSID

rem reg import FileProperty.reg
