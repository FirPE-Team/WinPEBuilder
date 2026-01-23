echo 删除资源管理器功能区
call DelFiles "\windows\system32\UIRibbonRes.dll,UIRibbon.dll"

rem 替换 shellstyle.dll
copy /y shellstyle.dll "%X%\Windows\resources\Themes\aero\Shell\NormalColor"
reg add "HKLM\Tmp_DEFAULT\Software\Policies\Microsoft\Windows\Explorer" /v "ExplorerRibbonStartsMinimized" /t REG_DWORD /d "1" /f
reg add "HKLM\Tmp_DEFAULT\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "AlwaysShowMenus" /t REG_DWORD /d "0" /f
