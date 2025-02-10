Do
    Set WshShell = CreateObject("WScript.Shell")
    WshShell.Run chr(34) & "AutoRun.bat" & Chr(34), 0
    Set WshShell = Nothing

    WScript.Sleep 90000 ' Sleep for 15 mins
Loop
