#!/bin/bash
echo "Finding all living IPs..."
start=`echo $1 | cut -d "." -f4`
end=$2
ip=`echo $1 | cut -d "." -f1-3`
while (( start<=end )); do
 ping `echo $ip`.`echo $start` -nqc 1 -w 1 1>/dev/null
 if [ $? -eq 0 ]; then
   echo "$ip.$start Live.."
   iip=`echo "$ip.$start"`
   hhs=`ssh $iip -p 2222 2>/dev/stdout`
   echo $hhs | awk '$NF ~/ssh-dss/ {print "=>>> It is likely:",$5}'
 fi
 (( start++ ))
done
