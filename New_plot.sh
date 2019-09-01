#!/bin/bash

for d in $(cat events.txt | head -100)
do

echo ${d}

ev=`echo ${d}`
cd ~/Thesis/tarimBasin/XW_1997-2001/XW_all_events_1/${ev}/${ev}

for pair in *
do

echo ${pair}

cd ${pair}

stn1=`cat Stn-Eq-Dist.dat | sort -g -k3 | head -1 | awk '{print $1}'`
stn2=`cat Stn-Eq-Dist.dat | sort -g -k3 | tail -1 | awk '{print $1}'`

az1=`saclhdr -AZ ${stn1}.????.???.??.??.??.?HZ`
az2=`saclhdr -AZ ${stn2}.????.???.??.??.??.?HZ`

#theta=`echo ${az1} ${az2} | awk '{if ($1>$2) print $1-$2; else print $2-$1}'`
#cd ..

#echo ${theta} ${pair} | awk '{if ($1>15) print "mv", $2, "/home/magneto/Thesis/tarimBasin/XW_1997-2001/badPairs"}' | sh
#cd ${pair}

gmt clear history

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

dist1=`cat Stn-Eq-Dist.dat | sort -g -k3 | head -1 | awk '{print $3}'`
dist2=`cat Stn-Eq-Dist.dat | sort -g -k3 | tail -1 | awk '{print $3}'`
stn1=`cat Stn-Eq-Dist.dat | sort -g -k3 | head -1 | awk '{print $1}'`
stn2=`cat Stn-Eq-Dist.dat | sort -g -k3 | tail -1 | awk '{print $1}'`
echo $stn1 $stn2 $dist1 $dist2

stla1=`sac<<! | grep STLA | awk '{print $3}'
r ${stn1}.????.???.??.??.??.?HZ
lh STLA
q
!`
stlo1=`sac<<! | grep STLO| awk '{print $3}'
r ${stn1}.????.???.??.??.??.?HZ
lh STLO
q
!`

stla2=`sac<<! | grep STLA | awk '{print $3}'
r ${stn2}.????.???.??.??.??.?HZ
lh STLA
q
!`
stlo2=`sac<<! | grep STLO| awk '{print $3}'
r ${stn2}.????.???.??.??.??.?HZ
lh STLO
q
!`
echo $stla1 $stlo1 $stla2 $stlo2
dist12=`distaz $stla1 $stlo1 $stla2 $stlo2 | awk '{print $1*111.2}'`
echo ${dist12}

n1=`cat ${stn1}_*_fq-amp_new.dat | awk '{if($1>=0.5 && $1<=2) print $0}'|wc -l`
n2=`cat ${stn2}_*_fq-amp_new.dat | awk '{if($1>=0.5 && $1<=2) print $0}'|wc -l`

st=`echo $n1 $n2|awk -v s1=$stn1 -v s2=$stn2 '{if($1<$2) print s1; else print s2}'`
##echo "Station is $st"
rm -rf two-station_freq_amp.dat
for freq in `cat ${st}_*_fq-amp_new.dat | awk '{if($1>=0.5 && $1<=2) print $1}'`
#for freq in `cat ${st}_*_fq-amp_new.dat | awk '{if($1>=0.5 && $1<=1.5) print $1}'`
do
freq1=`echo $freq | awk '{a=substr($1,1,6);print a}'`
amp1=`grep ^${freq1} ${stn1}_*_fq-amp_new.dat | awk '{print $2}'`
amp2=`grep ^${freq1} ${stn2}_*_fq-amp_new.dat | awk '{print $2}'`
ratio=`echo $amp1 $amp2 | awk '{print $1/$2}'`
##echo $freq $amp1 $amp2 $ratio
echo $freq $amp1 $amp2 $ratio >> two-station_freq_amp.dat
#echo  $freq1 $amp1
done

awk -v d1=$dist1 -v d2=$dist2 '{if($4!=NaN) print $1,log(sqrt('d1'/'d2')*$4)}' two-station_freq_amp.dat > Fq-LnRf

awk -v d12=$dist12 '{if($2>0) print $1,(((3.5*7)/(22*'d12'))*$2)}' Fq-LnRf > LnRf_vs_Lnf.dat

