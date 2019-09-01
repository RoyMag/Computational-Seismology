#!/bin/bash

for d in $(cat events.txt | tail -n +1)
do

cd $d
path=`pwd`

ev=`echo $path | awk -F"/" '{print $8}'`

cd $ev

for d in $(cat ../goodPair.txt)
do

cd $d

stn1=`cat Stn-Eq-Dist.dat | sort -g -k3 | head -1 | awk '{print $1}'`
stn2=`cat Stn-Eq-Dist.dat | sort -g -k3 | tail -1 | awk '{print $1}'`

gs ${stn1}"-"${stn2}.ps

cd ..

done

cd ../..

done
