for /r "%cd%" %%i in (*.reg) do (
	if /i "%%~xi"==".reg" (
	  reg import "%%i"
	)
)
