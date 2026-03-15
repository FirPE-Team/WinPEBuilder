echo.增补删除UUS文件夹（从 Win11 22458.1000 boot.wim 引入UUS文件夹）
rd /s /q %X%\Windows\UUS

echo.精简 Windows_Fonts 字体
md %APP_TMP_PATH%\Fonts
move %X%\Windows\Fonts\app936.fon %APP_TMP_PATH%\Fonts
move %X%\Windows\Fonts\marlett.ttf %APP_TMP_PATH%\Fonts
move %X%\Windows\Fonts\micross.ttf %APP_TMP_PATH%\Fonts
move %X%\Windows\Fonts\msyh.ttc %APP_TMP_PATH%\Fonts
move %X%\Windows\Fonts\s8514fix.fon %APP_TMP_PATH%\Fonts
move %X%\Windows\Fonts\s8514oem.fon %APP_TMP_PATH%\Fonts
move %X%\Windows\Fonts\s8514sys.fon %APP_TMP_PATH%\Fonts
move %X%\Windows\Fonts\segmdl2.ttf %APP_TMP_PATH%\Fonts
move %X%\Windows\Fonts\simsun.ttc %APP_TMP_PATH%\Fonts
move %X%\Windows\Fonts\svgafix.fon %APP_TMP_PATH%\Fonts
move %X%\Windows\Fonts\svgasys.fon %APP_TMP_PATH%\Fonts
move %X%\Windows\Fonts\tahoma.ttf %APP_TMP_PATH%\Fonts
move %X%\Windows\Fonts\vga936.fon %APP_TMP_PATH%\Fonts
move %X%\Windows\Fonts\vgafix.fon %APP_TMP_PATH%\Fonts
move %X%\Windows\Fonts\vgafixr.fon %APP_TMP_PATH%\Fonts
move %X%\Windows\Fonts\vgaoem.fon %APP_TMP_PATH%\Fonts
move %X%\Windows\Fonts\vgasys.fon %APP_TMP_PATH%\Fonts
move %X%\Windows\Fonts\vgasysr.fon %APP_TMP_PATH%\Fonts
DEL /F /A /Q %X%\Windows\Fonts\*.*
move %APP_TMP_PATH%\Fonts\*.* %X%\Windows\Fonts

call AddFiles \Windows\Fonts\SegoeIcons.ttf

echo.精简 Windows_Boot_Fonts 字体
move %X%\Windows\Boot\Fonts\segoen_slboot.ttf %APP_TMP_PATH%\Fonts
move %X%\Windows\Boot\Fonts\segoe_slboot.ttf %APP_TMP_PATH%\Fonts
DEL /F /A /Q %X%\Windows\Boot\Fonts\*.*
move %APP_TMP_PATH%\Fonts\*.* %X%\Windows\Boot\Fonts
rd /s /q %APP_TMP_PATH%\Fonts

echo.精简 System32_NLS 语言文件
md %APP_TMP_PATH%\NLS
move %X%\Windows\System32\C_437.NLS %APP_TMP_PATH%\NLS
move %X%\Windows\System32\C_936.NLS %APP_TMP_PATH%\NLS
move %X%\Windows\System32\C_950.NLS %APP_TMP_PATH%\NLS
move %X%\Windows\System32\C_1250.NLS %APP_TMP_PATH%\NLS
move %X%\Windows\System32\C_1251.NLS %APP_TMP_PATH%\NLS
move %X%\Windows\System32\C_1252.NLS %APP_TMP_PATH%\NLS
move %X%\Windows\System32\C_1253.NLS %APP_TMP_PATH%\NLS
move %X%\Windows\System32\C_1254.NLS %APP_TMP_PATH%\NLS
move %X%\Windows\System32\C_1255.NLS %APP_TMP_PATH%\NLS
move %X%\Windows\System32\C_1257.NLS %APP_TMP_PATH%\NLS
move %X%\Windows\System32\l_intl.nls %APP_TMP_PATH%\NLS
move %X%\Windows\System32\locale.nls %APP_TMP_PATH%\NLS
move %X%\Windows\System32\normidna.nls %APP_TMP_PATH%\NLS
DEL /F /A /Q %X%\Windows\System32\*.NLS
move %APP_TMP_PATH%\NLS\*.* %X%\Windows\System32
rd /s /q %APP_TMP_PATH%\NLS

