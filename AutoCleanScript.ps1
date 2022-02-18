<# Auto clean Idea 1:
1.Fetch Files by size + input of user for host
2.If files > 5 GB  delete the files

Idea 2:
1.Fetch Files by size + input of user for host
2.Sort files by date, delete oldest in a certain folder/or 

#>

function cleanUP() {
[CmdletBinding]

  $cred = Get-Credential
  $Server = Read-Host -Prompt "Write the host iP"

 New-PSSession -ComputerName $Server -Credential $cred

}

function FunctionName {
    [CmdletBinding]
     
     $initF = Get-ChildItem -Path "D:\" -Recurse | Sort-Object Lenght -Descending | if{$_.Lenght -gt 1} {
         Remove-Item
     }
     
      if($initF -gt 1) {

      }

    
}
cleanUP


Invoke-Command -command {FunctionName}