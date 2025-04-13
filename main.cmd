echo 正在更新文件ACL权限......
takeown /f "%X%" /a /r /d y>nul
icacls "%X%" /grant Everyone:F /t>nul

echo 正在更新注册表权限......
setacl -on "HKLM\Tmp_SOFTWARE" -ot reg -actn setowner -ownr "n:Everyone" -rec yes -silent
setacl -on "HKLM\Tmp_SOFTWARE" -ot reg -actn ace -ace "n:Everyone;p:full;m:grant;i:so,sc" -op DACL:p_c -rec yes -silent

echo 增加7-zip环境变量
call AddEnv "%X%\Program Files\7-Zip"

echo 禁用 回收站
Reg delete "HKLM\Tmp_DEFAULT\Software\Microsoft\Windows\CurrentVersion\Explorer\BitBucket" /f
Reg add "HKLM\Tmp_DEFAULT\Software\Microsoft\Windows\CurrentVersion\Explorer\BitBucket" /f
SetACL.exe -on "HKLM\Tmp_DEFAULT\Software\Microsoft\Windows\CurrentVersion\Explorer\BitBucket"  -ot reg -actn setprot -op "dacl:p_c;sacl:p_c"
SetACL.exe -on "HKLM\Tmp_DEFAULT\Software\Microsoft\Windows\CurrentVersion\Explorer\BitBucket"   -ot reg -actn clear -clr "dacl,sacl"
reg add "HKLM\Tmp_SOFTWARE\Policies\Microsoft\Windows NT\systemrestore" /v DisableConfig /t reg_dword /d 1 /f
reg add "HKLM\Tmp_SOFTWARE\Policies\Microsoft\Windows NT\systemrestore" /v DisableSR /t reg_dword /d 1 /f

echo 删除应答文件
del /f /a /q "%X%\Windows\System32\unattend.xml"

echo 删除资源管理器功能区
call DelFiles "\windows\system32\UIRibbonRes.dll,UIRibbon.dll"
rem 替换 \Windows\resources\Themes\aero\Shell\NormalColor\shellstyle.dll
reg add "HKLM\Tmp_DEFAULT\Software\Policies\Microsoft\Windows\Explorer" /v "ExplorerRibbonStartsMinimized" /t REG_DWORD /d "1" /f

echo 删除 开始菜单 - 系统工具 目录
rd /s /q "%X%\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\System Tools"
