$packageName = "OXAutomation"
$serviceName = $packageName
$username = "username"
$password = convertto-securestring -String "password" -AsPlainText -Force  

try { #error handling is only necessary if you need to do anything in addition to/instead of the main helpers
    $scriptPath = Split-Path $myInvocation.MyCommand.Path
    $installPath = Split-Path $myInvocation.MyCommand.Path
    $existingService = Get-WmiObject -Class Win32_Service -Filter "Name='$serviceName'"
    
    if ($existingService)
    {
        $PSCmdlet.ThrowTerminatingError("Service exists. Uninstall first.")
    }
    
    # Install service
    Write-Output "Installing service $packageName from $installPath.." | Out-Null
    
    $exePath = "$installPath\OXAutomationService.exe"
    $cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $password
    
    #New-Service -BinaryPathName $exePath -Name $serviceName -Credential $cred -DisplayName $serviceName -StartupType Automatic
    
    New-Service -BinaryPathName $exePath -Name $serviceName -DisplayName $serviceName -StartupType Automatic
    
    #$ShouldStartService = Read-Host "Would you like the '$serviceName ' service started? Y or N"
    #if($ShouldStartService -eq "Y")
    #{
    # Start service
    Write-Output "Starting service..."  | Out-Null
    
    "Waiting 5 seconds to allow service to be started."
    Start-Sleep -s 5  
    
    Start-Service $serviceName
    #}
} catch {
    throw 
}