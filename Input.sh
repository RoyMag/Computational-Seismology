#!/bin/bash

rm -rf Input.txt

N=`cat final.txt | wc -l`

for i in $(seq 3 1 $N)
do

data=`cat final.txt | awk -v a=$i 'NR==a {print $1"\t"$3"\t"$2"\t"$6"\t"$5"\t"$8"\t"$10}'`
echo ${data} >> Input.txt

done
