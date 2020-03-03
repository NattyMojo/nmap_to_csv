Write-Host "Scanning: $args"
nmap -T4 -A -v -oX nmap_output.xml $args[0]
Write-Host "Finished Scanning, starting to parse"
Set-Content -Path nmap_csv.csv -value ''
$ErrorActionPreference = 'SilentlyContinue'
$port = 0
$portline = ""
$protocol = 0
$protocolline = ""
$status = 0
$statusline = ""
$np = 0
$npline = ""
$pro = 0
$proline = ""
foreach($line in (Get-Content nmap_output.xml)) {
	$newline = $line.Split("""").Split()
	If ($line.Contains("<port protocol")) {
		$portid = $newline.indexof("portid=")+1
		$protocol = $newline.indexof("protocol=")+1
		$status = $newline.indexof("state=")+1
		Add-Content nmap_csv.csv "`n$($newline[$portid]),$($newline[$protocol]),$($newline[$status]),,,"
	}
	ElseIf ($line.Contains("<os>")) {
		Set-Variable -Name "port" -Value "$($newline.indexof("portid=")+1)"
		Set-Variable -Name "portline" -Value "$($newline[$port])"
            	Set-Variable -Name "protocol" -Value "$($newline.indexof("proto=")+1)"
		Set-Variable -Name "protocolline" -Value "$($newline[$protocol])"
		Set-Variable -Name "status" -Value "$($newline.indexof("state=")+1)"
		Set-Variable -Name "statusline" -Value "$($newline[$status])"
        }
	ElseIf ($line.Contains("<osmatch")) {
		$name = $newline.indexof("name=")+1
        	Add-Content nmap_csv.csv "`n$($portline),$($protocolline),$($statusline),$($newline[$name]),,"
	}        
	ElseIf ($line.Contains("<trace")) {
        	Set-Variable -Name "np" -Value "$($newline.indexof("port=")+1)"
		Set-Variable -Name "npline" -Value "$($newline[$np])"
            	Set-Variable -Name "pro" -Value "$($newline.indexof("proto=")+1)"
		Set-Variable -Name "proline" -Value "$($newline[$pro])"
	}
	ElseIf ($line.Contains("<hop")) {
		$ttl = $newline.indexof("ttl=")+1
		$ipaddr = $newline.indexof("ipaddr=")+1
        	Add-Content nmap_csv.csv "`n$($npline),$($proline),,,$($newline[$ttl]),$($newline[$ipaddr])"
	}
}