<#
  .SYNOPSIS
    Set up automated network tests writing results out to email.
    Author: Joe McCormack (@bmulley) 

  .PARAMETER 

#>

$resultdata=@()
$cumulative=@()
$computerconnect=@()
$computers=@("host1", "host2", "host3", "host4")
$servers=@("server1", "server2", "server3")





Foreach($computer in $computers)
{
    $computerdata=@()
    foreach($server in $servers)
    {
        $resultdata = New-Object PSObject
        $computerconnect = (Invoke-Command -computername $computer -ArgumentList $server -ScriptBlock {Test-NetConnection -ComputerName $using:server -TraceRoute})
        $resultdata | Add-Member -type NoteProperty -Name Hostname -Value $computer
        $resultdata | Add-Member -type NoteProperty -Name Server -Value $computerconnect.ComputerName
        $resultdata | Add-Member -type NoteProperty -Name TraceRoute -Value $computerconnect.TraceRoute
        $computerdata += $resultdata
    }
    $cumulative += $computerdata
}

$mail = $cumulative | Out-String

Send-MailMessage -From 'email@mail.com' -To 'email@mail.com' -Subject 'Test Results' -Body $mail -SmtpServer mail.mailserver.com

