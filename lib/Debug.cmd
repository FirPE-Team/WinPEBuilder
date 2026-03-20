echo.
echo ===== DEBUG MODE =====
echo 输入任意命令执行
echo 输入 continue 继续执行
echo 输入 exit 退出构建
echo ======================
:debug_loop
set /p cmd=debug^> 
if /i "%cmd%"=="continue" goto :EOF
if /i "%cmd%"=="exit" exit /b 1
call %cmd%
goto debug_loop
