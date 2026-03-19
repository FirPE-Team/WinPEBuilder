call :USE_SYSTEM_FBWF
goto :EOF

:USE_SYSTEM_FBWF
if "%APP_PE_ARCH%"=="x86" (
  rem Fbwf Cache Size. Limited to 1024 Mb with x86
  set fbwf_size=1024
) else (
  set fbwf_size=32900
)
reg add HKLM\Tmp_System\ControlSet001\Services\FBWF /v WinPECacheThreshold /t REG_DWORD /d %fbwf_size% /f
goto :EOF

:USE_WES_FBWF
echo Enable 128GB cache size with Windows Embedded Standard's fbwf driver
copy /y fbwf_128GB.cfg "%X_WIN%\fbwf.cfg"
copy /y fbwf.sys "%X_SYS%\drivers\fbwf.sys"

rem support exFAT boot.sdi
reg add HKLM\Tmp_SYSTEM\ControlSet001\Services\exfat /v Start /t REG_DWORD /d 0 /f
goto :EOF
