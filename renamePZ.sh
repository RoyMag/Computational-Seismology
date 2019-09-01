#!/bin/bash

#rm -rf name.txt
ls SAC_* > name.txt

n=`cat name.txt | wc -l`

for i in $(seq 1 1 $n)
do

name1=`cat name.txt | awk -v a=$i 'NR==a {print $0}'`
name2=`echo ${name1} | awk -F"__" '{print $1"_"$2}' | awk -F"_" '{print $1"."$2"."$3"."$4"."$5"."$6"."$7}' | awk -F"." '{print $4"_"$5"_"$6"_"$7"_"$12"_"$13"."$2}'`
mv ${name1} ${name2}

done
