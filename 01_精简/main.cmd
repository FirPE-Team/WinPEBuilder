for %%i in (*.cmd) do (
  if /i not "%%i"=="%~nx0" (
    echo 执行: %%~nxi
    call "%%i"
  )
)
