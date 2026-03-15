rem 初始化结束

@echo off
setlocal enabledelayedexpansion
set "PATH=%~dp0;%PATH%"
call common setWinPEDrive

if exist "!ConfigPath!" (
    rem 自动重装系统
    call common readini !ConfigPath! "自动重装系统" "开关"

    if !value!==1 (
        call common readini !ConfigPath! "自动重装系统" "镜像文件"
        set imageName=!value!
        call common readini !ConfigPath! "自动重装系统" "镜像索引"
        set imageIndex=!value!
        call common readini !ConfigPath! "自动重装系统" "静默操作"
        set quiet=!value!
        call common readini !ConfigPath! "自动重装系统" "完成操作"
        set action=!value!

        start "WinPE - 自动重装系统" common AutoInstallSystem !imageName! !imageIndex! !quiet! !action!
    )
)

if defined CustomHooks if exist "%CustomHooks%\%~nx0" call %CustomHooks%\%~nx0
call common log 系统钩子模块结束 阶段：%~n0%