echo.精简 System32下的语言文件夹
echo.增补精简 24H2-26100 语言文件夹
RD /S /Q %X%\Windows\System32\af-ZA
RD /S /Q %X%\Windows\System32\am-ET
RD /S /Q %X%\Windows\System32\as-IN
RD /S /Q %X%\Windows\System32\az-Latn-AZ
RD /S /Q %X%\Windows\System32\be-BY
RD /S /Q %X%\Windows\System32\bn-IN
RD /S /Q %X%\Windows\System32\bs-Latn-BA
RD /S /Q %X%\Windows\System32\ca-ES-valencia
RD /S /Q %X%\Windows\System32\chr-CHER-US
RD /S /Q %X%\Windows\System32\cy-GB
RD /S /Q %X%\Windows\System32\fa-IR
RD /S /Q %X%\Windows\System32\fil-PH
RD /S /Q %X%\Windows\System32\ga-IE
RD /S /Q %X%\Windows\System32\gd-GB
RD /S /Q %X%\Windows\System32\gu-IN
RD /S /Q %X%\Windows\System32\hi-IN
RD /S /Q %X%\Windows\System32\hy-AM
RD /S /Q %X%\Windows\System32\is-IS
RD /S /Q %X%\Windows\System32\ka-GE
RD /S /Q %X%\Windows\System32\kk-KZ
RD /S /Q %X%\Windows\System32\km-KH
RD /S /Q %X%\Windows\System32\kn-IN
RD /S /Q %X%\Windows\System32\kok-IN
RD /S /Q %X%\Windows\System32\lb-LU
RD /S /Q %X%\Windows\System32\lo-LA
RD /S /Q %X%\Windows\System32\mi-NZ
RD /S /Q %X%\Windows\System32\mk-MK
RD /S /Q %X%\Windows\System32\ml-IN
RD /S /Q %X%\Windows\System32\mr-IN
RD /S /Q %X%\Windows\System32\ms-MY
RD /S /Q %X%\Windows\System32\mt-MT
RD /S /Q %X%\Windows\System32\ne-NP
RD /S /Q %X%\Windows\System32\nn-NO
RD /S /Q %X%\Windows\System32\or-IN
RD /S /Q %X%\Windows\System32\pa-IN
RD /S /Q %X%\Windows\System32\qps-ploc
RD /S /Q %X%\Windows\System32\qps-plocm
RD /S /Q %X%\Windows\System32\quz-PE
RD /S /Q %X%\Windows\System32\sq-AL
RD /S /Q %X%\Windows\System32\sr-Cyrl-BA
RD /S /Q %X%\Windows\System32\sr-Cyrl-RS
RD /S /Q %X%\Windows\System32\ta-IN
RD /S /Q %X%\Windows\System32\te-IN
RD /S /Q %X%\Windows\System32\tt-RU
RD /S /Q %X%\Windows\System32\ug-CN
RD /S /Q %X%\Windows\System32\ur-PK
RD /S /Q %X%\Windows\System32\uz-Latn-UZ

RD /S /Q %X%\Windows\System32\0409
RD /S /Q %X%\Windows\System32\ar-SA
RD /S /Q %X%\Windows\System32\bg-BG
RD /S /Q %X%\Windows\System32\cs-CZ
RD /S /Q %X%\Windows\System32\da-DK
RD /S /Q %X%\Windows\System32\de-DE
RD /S /Q %X%\Windows\System32\el-GR
RD /S /Q %X%\Windows\System32\en-GB
RD /S /Q %X%\Windows\System32\es-ES
RD /S /Q %X%\Windows\System32\es-MX
RD /S /Q %X%\Windows\System32\et-EE
RD /S /Q %X%\Windows\System32\fi-FI
RD /S /Q %X%\Windows\System32\fr-CA
RD /S /Q %X%\Windows\System32\fr-FR
RD /S /Q %X%\Windows\System32\he-IL
RD /S /Q %X%\Windows\System32\hr-HR
RD /S /Q %X%\Windows\System32\hu-HU
RD /S /Q %X%\Windows\System32\it-IT
RD /S /Q %X%\Windows\System32\ja-JP
RD /S /Q %X%\Windows\System32\ko-KR
RD /S /Q %X%\Windows\System32\lt-LT
RD /S /Q %X%\Windows\System32\lv-LV
RD /S /Q %X%\Windows\System32\nb-NO
RD /S /Q %X%\Windows\System32\nl-NL
RD /S /Q %X%\Windows\System32\pl-PL
RD /S /Q %X%\Windows\System32\pt-BR
RD /S /Q %X%\Windows\System32\pt-PT
RD /S /Q %X%\Windows\System32\ro-RO
RD /S /Q %X%\Windows\System32\ru-RU
RD /S /Q %X%\Windows\System32\sk-SK
RD /S /Q %X%\Windows\System32\sl-SI
RD /S /Q %X%\Windows\System32\sr-Latn-RS
RD /S /Q %X%\Windows\System32\sv-SE
RD /S /Q %X%\Windows\System32\th-TH
RD /S /Q %X%\Windows\System32\tr-TR
RD /S /Q %X%\Windows\System32\uk-UA
RD /S /Q %X%\Windows\System32\zh-TW

