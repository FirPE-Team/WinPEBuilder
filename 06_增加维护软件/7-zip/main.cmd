call Extract2X 7-Zip.7z "%X%\Program Files"
for /r "%cd%" %%a in (*.reg) do reg import %%a
