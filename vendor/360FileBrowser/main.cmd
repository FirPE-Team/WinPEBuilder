call X2X

reg import 360FileBrowser_Software.reg
reg import 360FileBrowser_Default.reg

rem 双击文件管理器空白处返回上一级父目录
reg add "HKLM\Tmp_SOFTWARE\Classes\CLSID\{1eeb5b5a-06fb-4732-96b3-975c0194eb39}\InProcServer32" /f /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\explorerframe.dll"
reg add "HKLM\Tmp_SOFTWARE\Classes\CLSID\{1eeb5b5a-06fb-4732-96b3-975c0194eb39}\InProcServer32" /f /v "ThreadingModel" /d "Apartment"
