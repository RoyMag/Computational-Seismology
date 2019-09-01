#!/bin/bash

rm -rf final.txt

text=`echo final.txt`
echo STN-PAIR"\t"STLA1"\t"STLO1"\t"DIST1"\t"STLA2"\t"STLO2"\t"DIST2"\t"D12"\t"THETA"\t"Q0"\t"eta"\n" > ${text}

for d in $(cat events.txt | tail -n +1 | head -100)
do

echo $d
cd $d
#pwd
path=`pwd`

ev=`echo ${path} | awk -F"/" '{print $8}'`

#rm -rf final.txt

distaz()
{
	pi=3.141592654
	lat1=`echo $1 $pi | awk '{ print $1*$2/180 }'`
	lon1=`echo $2 $pi | awk '{ print $1*$2/180 }'`
	lat2=`echo $3 $pi | awk '{ print $1*$2/180 }'`
	lon2=`echo $4 $pi | awk '{ print $1*$2/180 }'`
	theta=`echo $lat1 $lon1 $lat2 $lon2 | awk '{ print (sin($1)*sin($3)+cos($1)*cos($3)*cos($2-$4)) }'`
acos=`python<<!
import math
print math.acos($theta)
!`
	delta=`echo $acos $pi | awk '{ print $1*180/$2 }'`
	echo ${delta}
}

#text=`echo final.txt`
#echo STN-PAIR"\t"STLA1"\t"STLO1"\t"DIST1"\t"STLA2"\t"STLO2"\t"DIST2"\t"D12"\t"THETA"\t"Q0"\t"eta"\n" > ${text}

N=`cat goodPair.txt | wc -l`

for i in $(seq 1 1 $N)
do

pair=`cat goodPair.txt | awk -v p=$i 'NR==p {print $0}'`
echo ${pair}

cd ${ev}
check=`ls ${pair}`

if [ -z "${check}" ] # to check if variable is empty
then
	cd ..
else
	cd ${pair}
	#pwd

	stn1=`cat Stn-Eq-Dist.dat | sort -g -k3 | head -1 | awk '{print $1}'`
	stn2=`cat Stn-Eq-Dist.dat | sort -g -k3 | tail -1 | awk '{print $1}'`

	stla1=`saclhdr -STLA ${stn1}.*HZ`
	stlo1=`saclhdr -STLO ${stn1}.*HZ`
	dist1=`saclhdr -DIST ${stn1}.*HZ`
	stla2=`saclhdr -STLA ${stn2}.*HZ`
	stlo2=`saclhdr -STLO ${stn2}.*HZ`
	dist2=`saclhdr -DIST ${stn2}.*HZ` 
	dist12=`distaz $stla1 $stlo1 $stla2 $stlo2 | awk '{printf "%.3f", $1*111.2}'`
	az1=`saclhdr -AZ ${stn1}.*HZ`
	az2=`saclhdr -AZ ${stn2}.*HZ`
	theta=`echo ${az1} ${az2} | awk '{if ($1<$2) printf "%.3f", $2-$1; else printf "%.3f", $1-$2}'`

	N=`wc -l X_Y.dat | awk '{print $1}'`
	avgX=`awk 'BEGIN{SUM=0}{SUM=SUM+$1}END{print SUM/'$N'}' X_Y.dat`
	avgY=`awk 'BEGIN{SUM=0}{SUM=SUM+$2}END{print SUM/'$N'}' X_Y.dat`
	Nr=`awk -v X=$avgX -v Y=$avgY 'BEGIN{SUM=0}{SUM=SUM+($1-'X')*($2-'Y')}END{print SUM}' X_Y.dat`
	Dr=`awk -v X=$avgX -v Y=$avgY 'BEGIN{SUM=0}{SUM=SUM+($1-'X')*($1-'X')}END{print SUM}' X_Y.dat`

	slope=`echo $Nr $Dr | awk '{print $1/$2}'`
	IntCpt=`echo $avgX $avgY $slope | awk '{print $2-$3*$1}'`

	e=2.71828182846
	Q0=`echo $e $IntCpt |awk '{printf "%d\n", $1^(-$2)}'`
	eta=`echo $slope | awk '{printf "%.2f\n", 1-$1}'`

	cd ../..

	echo ${stla1}"\t"${stlo1}"\t"${dist1}"\t"${stla2}"\t"${stlo2}"\t"${dist2}"\t"${dist12}"\t"${theta}"\t"${Q0}"\t"${eta}
	echo  ${stn1}"-"${stn2}"\t"${stla1}"\t"${stlo1}"\t"${dist1}"\t"${stla2}"\t"${stlo2}"\t"${dist2}"\t"${dist12}"\t"${theta}"\t"${Q0}"\t"${eta} >> /home/magneto/Thesis/tarimBasin/XW_1997-2001/XW_all_events_1/${text}
fi

done

cd ..
#break
done
#mv ${text} ..


