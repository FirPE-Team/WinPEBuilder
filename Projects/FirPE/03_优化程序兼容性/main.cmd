for %%i in ("%~dp0*.cmd") do (
  if /i "%%~xi"==".cmd" (
    if /i not "%%~nxi"=="%~nx0" call "%%i"
  )
)
