<# Author: Voivoda1

Note: The aim of this script is to automate a series of manual tasks,
which include cleaning server side errors, log information retrieval and resolving replication issues.

#>

$cred = Get-Credential
$list = @("10.30.20.27","10.30.20.35","10.30.20.71", "10.30.20.8"); #A list of VM's

$s = New-PSSession -ComputerName $list -Credential $cred; 

Invoke-Command -Session $s -ScriptBlock {

    $files = (Get-ChildItem -Path "S:\MDfiles" -Include "*.old" -Recurse);
    $files1 = (Get-ChildItem -Path "D:\olapSaverFiles" -Include "*.old" -Recurse);
    $files2 = (Get-ChildItem -Path "D:\MDfiles" -Include "*.old" -Recurse);

    $hosts = @($files, $files1, $files2);

    foreach($item in $hosts) {
        $item; # Call the variable in order to avoid double-hop issue with PS remoting if applicable;

      foreach($file in $files, $files1, $files2) {
          $file; # Call the variable in order to avoid double-hop issue with PS remoting if applicable;

      Get-Content $file | Select-String -Pattern "error";
      Clear-Content $file -Force;
      
      break;
    }
    
    Write-Host "Replication logs retrieved and errors cleaned";

    # Retrieve the resend files and delete them;

    $Path = "D:\olapSaverFiles\";

    Get-ChildItem $Path -Recurse | Where-Object{$_.Name -match "resend"} | Remove-Item -Force;
    Write-Host "Resend files deleted";
 }
 
}
$s | Remove-PSSession 

# The script below clears OS_DEV139 errors;

$c = New-PSSession -ComputerName 10.30.20.139 -Credential $cred;

Invoke-Command -session $c -ScriptBlock {

  Get-Service pyr_fcs_dev, pyr_fms_dev, pyr_fms_dev_2 | Stop-Service;
  Get-ChildItem -Path "D:\configs\fcs\OlapStatus.dat" | Get-Content;
  Remove-Item -Path "D:\configs\fcs\OlapStatus.dat" -Force;

  Start-Service pyr_fcs_dev, pyr_fms_dev, pyr_fms_dev_2;
  Write-Host "Pyr_fcs and fms services restarted and OlapStatus.dat deleted";
}
$c | Remove-PSSession
