for /d %%i in ("%~dp0\*") do (
  if exist "%%i\main.cmd" (
    pushd "%%i"
    call "%%i\main.cmd"
    popd
  )
)