### Calculation of intercept and hence Q0 by LS fitting a line
awk '{print log($1),log($2)}' LnRf_vs_Lnf.dat > X_Y.dat
#awk '{print log($1),log($2)}' LnRf_vs_Lnf.dat > X_Y.dat1
#awk '{if($1>=-0.6 && $1<=0.4) print $1,$2}' X_Y.dat1 > X_Y.dat
#awk '{if($1<=1.5) print $1,$2}' LnRf_vs_Lnf.dat > X_Y.dat
N=`wc -l X_Y.dat | awk '{print $1}'`
avgX=`awk 'BEGIN{SUM=0}{SUM=SUM+$1}END{print SUM/'$N'}' X_Y.dat`
avgY=`awk 'BEGIN{SUM=0}{SUM=SUM+$2}END{print SUM/'$N'}' X_Y.dat`
Nr=`awk -v X=$avgX -v Y=$avgY 'BEGIN{SUM=0}{SUM=SUM+($1-'X')*($2-'Y')}END{print SUM}' X_Y.dat`
Dr=`awk -v X=$avgX -v Y=$avgY 'BEGIN{SUM=0}{SUM=SUM+($1-'X')*($1-'X')}END{print SUM}' X_Y.dat`

slope=`echo $Nr $Dr | awk '{print $1/$2}'`
IntCpt=`echo $avgX $avgY $slope | awk '{print $2-$3*$1}'`
####END LS

###Q calculations and GMT Plots at diff Freq
#!/bin/bash
#gmtset FONT_ANNOT_PRIMARY 16,Times-Bold,black
gmtset FONT_ANNOT_PRIMARY 16,Times,black
gmtset FONT_LABEL 18,Times,black
gmtset MAP_ANNOT_OFFSET_PRIMARY .1
gmtset MAP_TICK_PEN 1p

out=`echo ${stn1}-${stn2}.ps`
x1=-.7
x2=.7
psbasemap -R-.8/.8/-8/0 -JX5i/5i -Bxa.2g.1 -Bya2g1 -BWSen -Bx+l"ln(frequency)" -By+l"ln(P(frequency))" -K -P -X1.3i -Y6i > $out
awk '{print $1,$2}' X_Y.dat | psxy -Sc.1 -R -J -Gyellow -W.1 -K -O >> $out 
Yval1=`echo $x1 $slope $IntCpt | awk '{print $2*$1+$3}'`
Yval2=`echo $x2 $slope $IntCpt | awk '{print $2*$1+$3}'`
echo $x1 $Yval1
psxy -R -J -W1,black,dashed -K -O <<!>> $out
$x1,$Yval1
$x2,$Yval2
!
echo $x1 $x2 $Yval1 $Yval2 
echo Slope=$slope and intercept=$IntCpt
e=2.71828182846
Q0=`echo $e $IntCpt |awk '{printf "%d\n", $1^(-$2)}'`
echo Q0 value is $Q0
eta=`echo $slope | awk '{printf "%.2f\n", 1-$1}'`
echo eta value is $eta
echo "-.7 -0.5 18 0 5 "ML" "$stn1 - $stn2""| pstext -R -J -K -O -Gwhite >> $out
echo "-.7 -1 18 0 5 "ML" Q@-0@- = $Q0"| pstext -R -J -K -O -Gwhite >> $out
echo "-0.69 -1.5 18 0 12 "ML" \150"| pstext -R -J -K -O -Gwhite >> $out
echo "-0.6 -1.5 18 0 5 "ML" = $eta"| pstext -R -J -O -Gwhite >> $out

### Plot Spectrums
#psbasemap -R.5/2/0/5e-8 -JX5i/4i -Bxa.2g.1 -Bya1e-8 -Bx+l"Freq (Hz)" -By+l"Amplitude" -BWSen -K -O -Y-4.9i >> $out
#cat ${stn1}_*_fq-amp_new.dat | psxy -R -J -W1,black  -K -O >> $out
#cat ${stn2}_*_fq-amp_new.dat | psxy -R -J -W1,red -K -O >> $out

#gs $out

cd ..
done

#break

cd ../..
done
