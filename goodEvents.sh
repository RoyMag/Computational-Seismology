#!/bin/sh

for file in *BHZ*SAC
do
l=`echo $file | awk -F"BHZ" '{print $1}'`
sac <<!
r $l*
ppk
q
!

read -p "Is it a good event: " ans

if [ $ans = "y" ]
then
	echo $l	
	echo $l >> goodEvents.txt
fi
done
