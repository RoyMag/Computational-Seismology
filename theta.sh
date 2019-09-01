#!/bin/bash

#rm -rf ../badPairs
#mkdir ../badPairs

for d in $(cat events.txt | tail -n +1)
do

echo $d
cd $d/$d
#pwd
echo --------------------------------------------------------------------
echo --------------------------------------------------------------------
ls > twoPair.txt
#N=`cat twoPair.txt | wc -l`
sed -i 's/twoPair.txt/ /g' twoPair.txt

for d in $(cat twoPair.txt | tail -n +1)
do 

#echo $d
cd $d

stn1=`cat Stn-Eq-Dist.dat | sort -g -k3 | head -1 | awk '{print $1}'`
stn2=`cat Stn-Eq-Dist.dat | sort -g -k3 | tail -1 | awk '{print $1}'`

az1=`saclhdr -AZ ${stn1}.????.???.??.??.??.?HZ`
az2=`saclhdr -AZ ${stn2}.????.???.??.??.??.?HZ`

theta=`echo $az1 $az2 | awk '{if ($1>$2) print $1-$2; else print $2-$1}'`
#echo $theta

cd ..

#echo $theta $d | awk '{if ($1>15) print "mv",$2,"../badPairs"}' | sh
echo $theta $d | awk '{if ($1>15) print $1, $2}'
echo $theta $d | awk '{if ($1>15) print "rm", "-rf", $2}' | sh

done
#break
cd ../..
done