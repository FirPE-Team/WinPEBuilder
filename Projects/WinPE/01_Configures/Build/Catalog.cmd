rem [Catalog_AddFiles_Info]
rem Use signtool.exe to find Catalogs ex: Signtool verify /kp /v /a X:\Windows\System32\drivers\*.sys > B:\SignDrivers.txt

rem Full Catalogs
rem call AddFiles \Windows\System32\catroot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}

call AddFiles %0 :end_files
goto :end_files

\Windows\System32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\Microsoft-Windows-Basic-Http-Minio-Package~*.cat
\Windows\System32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\Microsoft-Windows-DataCenterBridging-Package~*.cat
\Windows\System32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\Microsoft-Windows-DataCenterBridging-Opt-Package*.cat

\Windows\System32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\Package_*

; Additions
\Windows\System32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\Microsoft-Windows-Browser-Package~*.cat
\Windows\System32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\Microsoft-Windows-Dedup-ChunkLibrary-Package~*.cat

+ver >= 17763
\Windows\System32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\LanguageFeatures-WordBreaking-*.cat
\Windows\System32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\Microsoft-Windows-SecureStartup-Subsystem-base-Package~*.cat

+ver >= 19041
\Windows\System32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\Microsoft-OneCore-IsolatedUserMode-Package*.cat
\Windows\System32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\Microsoft-Windows-EnterpriseClientSync-Host-Opt-Package*.cat

+ver > 20000
\Windows\System32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\Microsoft-Windows-Desktop-Shared-Drivers-merged-Package*.cat

+ver > 29550
\Windows\System32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\Microsoft-Windows-WinPE-AudioDrivers-Package~31bf3856ad364e35~amd64*.cat
\Windows\System32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\Microsoft-Windows-Winpe-Drivers-Package~31bf3856ad364e35~amd64*.cat
\Windows\System32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\Microsoft-Windows-WinPE-SKU-Foundation-Package~31bf3856ad364e35~amd64*.cat
+ver*

; 多媒体功能签名文件
\Windows\System32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\Microsoft-OneCore-Multimedia-MFPMP*.cat
\Windows\System32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\Microsoft-Windows-Media-Format-multimedia-Package~*.cat
\Windows\System32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\Microsoft-Windows-Multimedia-RestrictedCodecs-multimedia-Package~*.cat
\Windows\System32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\Microsoft-Windows-Multimedia-RestrictedCodecs-WOW64-multimedia-Package~*.cat
\Windows\System32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\Multimedia-MFCore-Package~*.cat
\Windows\System32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\Multimedia-MFCore-WOW64-Package~*.cat
\Windows\System32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\Multimedia-RestrictedCodecsCore-Package~*.cat
\Windows\System32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\Multimedia-RestrictedCodecsExt-Package~*.cat
\Windows\System32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\Microsoft-Windows-PhotoBasic-Feature-Package~*.cat
\Windows\System32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\Microsoft-Windows-PhotoBasic-PictureTools-Package~*.cat

:end_files
