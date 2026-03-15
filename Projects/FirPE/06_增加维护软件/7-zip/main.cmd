call V2X 7-Zip -Extract "7z*-%_Vx8664%.exe" "%X_PF%\7-Zip\"

call :REMOVE_LANGFILES
call DelFiles %0 :end_files
goto :end_files

\Program Files\7-Zip\7zCon.sfx
\Program Files\7-Zip\7-zip.chm
\Program Files\7-Zip\descript.ion
\Program Files\7-Zip\History.txt
\Program Files\7-Zip\License.txt
\Program Files\7-Zip\readme.txt
\Program Files\7-Zip\Uninstall.exe

:end_files

for /r "%cd%" %%a in (*.reg) do reg import %%a

echo 增加7-zip环境变量
call AddEnv "%X%\Program Files\7-Zip"

goto :EOF

:REMOVE_LANGFILES
if "%APP_PE_LANG%"=="fr-FR" set _7z_lang=fr
if "%APP_PE_LANG%"=="ja-JP" set _7z_lang=ja
if "%APP_PE_LANG%"=="ko-KR" set _7z_lang=ko
if "%APP_PE_LANG%"=="zh-CN" set _7z_lang=zh-cn
if "%APP_PE_LANG%"=="zh-TW" set _7z_lang=zh-tw

if not "x%_7z_lang%"=="x" (
  ren "%X%\Program Files\7-Zip\Lang\%_7z_lang%.txt" %_7z_lang%.ttt
  del "%X%\Program Files\7-Zip\Lang\*.txt"
  ren "%X%\Program Files\7-Zip\Lang\%_7z_lang%.ttt" %_7z_lang%.txt
)
set _7z_lang=
goto :EOF
