<#

Note: The aim of this script is to automate a series of manual tasks,
which include cleaning server side errors, log information retrieval and resolving replication issues.
Relevant to windows environments, windows servers in general and most applicable for System Administrators

#>

$cred = Get-Credential
$list = @("10.30.20.27","10.30.20.35","10.30.20.71", "10.30.20.8"); #A list of servers, could be VM's or local.

$s = New-PSSession -ComputerName $list -Credential $cred; 

Invoke-Command -Session $s -ScriptBlock {
# Specify the locations of the directories you want to go through
    $files = (Get-ChildItem -Path "Directory path" -Include "*.old" -Recurse); #Filter out the type of files or specify a string pattern
    $files1 = (Get-ChildItem -Path "Directory path" -Include "*.old" -Recurse); #If you want to specify a string pattern, you would use:
    $files2 = (Get-ChildItem -Path "Directory path" -Include "*.old" -Recurse); #The Select-String cmdlet

    $hosts = @($files, $files1, $files2);

    foreach($item in $hosts) {
        $item; # Call the variable in order to avoid double-hop issue with PS remoting if applicable and loop through the items; 

      foreach($file in $files, $files1, $files2) {
          $file; # Call the variable in order to avoid double-hop issue with PS remoting if applicable nd loop through the items;

      Get-Content $file | Select-String -Pattern "error";
      Clear-Content $file -Force;
      
      break;
    }
    
    Write-Host "Replication logs retrieved and errors cleaned";

    # Retrieve and delete specific files;

    $Path = "Directory path";

    Get-ChildItem $Path -Recurse | Where-Object{$_.Name -match "file name/type"} | Remove-Item -Force;
    Write-Host "Whatever message you like";
 }
 
}
$s | Remove-PSSession 

# The script below can clear specific errors but also retrieves and stops certain processes;
# This is highly subjective, depending on the environment and architecture;

$c = New-PSSession -ComputerName 10.30.20.139 -Credential $cred;

Invoke-Command -session $c -ScriptBlock {

  Get-Service "fss_dev, fes_prod, etc." | Stop-Service; #Service names
  Get-ChildItem -Path "Directory path" | Get-Content;
  Remove-Item -Path "Directory path" -Force;

  Start-Service "The services";
  Write-Host "whatever you would like";
}
$c | Remove-PSSession
