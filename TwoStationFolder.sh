#!/bin/bash

for d in *
do

cd $d
pwd

ls *BHZ > events.txt

for evt in `ls *BHZ | awk -F"." '{print $2"."$3"."$4"."$5"."$6}' | uniq`
do

rm -rf ${evt}
mkdir ${evt}

done

N=`cat events.txt | wc -l`

for i in $(seq 1 1 $N)
do

M=`echo $N $i | awk '{print $1-$2}'`

for j in $(seq 1 1 $M)
do

L=`echo $i $j | awk '{print $1+$2}'`

stn1=`cat events.txt | awk -v a=$i 'NR==a {print $0}'`
stn2=`cat events.txt | awk -v b=$L 'NR==b {print $0}'`
code1=`echo ${stn1} | awk -F"." '{print $1}'`
code2=`echo ${stn2} | awk -F"." '{print $1}'`

mkdir ${code1}"-"${code2}
cp -rf ${code1}.*BHZ ${code1}"-"${code2}
cp -rf ${code2}.*BHZ ${code1}"-"${code2}
mv ${code1}"-"${code2} ${evt}
#mv ${evt} /home/magneto/Thesis/activeWork/DATA

done

done

#rm -rf events.txt
cd ..
#break
done

#echo "sh" "/home/magneto/Thesis/activeWork/DATA/Run.sh" | sh

