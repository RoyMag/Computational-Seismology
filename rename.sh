#!/bin/bash

for d in */
do
(cd $d && 
pwd
ls *.SAC > name.txt
n=`cat name.txt | wc -l`
for i in $(seq 1 1 $n)
do
name1=`cat name.txt | awk -v a=$i 'NR==a {print $0}'`
name2=`cat name.txt | awk -v b=$i -F"." 'NR==b {print $8"."$1"."$2"."$3"."$4"."$5"."$10}'`
mv "${name1}" "${name2}"
done
rm -rf name.txt)
done
