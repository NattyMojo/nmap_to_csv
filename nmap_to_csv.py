import os
import sys
import re

if(len(sys.argv) != 2):
    print("Usage: $python3 nmap_to_csv.py {address or IP}")
    exit(0)

#Setup the Nmap
print("Scanning: " + sys.argv[1])
#os.system("nmap -T4 -A -v -oX nmap_output.xml " + sys.argv[1])
print("Finished nmap, starting to parse")

#Create File the output will go into
csv_file = open("nmap_csv.csv", "w")

#Parse through the XML file output by the Nmap
f = open("nmap_output.xml","r")
port = protocol = status = np = pro = ""
for line in f:
    brokenLine = re.split(r'["\s]',line)
    if "<port protocol" in line:
        try:
            csv_file.write("\n{},{},{},,,".format(brokenLine[brokenLine.index("portid=")+1],brokenLine[brokenLine.index("protocol=")+1],brokenLine[brokenLine.index("state=")+1]))
        except:
            pass
    elif "<os>" in line:
        try:
            port = brokenLine[brokenLine.index("portid=")+1]
            protocol = brokenLine[brokenLine.index("proto=")+1]
            status = brokenLine[brokenLine.index("state=")+1]
        except:
            pass
    elif "<osmatch" in line:
        try:
            csv_file.write("\n{},{},{},{},,".format(port, protocol, status, brokenLine[brokenLine.index("name=")+1]))
        except:
            pass
    elif "<trace" in line:
        try:
            np=brokenLine[brokenLine.index("port=")+1]
            pro=brokenLine[brokenLine.index("proto=")+1]
        except:
            pass
    elif "<hop" in line:
        try:
            csv_file.write("\n{},{},,,{},{}".format(np, pro, brokenLine[brokenLine.index("ttl=")+1], brokenLine[brokenLine.index("ipaddr=")+1]))
        except:
            pass

#Close open files
f.close()
csv_file.close()

#Print the file
read = open("nmap_csv.csv","r")
for line in read:
    print(line)

#Close CSV file after printing
read.close()
