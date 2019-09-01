#!/bin/bash

rm -rf *.dat_* Q_eta.dat

for file in two-station_freq_amp.dat
do

for iteration in $(seq 1 1 50) ### Change number of iterations if required
do

N=`cat ${file} | wc -l`
count=0
count2=0

while [ ${count} -le $N ]
do

if [ ${count} = $N ] 
then
	break
else

n=`python<<!
import random
for x in range(1) :
	print random.randint(1,$N)
!`

echo The line number taken from the data text-file is "\"$n"\"


n2=`echo $N $count | awk '{print $1-$2}'`

count2=`python<<!
import random
for y in range(1) :
	print random.randint(1,$n2)
!`
if [ ${count2} = $N ]
then
	break
else

echo The number of repetition of the amplitude choosen randomly is "\"${count2}"\"

frAm=`cat ${file} | awk -v a=$n 'NR==a {print $0}'`
echo The frequency, amplitude of both station and amplitude ratio choosen are "\"${frAm}"\"
echo -------------------------------------------------------------------------------

	for i in $(seq 1 1 ${count2})
	do
		echo ${frAm} | awk '{print $0}' >> ${file}_${iteration}.txt
	done
	
	count=`echo ${count} ${count2} | awk '{print $1+$2}'`

fi

fi

done

cat ${file}_${iteration}.txt | sort -g -k1 >> ${file}_${iteration}
rm -rf ${file}_${iteration}.txt

done
done

echo "sh" "~/Thesis/newScripts/bs_Q_eta_value.sh" | sh

