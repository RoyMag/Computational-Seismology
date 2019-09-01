#!/bin/bash

N=`cat badPair.txt | wc -l`

for i in $(seq 1 1 $N)
do

folder=`cat badPair.txt | awk -v a=$i 'NR==a {if ($2==0 && $3==0) print $1}'`
mv ${folder} /home/magneto/Thesis/activeWork/DATA/badPairs

done