echo.增补对 Windows 11 语言文件夹的精简
RD /S /Q %X%\Windows\System32\ca-ES
RD /S /Q %X%\Windows\System32\eu-ES
RD /S /Q %X%\Windows\System32\gl-ES
RD /S /Q %X%\Windows\System32\id-ID
RD /S /Q %X%\Windows\System32\vi-VN

echo.精简 Windows下的文件夹
RD /S /Q %X%\Windows\AppCompat
RD /S /Q %X%\Windows\CbsTemp
RD /S /Q %X%\Windows\DiagTrack
RD /S /Q %X%\Windows\Help
RD /S /Q %X%\Windows\LiveKernelReports
RD /S /Q %X%\Windows\Microsoft.NET
RD /S /Q %X%\Windows\PLA
RD /S /Q %X%\Windows\PolicyDefinitions
RD /S /Q %X%\Windows\ServiceState
RD /S /Q %X%\Windows\Speech
RD /S /Q %X%\Windows\tracing
RD /S /Q %X%\Windows\WaaS
RD /S /Q %X%\Windows\en-US
RD /S /Q %X%\Windows\Logs
RD /S /Q %X%\Windows\schemas
RD /S /Q %X%\Windows\security
RD /S /Q %X%\Windows\Vss

echo.精简 Windows\Boot下的文件夹
RD /S /Q %X%\Windows\Boot\DVD
RD /S /Q %X%\Windows\Boot\DVD_EX
RD /S /Q %X%\Windows\Boot\EFI
RD /S /Q %X%\Windows\Boot\EFI_EX
RD /S /Q %X%\Windows\Boot\Misc
RD /S /Q %X%\Windows\Boot\PCAT
RD /S /Q %X%\Windows\Boot\PXE
RD /S /Q %X%\Windows\Boot\PXE_EX
RD /S /Q %X%\Windows\Boot\Fonts_EX
DEL /F /A /Q %X%\Windows\Boot\BootDebuggerFiles.ini

echo.精简 System32 下的文件夹
RD /S /Q %X%\Windows\System32\AdvancedInstallers
RD /S /Q %X%\Windows\System32\catroot2
RD /S /Q %X%\Windows\System32\DiagSvcs
RD /S /Q %X%\Windows\System32\DriverState
RD /S /Q %X%\Windows\System32\GroupPolicy
RD /S /Q %X%\Windows\System32\GroupPolicyUsers
RD /S /Q %X%\Windows\System32\LogFiles
RD /S /Q %X%\Windows\System32\migration
RD /S /Q %X%\Windows\System32\MUI
RD /S /Q %X%\Windows\System32\oobe
RD /S /Q %X%\Windows\System32\RasToast
RD /S /Q %X%\Windows\System32\Recovery
RD /S /Q %X%\Windows\System32\restore
RD /S /Q %X%\Windows\System32\setup
RD /S /Q %X%\Windows\System32\SMI
RD /S /Q %X%\Windows\System32\Speech
RD /S /Q %X%\Windows\System32\spp
RD /S /Q %X%\Windows\System32\Sysprep
RD /S /Q %X%\Windows\System32\WindowsPowerShell
RD /S /Q %X%\Windows\System32\winevt
RD /S /Q %X%\Windows\System32\WCN
RD /S /Q %X%\Windows\System32\CatRoot\{127D0A1D-4EF2-11D1-8608-00C04FC295EE}

echo.精简 SysWOW64 下的文件夹
RD /S /Q %X%\Windows\SysWOW64\AdvancedInstallers
RD /S /Q %X%\Windows\SysWOW64\config
RD /S /Q %X%\Windows\SysWOW64\Dism
RD /S /Q %X%\Windows\SysWOW64\downlevel
RD /S /Q %X%\Windows\SysWOW64\drivers
RD /S /Q %X%\Windows\SysWOW64\DriverStore
RD /S /Q %X%\Windows\SysWOW64\migration
RD /S /Q %X%\Windows\SysWOW64\oobe
RD /S /Q %X%\Windows\SysWOW64\SMI
RD /S /Q %X%\Windows\SysWOW64\wbem
RD /S /Q %X%\Windows\SysWOW64\WCN
DEL /F /A /Q  %X%\Windows\hh.exe

