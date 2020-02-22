#!/bin/bash

if [ $# -lt 1 ]
then
	echo " Need a file to Work on!!!"	
	exit 0	
fi

if [ $# -lt 2 ] 
then
	c=8
else
	c=$2
fi

t=` wc -l $1 `
l=`echo $t | cut  -d' ' -f1`

#echo "l: $l c: $c"

dis=`expr $l - $c + 1`

tail -n $dis $1

