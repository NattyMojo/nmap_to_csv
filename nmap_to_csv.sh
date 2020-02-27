#!/bin/bash
echo "Scanning:" $1
nmap -T4 -A -v -oX nmap_output.xml $1
echo "Finished nmap, starting awk"
awk  '/<port protocol/ {print $2","$3","$4}' nmap_output.xml > nmap_csv.csv
echo "Your file is ready"
rm -f nmap_output.xml
cat nmap_csv.csv
