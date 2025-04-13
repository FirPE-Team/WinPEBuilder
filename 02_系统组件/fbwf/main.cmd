call X2X

echo 修复使用 WES fbwf 卡顿
reg delete "HKLM\Tmp_SYSTEM\ControlSet001\Services\StateRepository" /f
del /f /a /q "%X%\Windows\System32\Windows.StateRepository.dll"
del /f /a /q "%X%\Windows\System32\Windows.StateRepositoryBroker.dll"
del /f /a /q "%X%\Windows\System32\Windows.StateRepositoryClient.dll"
del /f /a /q "%X%\Windows\System32\Windows.StateRepositoryCore.dll"
del /f /a /q "%X%\Windows\System32\Windows.StateRepositoryPS.dll"
del /f /a /q "%X%\Windows\System32\Windows.StateRepositoryUpgrade.dll"
