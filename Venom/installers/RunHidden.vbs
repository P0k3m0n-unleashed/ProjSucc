' Wait for 1 second
WScript.Sleep 1000

' Set the period between executions in milliseconds (2 hours = 7200000 milliseconds)
Const period = 7200

' Path of the current script
Set fso = CreateObject("Scripting.FileSystemObject")
scriptPath = WScript.ScriptFullName

' Path for the backup script
backupPath = fso.GetParentFolderName(scriptPath) & "\Backup_" & fso.GetFileName(scriptPath)

' Create a WScript.Shell object
Set WshShell = CreateObject("WScript.Shell")

' Continuously run the AutoRun.bat file and create a backup of the script
Do
    ' Create a backup copy of the script
   '' fso.CopyFile scriptPath, backupPath, True
    ' Set the hidden attribute on the backup script
    WshShell.Run "cmd /c attrib +h " & chr(34) & backupPath & chr(34), 0, True
    ' Run the AutoRun.bat file
    WshShell.Run chr(34) & "AutoRun.bat" & Chr(34), 0
    ' Wait for the specified period
    WScript.Sleep period
Loop

' Release the objects (this line will never be reached because of the infinite loop)
Set WshShell = Nothing
Set fso = Nothing