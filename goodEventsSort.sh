#!/bin/bash

for d in */
do

( cd $d &&
mkdir BAD

for file in `ls *.BHZ`
do

evt=`echo ${file} | awk -F"BHZ" '{print $1}'`
sac <<!
r ${evt}*
ppk
q
!

read -p "Is it a good event? (press n for bad & y for good): " ans

if [ ${ans} = "n" ]
then	
	mv ${evt}* BAD
fi

done )

done
