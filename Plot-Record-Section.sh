#!/bin/bash

for d in *
do

ev=`echo ${d}`
cd /home/magneto/Thesis/tarimBasin/XW_1997-2001/XW_all_events_1/${ev}/events
pwd

gmtset FONT_ANNOT_PRIMARY 14p,Times,black
gmtset FONT_LABEL 16p,Times-Bold,black
gmtset MAP_ANNOT_OFFSET_PRIMARY .1
gmtset MAP_TICK_PEN 1p

rm -rf Del_list.dat Time-Dist-Amp.inp
for file in `ls *HZ`
do
dist=`sac<<!|grep DIST|awk '{print $3}'
r $file
lh DIST
q
!`
otime=`sac<<!|grep OMARKER |awk '{print $3}'
r $file
lh OMARKER
q
!`
echo File=$file dist=$dist Origintime=$otime 
echo $file $dist $otime >> Del_list.dat
done
sort -g -k2 Del_list.dat > sort-del_list.dat
rm -rf Del_list.dat

outfile1=Time-Dist-Amp.inp
awk '{print $1}' sort-del_list.dat > rftn.lst
for evt in `cat rftn.lst`
do
delta=`sac<<!|grep DELTA|awk '{print $3}'
r $evt
lh DELTA
q
!`
dist=`sac<<!|grep DIST|awk '{print $3}'
r $evt
lh DIST
q
!`
#### Butterworth filtered between 0.2 to 0.7
sac<<END
r $evt
bp BUTTER co 0.2 .7 n 3 p 2
w $evt.1
r $evt.1
cuterr fillz
cut 0 1200
r
cut off
w over
convert fom sac  $evt.1 to alpha $evt.a
q
END
sacalphafile=$evt.a

begintime=`saclhdr -B $evt.1 | awk '{print $1}'`
#begintime=`sac<<!|grep B|awk '{print $3}'
#r $evt.1
#lh B
#q
#!`
echo evt=$evt.1 delta=$delta dist=$dist beg=$begintime
echo ">" >> $outfile1
awk 'NR > 30 { print $0 }' < $sacalphafile | awk '{ i=1; while (i<NF+1) { print $i; ++i }}' | awk '{ print '$begintime' + '$delta'*(NR-1), $1 }' |awk '{ print '$dist',$1,$2 }' >> $outfile1
#rm -rf $evt.a $evt.1
done


###Plot Record section
scale=200
Timemin=0
Timemax=1200

Dist1=`head -1 sort-del_list.dat|awk '{print $2-10}'`
Dist2=`tail -1 sort-del_list.dat|awk '{print $2+10}'`

dist1=`head -1 sort-del_list.dat|awk '{print $2}'`
dist2=`tail -1 sort-del_list.dat|awk '{print $2}'`
org1=`head -1 sort-del_list.dat|awk '{print $3}'`
org2=`head -1 sort-del_list.dat|awk '{print $3}'`
cutx1=`echo $org1 $dist1 | awk '{print $1+$2/2.6}'`
cutx2=`echo $org1 $dist2 | awk '{print $1+$2/2.6}'`
cutx3=`echo $org2 $dist1 | awk '{print $1+$2/3.4}'`
cutx4=`echo $org2 $dist2 | awk '{print $1+$2/3.4}'`
echo $org $cutx1 $cutx2 $cutx3 $cutx4
d1=`echo $dist1 | awk '{print $1-20}'`
d2=`echo $dist2 | awk '{print $1+20}'`
jj="-JX6.5i/6i"
rrs="-R$d1/$d2/$Timemin/$Timemax"
OUT=Record-Section.ps

psbasemap $jj $rrs -Bxa20f10 -Bya100f50 -By+l"Time (s)" -Bx+l"Distance (km)" -BWS -P -X0.9i -Y1i -V -K > ${OUT}
#pswiggle $outfile1 $jj $rrs -G-180 -Z$scale -K -O >> $OUT
#pswiggle $outfile1 $jj $rrs -G+30 -Z$scale -W.01 -K -O >> $OUT
pswiggle $outfile1 $jj $rrs -Z$scale -W.01 -K -O >> $OUT

psxy $jj $rrs -W1,red,dashed -K -O <<EOF>>$OUT
$Dist1,$cutx3
$Dist2,$cutx4
EOF
echo "$d2 $cutx4 16 0 5 "ML" 3.4 km/s" | pstext $jj $rrs -K -O -N >> $OUT
psxy $jj $rrs -W1,red,dashed -K -O <<EOF>>$OUT
$Dist1,$cutx1
$Dist2,$cutx2
EOF
echo "$d2 $cutx2 16 0 5 "ML" 2.6 km/s" | pstext $jj $rrs -O -N >> $OUT

#gs $OUT

done