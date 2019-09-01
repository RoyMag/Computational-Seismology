#!/bin/bash

rdseed -d -o 1 -p -f *.seed
#rm -rf 2.txt* filenames.txt*

l=`cat tarim_XW_EvtCat.txt |  wc -l | awk '{print $1-1}'`

for i in `seq 1 1 $l`
do
date=`cat tarim_XW_EvtCat.txt | tail -n +2 | awk -v j=$i -F"," 'NR==j {print $3}' | awk -F"-" '{print $1"\t"$2"\t"$3}'`
year=`echo $date | awk '{print $1}'`
month=`echo $date | awk '{print $2}'`
day=`echo $date | awk '{print $3}'`

n=`echo $year | awk '{if ($1%400==0) print 1; else if ($1%100==0) print 0; else if ($1%4==0) print 1; else print 0}'`

if [ $n -eq 0 ]
then
	jd=`cat years.txt | awk -v k=$month -v d=$day 'BEGIN{
	}
	NR<=k  {
	l[NR]=$2
	sum+=l[NR]
	}
	END {
	s=sum+d
	print s
	}'`

elif [ $n -eq 1 ]
then
	jd=`cat years.txt | awk -v k=$month -v d=$day 'BEGIN{
	}
	NR<=k  {
	l[NR]=$3
	sum+=l[NR]
	}
	END {
	s=sum+d
	print s
	}'`
fi

jdd=`echo $jd | awk '{if ($1<=9) print "00"$1; else if ($1>=10 && $1<=99) print "0"$1; else print $1}'`
f=`cat tarim_XW_EvtCat.txt | tail -n +2 | awk -F"," -v j=$i 'NR==j {print $3}' | awk -F"-" '{print $1}'`
p=`cat tarim_XW_EvtCat.txt | tail -n +2 | awk -F"," -v j=$i 'NR==j {print $4}' | awk -F"." '{print $1}' | awk -F":" '{print $1"."$2"."$3}'`
a=`cat tarim_XW_EvtCat.txt | tail -n +2 | awk -F"," -v j=$i 'NR==j {print $4}' | awk -F"." '{print $2}' | awk '{if ($1=="") print "00"; else print $1}'`
mag=`cat tarim_XW_EvtCat.txt | tail -n +2 | awk -F"," -v j=$i 'NR==j {print $11}'` 
od=`cat tarim_XW_EvtCat.txt | tail -n +2 | awk -F"," -v j=$i -v b=$f -v q=$jdd -v z=$p -v c=$a 'NR==j {print b"."q"."z"\t"c"\t"$5"\t"$6"\t"$7"\t"}' `
echo $od $mag >> 2.txt
done

for i in `ls *BHN*SAC`
do
y=`echo $i | awk -F".BHN" '{print $1}'`
echo $y | awk '{print $1".BHE.M.SAC""\t"$1".BHN.M.SAC""\t"$1".BHZ.M.SAC"}' >> filenames.txt
done

for name in $(cat filenames.txt | awk '{print $1}' | awk -F"." '{print $1"."$2"."$3"."$4"."$5}')
do
na=`cat 2.txt | awk '{print $1}'`

for i in $na
do
#echo $i $name
if [ "$name" = "$i" ]
then
	no=`cat 2.txt | awk '{print $1}' | grep  -n ^"$i" | awk -F":" '{print $1}'`  
	lat=`cat 2.txt | awk -v n=$no 'NR==n {print $3}'`
	lon=`cat 2.txt | awk -v n=$no 'NR==n {print $4}'`
	dep=`cat 2.txt | awk -v n=$no 'NR==n {print $5*1000}'`
	magni=`cat 2.txt | awk -v n=$no 'NR==n {print $6}'`
	ori=`cat 2.txt | awk -v n=$no 'NR==n {print $1"\t"$2}' | awk -F"." '{print $1"\t"$2"\t"$3"\t"$4"\t"$5}'`
	ori1=`echo $ori | awk '{print $1}'`
	ori2=`echo $ori | awk '{print $2}'`
	ori3=`echo $ori | awk '{print $3}'`
	ori4=`echo $ori | awk '{print $4}'`
	ori5=`echo $ori | awk '{print $5}'`
	ori6=`echo $ori | awk '{print $6}'`
	#echo $lat $lon $dep $ori $magni
sac<<!
r $i*
ch EVLA $lat
ch EVLO $lon
ch EVDP $dep
ch MAG $magni
ch o gmt $ori1 $ori2 $ori3 $ori4 $ori5 $ori6
w over
q
!
fi
done
#break
done

rm -rf 2.txt* filenames.txt* tarim_XW_EvtCat.txt* years.txt* *.seed