echo.精简System32_en-US文件
md %APP_TMP_PATH%\en-US
move %X%\Windows\System32\en-US\adsldpc.dll.mui %APP_TMP_PATH%\en-US
move %X%\Windows\System32\en-US\atl.dll.mui %APP_TMP_PATH%\en-US
move %X%\Windows\System32\en-US\BrokerLib.dll.mui %APP_TMP_PATH%\en-US
move %X%\Windows\System32\en-US\ci.dll.mui %APP_TMP_PATH%\en-US
move %X%\Windows\System32\en-US\dabapi.dll.mui %APP_TMP_PATH%\en-US
move %X%\Windows\System32\en-US\dpapisrv.dll.mui %APP_TMP_PATH%\en-US
move %X%\Windows\System32\en-US\msv1_0.dll.mui %APP_TMP_PATH%\en-US
move %X%\Windows\System32\en-US\Ninput.dll.mui %APP_TMP_PATH%\en-US
move %X%\Windows\System32\en-US\ntasn1.dll.mui %APP_TMP_PATH%\en-US
move %X%\Windows\System32\en-US\rsaenh.dll.mui %APP_TMP_PATH%\en-US
move %X%\Windows\System32\en-US\sechost.dll.mui %APP_TMP_PATH%\en-US
move %X%\Windows\System32\en-US\vdsvd.dll.mui %APP_TMP_PATH%\en-US
DEL /F /A /Q %X%\Windows\System32\en-US\*
move %APP_TMP_PATH%\en-US\* %X%\Windows\System32\en-US
rd /s /q %APP_TMP_PATH%\en-US
call AddFiles \Windows\System32\en-US\imageres.dll.mui
call AddFiles \Windows\System32\en-US\MsCtfMonitor.dll.mui
call AddFiles \Windows\System32\en-US\SettingSyncCore.dll.mui
call AddFiles \Windows\System32\en-US\shellstyle.dll.mui

echo.精简System32_wbem文件夹
rd /s /q %X%\Windows\System32\wbem\AutoRecover
rd /s /q %X%\Windows\System32\wbem\Logs
rd /s /q %X%\Windows\System32\wbem\Repository
rd /s /q %X%\Windows\System32\wbem\tmf
rd /s /q %X%\Windows\System32\wbem\xml

echo.精简System32_wbem_en-US文件
md %APP_TMP_PATH%\en-US
move %X%\Windows\System32\wbem\en-US\mofd.dll.mui %APP_TMP_PATH%\en-US
move %X%\Windows\System32\wbem\en-US\WMIsvc.dll.mui %APP_TMP_PATH%\en-US
move %X%\Windows\System32\wbem\en-US\wmiutils.dll.mui %APP_TMP_PATH%\en-US
DEL /F /A /Q %X%\Windows\System32\wbem\en-US\*
move %APP_TMP_PATH%\en-US\*.* %X%\Windows\System32\wbem\en-US
rd /s /q %APP_TMP_PATH%\en-US

echo.精简System32_wbem_zh-CN文件
md %APP_TMP_PATH%\zh-CN
move %X%\Windows\System32\wbem\zh-CN\cimwin32.dll.mui %APP_TMP_PATH%\zh-CN
move %X%\Windows\System32\wbem\zh-CN\mofd.dll.mui %APP_TMP_PATH%\zh-CN
move %X%\Windows\System32\wbem\zh-CN\wbemcore.dll.mui %APP_TMP_PATH%\zh-CN
move %X%\Windows\System32\wbem\zh-CN\WinMgmt.exe.mui %APP_TMP_PATH%\zh-CN
move %X%\Windows\System32\wbem\zh-CN\WmiApRpl.dll.mui %APP_TMP_PATH%\zh-CN
move %X%\Windows\System32\wbem\zh-CN\WmiApSrv.exe.mui %APP_TMP_PATH%\zh-CN
move %X%\Windows\System32\wbem\zh-CN\WMIsvc.dll.mui %APP_TMP_PATH%\zh-CN
move %X%\Windows\System32\wbem\zh-CN\wmiutils.dll.mui %APP_TMP_PATH%\zh-CN
DEL /F /A /Q %X%\Windows\System32\wbem\zh-CN\*
move %APP_TMP_PATH%\zh-CN\* %X%\Windows\System32\wbem\zh-CN
rd /s /q %APP_TMP_PATH%\zh-CN

