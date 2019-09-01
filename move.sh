#!/bin/bash

N=`cat goodEvents.txt | wc -l`

for i in $(seq 1 1 $N)
do
evt=`cat goodEvents.txt | awk -v a=$i 'NR==a {print $0}' | awk -F"." '{print $1"."$2"."$3"."$4"."$5}'`
rm -rf ${evt}
mkdir ${evt}
cp -rf ${evt}*.M.SAC ${evt}
cp -rf ${evt} ~/Thesis/tarimBasin/XW_1997-2001/XW_all_events_1
done
