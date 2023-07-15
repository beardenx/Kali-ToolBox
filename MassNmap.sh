#!/usr/bin/bash

# masscan + nmap

printf "### MASSCAN + NMAP\n"
printf "Usage: MassNmap <ip> <iface>\n"
printf "\n[+] Checking ICMP\n"
if ping -c 1 $1 &> /dev/null
then
	printf "[+] Ping success! Executing MASSCAN\n"
	printf "[+] CMD: sudo masscan -p1-65535 --rate 1000 -e $2 $1\n"
	sudo /usr/bin/masscan -p1-65535 --rate 1000 -e $2 $1 > TCP_masscan_$1
	ports=$(cat TCP_masscan_$1 | awk -F " " {'print $4'} | awk -F "/" {'print $1'} | sort -nu | tr "\n" "," | sed s/,$//)
	printf "\n[+] Ports: $ports\n\n"
	printf "[+] Executing NMAP\n"
	printf "[+] CMD: sudo nmap -sC -sV -A -Pn -p$ports --version-intensity 5 -oA TCP_nmap_$1 $1\n\n"
	sudo /usr/bin/nmap -sC -sV -A -Pn -p$ports --version-intensity 5 -oA TCP_nmap_$1 $1
	printf "\n[+] NMAP completed! Happy hacking :)\n"
else
	printf "\n[+] Ping unsuccessful. Please check your connection/command!\n"
fi
