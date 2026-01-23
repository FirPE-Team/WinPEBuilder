call Extract2X %cd%\7-Zip.exe "%X%\Program Files\7-zip"
for /r "%cd%" %%a in (*.reg) do reg import %%a
