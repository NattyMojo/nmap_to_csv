#!/bin/bash
echo "Scanning:" $1
nmap -T4 -A -v -oX nmap_output.xml $1
echo "Finished nmap, starting awk"
awk -F\" '/<port protocol/ {print $4","$2","$6","}; /<os>/{port=$6;protocol=$4;status=$2}; /<osmatch/ {print port","protocol","status","$2}' nmap_output.xml > nmap_csv.csv
echo "Your file is ready"
#rm -f nmap_output.xml
cat nmap_csv.csv

