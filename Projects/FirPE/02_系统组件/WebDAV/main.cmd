rem ==========update filesystem==========
call AddFiles %0 :end_files
goto :end_files

\Windows\System32\drivers\mrxdav.sys
\Windows\System32\drivers\rdbss.sys
\Windows\System32\WebClnt.dll
\Windows\System32\davclnt.dll
\Windows\System32\davhlpr.dll

:end_files

rem ==========update registry==========

call RegCopy "HKLM\System\ControlSet001\Services\WebClient"
call RegCopy "HKLM\System\ControlSet001\Services\MRxDAV"
call RegCopy "HKLM\System\ControlSet001\Services\rdbss"
call RegCopy "HKLM\System\ControlSet001\Services\LanmanServer"
call RegCopy "HKLM\System\ControlSet001\Control\Lsa"
call RegCopy "HKLM\System\ControlSet001\Control\NetworkProvider\HwOrder"
call RegCopy "HKLM\System\ControlSet001\Control\NetworkProvider\Order"
call RegCopy "HKLM\System\ControlSet001\Control\NetworkProvider\ProviderOrder"
call RegCopy "HKLM\System\ControlSet001\Control\NetworkSetup2\Clients"
call RegCopy "HKLM\System\ControlSet001\Control\NetworkSetup2\Filters"

rem 修改网络协议支持（同时支持 HTTP 和 HTTPS）
reg add "HKLM\Tmp_SYSTEM\ControlSet001\Services\WebClient\Parameters" /v "BasicAuthLevel" /t REG_DWORD /d "2" /f

rem 修改文件大小限制（4G）
reg add "HKLM\Tmp_SYSTEM\ControlSet001\Services\WebClient\Parameters" /v "FileSizeLimitInBytes" /t REG_DWORD /d "4294967295" /f
