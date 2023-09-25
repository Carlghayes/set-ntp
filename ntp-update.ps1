#Connect to Vcenter
Connect-VIServer -Server <vCenterServer> -User <Username> -Password <Password>

#Get a list of Hypervisors
$esxiHosts = Get-VMHost

#Set NTP Servers on Each Hypervisor
foreach ($esxiHost in $esxiHosts) {
    $ntpServers = "ntp1.example.com", "ntp2.example.com"  # Replace with your NTP server(s)
    Set-VMHostNtpServer -NtpServer $ntpServers -VMHost $esxiHost
}

#Configure NTP Settings

foreach ($esxiHost in $esxiHosts) {
    Set-VMHostService -HostService ($esxiHost | Get-VMHostService | Where-Object {$_.Key -eq "ntpd"}) -Policy "on"
    $esxiHost | Get-VMHostFirewallException | Where-Object {$_.Name -eq "NTP client"} | Set-VMHostFirewallException -Enabled:$true
}

#Disconnect from Vcenter
Disconnect-VIServer -Server * -Confirm:$false

