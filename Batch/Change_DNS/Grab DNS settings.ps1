$dnsservers = "172.16.0.5","172.16.0.6"
$computers = Get-Content ComputerList.txt
foreach ($comp in $computers)
{

	$adapters = gwmi -q "select * from win32_networkadapterconfiguration where ipenabled='true'" -ComputerName $comp
	foreach ($adapter in $adapters)
	{
		$adapter.setDNSServerSearchOrder($dnsservers)
	}
	
}
