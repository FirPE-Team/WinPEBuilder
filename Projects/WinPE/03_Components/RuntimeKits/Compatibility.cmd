call AddFiles %0 :end_files
goto :end_files

; System32

; add winre.wim files for boot.wim
\Windows\System32\mlang.dat
\Windows\System32\mlang.dll
\Windows\System32\oledlg.dll

\Windows\System32\findstr.exe

; AFAIK Tencent QQ(x86) required
\Windows\System32\avicap32.dll
\Windows\System32\rasman.dll

; PotPlayer
\Windows\System32\devenum.dll
\Windows\System32\EhStorAPI.dll

\Windows\System32\nsi.dll
\Windows\System32\sti.dll

\Windows\Fonts\times.ttf

; SysWOW64

; add winre.wim files for boot.wim
\Windows\SysWOW64\mlang.dat
\Windows\SysWOW64\mlang.dll
\Windows\SysWOW64\oledlg.dll

\Windows\SysWOW64\findstr.exe

; AFAIK Tencent QQ(x86) required
\Windows\SysWOW64\avicap32.dll
\Windows\SysWOW64\rasman.dll

; PotPlayer
\Windows\SysWOW64\devenum.dll
\Windows\SysWOW64\EhStorAPI.dll

; PowerPoint 2007 Preview(F5) page switch
\Windows\SysWOW64\hlink.dll

; LENOVO BIOS Updater
\Windows\SysWOW64\lz32.dll

; Counter-Strike 1.5
\Windows\SysWOW64\dciman32.dll

; eCloud
\Windows\SysWOW64\glu32.dll
\Windows\SysWOW64\opengl32.dll

; ldplayer
\Windows\SysWOW64\RESAMPLEDMO.DLL

; Sound for TheWorld Web Browser
\Windows\SysWOW64\ksuser.dll
\Windows\SysWOW64\wdmaud.drv

; OpenOffice, LibreOffice, ... (Open file)
\Windows\SysWOW64\shellstyle.dll

; 32-bit Web Browsers
\Windows\SysWOW64\Windows.FileExplorer.Common.dll

; Tencent QQ(x86), Office 2010
\Windows\SysWOW64\prxyqry.dll

; FeiQ
;Windows.System.Launcher.dll
\Windows\SysWOW64\DiagnosticDataSettings.dll

:end_files

rem ==========update registry==========
