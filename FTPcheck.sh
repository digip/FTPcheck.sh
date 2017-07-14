#!/bin/bash
##	ftp banner grab with masscan for anon ftp sessions
clear

if [ -f ./open-ftp.txt ]; then
	rm ./open-ftp.txt
fi

if [ -f ./paused.conf ]; then
	rm ./paused.conf
fi

masscan -p21 --banners --open-only $1 --rate=5000 | sort -u > ftp.txt #save full list

cat ftp.txt | cut -d" " -f 6 | sort -u > ip.txt
while read ip; do
##speedtest.tele2.net anon ftp test site
echo $ip >> open-ftp.txt
curl -m 6 ftp://$ip --user "anonymous:pass@" | echo $(grep r):$ip >> open-ftp.txt #append IP to output for later grepping
done < ip.txt
sleep 2
#cat ftp.txt | grep Banner #only show those with easy banners ##	uncomment if you want to see found banners
cat open-ftp.txt | grep r #if we found any, list their directory output
