#!/bin/bash
echo "Scanning:" $1
nmap -T4 -A -v $1 > nmap_output.txt
echo "Finished nmap, starting awk"
awk  'BEGIN {FS = "("}; "//Discovered/ {print $6","$4","$2",,"}; /Completed Ping Scan/ {print ",,,"$2" "$3","$8}' nmap_output.txt > nmap_csv_output.csv
echo "Your file is ready"
cat nmap_csv_output.csv
