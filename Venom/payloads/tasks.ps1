# Define the trigger (run at system startup)
$Trigger = New-ScheduledTaskTrigger -AtStartup

# Define the action (execute the batch script for XMRig)
$Action = New-ScheduledTaskAction -Execute "cmd.exe" -Argument "/c C:\path\to\combined_script.bat"

# Define the task settings
$Settings = New-ScheduledTaskSettingsSet -StartWhenAvailable -DontStopIfGoingOnBatteries -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 5)

# Register the task
Register-ScheduledTask -TaskName "XMRigMonitor" -Trigger $Trigger -Action $Action -Settings $Settings -Description "Monitors and updates XMRig configuration and restarts if an error occurs"
