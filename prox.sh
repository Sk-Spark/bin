#!/bin/bash

d="$HOME/.prox"
if [ ! -d "$d" ];then mkdir $d; fi
wget -qO $d/proxy http://172.31.9.69/dc/api/proxy
# speed
egrep -o "\"speed\":\"[0-9]{1,5}([\.][0-9]{1,4} (MB|KB)| (KB|MB))" $d/proxy | cut -d: -f2 | tr -d "\"" > $d/s1
if [ `cat $d/s1 | wc -l` -eq 0 ];then echo -e "Unable to fetch proxy servers !!"; exit 1; fi
egrep -o "\"speed_kbps\":\"[0-9]{1,8}" $d/proxy | cut -d: -f2 | tr -d "\"" > $d/s2
sort -gr $d/s2 > $d/s3
# ip
egrep -o "\"ip\":\"172.31.[0-9]{1,3}\.[0-9]{1,3}" $d/proxy | cut -d: -f2 | tr -d "\"" > $d/ip
j=`cat $d/ip | wc -l`
for ((i=1; i<=j; i++)); do
	ip=`awk -v x=$i 'NR==x {print $0}' $d/ip`
	s1=`awk -v x=$i 'NR==x {print $0}' $d/s1`
	echo -e "$ip\t$s1"
done > $d/lst
# sorting
for ((i=1; i<=j; i++)); do
   x=`awk -v a=$i 'NR==a {print $0}' $d/s3`
   y=`grep -n "$x" $d/s2 | cut -d: -f1`
   z=`head -n$y $d/lst | tail -n1 | cut -f1`
   w=`head -n$y $d/lst | tail -n1 | cut -f2`
   echo -e "$z\t$w/s"
done > $d/lst2
echo "-------------------------"
echo -e "IP\t\tSpeed"
echo "-------------------------"
cat $d/lst2
echo "-------------------------"
proxy=`head -n1 $d/lst2 | cut -f1`
port=3128
echo -e "High Speed --> [$proxy]\t[$port]"
# gsettings
if [ `which gsettings | wc -l` -ne 0 ];then
	echo -en "Applying system proxy"
	gsettings set org.gnome.system.proxy mode "manual"
	gsettings set org.gnome.system.proxy.http host $proxy
	gsettings set org.gnome.system.proxy.http port $port
	gsettings set org.gnome.system.proxy.https host $proxy
	gsettings set org.gnome.system.proxy.https port $port
	gsettings set org.gnome.system.proxy.ftp host $proxy
	gsettings set org.gnome.system.proxy.ftp port $port
	gsettings set org.gnome.system.proxy.socks host $proxy
	gsettings set org.gnome.system.proxy.socks port $port
	gsettings set org.gnome.system.proxy.http authentication-user "edcguest"
	gsettings set org.gnome.system.proxy.http authentication-password "edcguest"
	echo -e "\t[ DONE ]"
fi
rm -r $d
