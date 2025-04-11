param (
    [string]$vbsPath
)

if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    $arguments = "& '" + $myinvocation.mycommand.definition + "' -vbsPath '" + $vbsPath + "'"
    Start-Process powershell -ArgumentList $arguments -Verb runAs
    Exit
}

Start-Process "wscript.exe" -ArgumentList $vbsPath
