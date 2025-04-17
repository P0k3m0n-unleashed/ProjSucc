param (
    [string]$vbsPath
)

# Check if running with elevated privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    $arguments = "& '" + $myinvocation.mycommand.definition + "' -vbsPath '" + $vbsPath + "'"
    Start-Process powershell -ArgumentList $arguments -Verb runAs
    Exit
}

# Run the VBS script
Start-Process "wscript.exe" -ArgumentList $vbsPath
