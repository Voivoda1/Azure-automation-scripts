<# Create an array with hosts if multiple processes need to be stopped.
To be used only when certain processes have not been stopped autoamtically #>
$cred = Get-Credential

$list = @("10.30.33.8","10.30.33.27","10.30.33.32") #An array of servers

$s = New-PSSession -ComputerName $list -Credential $cred

Invoke-Command -Session $s -ScriptBlock {
    foreach($list in $list) {
        #Include the processes that need to be stopped
        Get-Process pyrsbbetdbmsmem, pyrdbmsmem64, pyrreportdbmsmem, pyrmarketdbmsmem64 | Stop-Process -Force
    }
}
#If you need to keep the session open, use the script without the line below
$s | Remove-PSSession
