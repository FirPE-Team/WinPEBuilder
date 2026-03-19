rem ==========update filesystem==========

call AddFiles %0 :end_files
goto :end_files

\Windows\INF\wsearchidxpi

; Search This PC
\Windows\System32\EhStorShell.dll

\Windows\System32\esent.dll
\Windows\System32\NaturalLanguage6.dll
\Windows\System32\NOISE.DAT
\Windows\System32\MSWB7.dll
\Windows\System32\mssph.dll
\Windows\System32\mssprxy.dll
\Windows\System32\mssrch.dll
\Windows\System32\mssvp.dll
\Windows\System32\mssitlb.dll
\Windows\System32\query.exe
\Windows\System32\query.dll
\Windows\System32\SearchFolder.dll
\Windows\System32\srchadmin.dll
\Windows\System32\StructuredQuery.dll
\Windows\System32\tquery.dll
\Windows\System32\Windows.Shell.Search.UriHandler.dll
\Windows\System32\Windows.Storage.Search.dll
\Windows\System32\wsepno.dll
\Windows\System32\prm*.dll
\Windows\System32\MLS*.dll

\Windows\System32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\Microsoft-Windows-SearchEngine-Client-Package~*.cat
\Windows\System32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\WindowsSearchEngineSKU-Group-Package~*.cat

:end_files

rem ==========update registry==========
rem [Reg_Search]

rem 开始菜单不搜索文件
reg add HKLM\Tmp_Default\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v Start_SearchFiles /t REG_DWORD /d 0 /f

rem 开始菜单搜索程序
reg add HKLM\Tmp_Default\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v Start_SearchPrograms /t REG_DWORD /d 1 /f

call RegCopy "HKLM\Software\Microsoft\Windows Search"
call RegCopy HKLM\System\ControlSet001\Control\ContentIndex
rem //call RegCopy HKLM\System\ControlSet001\services\WSearch
rem //reg add HKLM\Tmp_System\ControlSet001\Services\WSearch /v Start /t REG_DWORD /d 4 /f
call RegCopy HKLM\System\ControlSet001\services\WSearchIdxPi

rem [Reg_VolumeInfoCache]
rem // Failed to get data VolumeInfoCache \C:,DriveType in x64 build > Delete + Write
call RegEx HAS_KEY delete "HKLM\Tmp_Software\Microsoft\Windows Search\VolumeInfoCache" /f
reg add "HKLM\Tmp_Software\Microsoft\Windows Search\VolumeInfoCache\C:" /v DriveType /t REG_DWORD /d 3 /f
reg add "HKLM\Tmp_Software\Microsoft\Windows Search\VolumeInfoCache\C:" /v VolumeLabel /f
reg add "HKLM\Tmp_Software\Microsoft\Windows Search\VolumeInfoCache\D:" /v DriveType /t REG_DWORD /d 3 /f
reg add "HKLM\Tmp_Software\Microsoft\Windows Search\VolumeInfoCache\D:" /v VolumeLabel /f
reg add "HKLM\Tmp_Software\Microsoft\Windows Search\VolumeInfoCache\E:" /v DriveType /t REG_DWORD /d 3 /f
reg add "HKLM\Tmp_Software\Microsoft\Windows Search\VolumeInfoCache\E:" /v VolumeLabel /f
reg add "HKLM\Tmp_Software\Microsoft\Windows Search\VolumeInfoCache\F:" /v DriveType /t REG_DWORD /d 3 /f
reg add "HKLM\Tmp_Software\Microsoft\Windows Search\VolumeInfoCache\F:" /v VolumeLabel /f
reg add "HKLM\Tmp_Software\Microsoft\Windows Search\VolumeInfoCache\G:" /v DriveType /t REG_DWORD /d 3 /f
reg add "HKLM\Tmp_Software\Microsoft\Windows Search\VolumeInfoCache\G:" /v VolumeLabel /f
reg add "HKLM\Tmp_Software\Microsoft\Windows Search\VolumeInfoCache\H:" /v DriveType /t REG_DWORD /d 3 /f
reg add "HKLM\Tmp_Software\Microsoft\Windows Search\VolumeInfoCache\H:" /v VolumeLabel /f
reg add "HKLM\Tmp_Software\Microsoft\Windows Search\VolumeInfoCache\I:" /v DriveType /t REG_DWORD /d 3 /f
reg add "HKLM\Tmp_Software\Microsoft\Windows Search\VolumeInfoCache\I:" /v VolumeLabel /f
