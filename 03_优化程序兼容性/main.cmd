for %%i in (*.cmd) do (
  if /i not "%%i"=="%~nx0" call "%%i"
)
