#!/bin/bash

out=`echo contour.txt`
rm -rf ${out}

for d in ????.???.??.??.??
do

cd $d
pwd
 
N=`cat final.txt | wc -l`

for i in $(seq 3 1 $N)
do

lat=`cat final.txt | awk -v a=$i 'NR==a {print ($2+$5)/2}'`
lon=`cat final.txt | awk -v a=$i 'NR==a {print ($3+$6)/2}'`
q=`cat final.txt | awk -v a=$i 'NR==a {print $10}'`

echo ${lon}"\t"${lat}"\t"$q >> ../${out}

done

cd ..
pwd

done