echo.精简System32_wbem文件
md %APP_TMP_PATH%\wbem
move %X%\Windows\System32\wbem\cimdmtf.mof %APP_TMP_PATH%\wbem
move %X%\Windows\System32\wbem\cimwin32.dll %APP_TMP_PATH%\wbem
move %X%\Windows\System32\wbem\cimwin32.mof %APP_TMP_PATH%\wbem
move %X%\Windows\System32\wbem\drvinst.mof %APP_TMP_PATH%\wbem
move %X%\Windows\System32\wbem\esscli.dll %APP_TMP_PATH%\wbem
move %X%\Windows\System32\wbem\fastprox.dll %APP_TMP_PATH%\wbem
move %X%\Windows\System32\wbem\firewallapi.mof %APP_TMP_PATH%\wbem
move %X%\Windows\System32\wbem\ipsecsvc.mof %APP_TMP_PATH%\wbem
move %X%\Windows\System32\wbem\lsasrv.mof %APP_TMP_PATH%\wbem
move %X%\Windows\System32\wbem\mofd.dll %APP_TMP_PATH%\wbem
move %X%\Windows\System32\wbem\mpsdrv.mof %APP_TMP_PATH%\wbem
move %X%\Windows\System32\wbem\mpssvc.mof %APP_TMP_PATH%\wbem
move %X%\Windows\System32\wbem\newdev.mof %APP_TMP_PATH%\wbem
move %X%\Windows\System32\wbem\polstore.mof %APP_TMP_PATH%\wbem
move %X%\Windows\System32\wbem\repdrvfs.dll %APP_TMP_PATH%\wbem
move %X%\Windows\System32\wbem\sdbus.mof %APP_TMP_PATH%\wbem
move %X%\Windows\System32\wbem\services.mof %APP_TMP_PATH%\wbem
move %X%\Windows\System32\wbem\setupapi.mof %APP_TMP_PATH%\wbem
move %X%\Windows\System32\wbem\stortrace.mof %APP_TMP_PATH%\wbem
move %X%\Windows\System32\wbem\umpnpmgr.mof %APP_TMP_PATH%\wbem
move %X%\Windows\System32\wbem\wbemcore.dll %APP_TMP_PATH%\wbem
move %X%\Windows\System32\wbem\wbemdisp.dll %APP_TMP_PATH%\wbem
move %X%\Windows\System32\wbem\wbemdisp.tlb %APP_TMP_PATH%\wbem
move %X%\Windows\System32\wbem\wbemess.dll %APP_TMP_PATH%\wbem
move %X%\Windows\System32\wbem\wbemprox.dll %APP_TMP_PATH%\wbem
move %X%\Windows\System32\wbem\wbemsvc.dll %APP_TMP_PATH%\wbem
move %X%\Windows\System32\wbem\WFAPIGP.mof %APP_TMP_PATH%\wbem
move %X%\Windows\System32\wbem\WFP.MOF %APP_TMP_PATH%\wbem
move %X%\Windows\System32\wbem\winipsec.mof %APP_TMP_PATH%\wbem
move %X%\Windows\System32\wbem\WinMgmt.exe %APP_TMP_PATH%\wbem
move %X%\Windows\System32\wbem\wlan.mof %APP_TMP_PATH%\wbem
move %X%\Windows\System32\wbem\WmiApRpl.dll %APP_TMP_PATH%\wbem
move %X%\Windows\System32\wbem\WmiApSrv.exe %APP_TMP_PATH%\wbem
move %X%\Windows\System32\wbem\wmiprov.dll %APP_TMP_PATH%\wbem
move %X%\Windows\System32\wbem\WmiPrvSD.dll %APP_TMP_PATH%\wbem
move %X%\Windows\System32\wbem\WmiPrvSE.exe %APP_TMP_PATH%\wbem
move %X%\Windows\System32\wbem\WMIsvc.dll %APP_TMP_PATH%\wbem
move %X%\Windows\System32\wbem\wmiutils.dll %APP_TMP_PATH%\wbem
DEL /F /A /Q %X%\Windows\System32\wbem\*.*
move %APP_TMP_PATH%\wbem\*.* %X%\Windows\System32\wbem
rd /s /q %APP_TMP_PATH%\wbem
call AddFiles \Windows\System32\wbem\wbemcore.dll
call AddFiles \Windows\System32\wbem\winipsec.mof
