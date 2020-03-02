Write-Host "Scanning: $args"
nmap -T4 -A -v -oX nmap_output.xml $args[0]
Write-Host "Finished Scanning, starting to parse"