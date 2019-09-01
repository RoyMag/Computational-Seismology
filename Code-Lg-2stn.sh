#!/bin/bash
##### NGRI data

#for d in *
#do

#echo ${d}
#sleep 1s

#ev=`echo ${d}`
#cd /home/magneto/Thesis/tarimBasin/XW_1997-2001/XW_all_events_1/${ev}/${ev}

for pair in *
do

echo ${pair}
sleep 1s

cd ${pair}

rm -rf Q-cal-fr.dat Stn-Eq-Dist.dat Freq-Q.dat

for file in `ls *.????.???.??.??.??.?HZ | awk -F"." '{print $2"."$3"."$4"."$5"."$6}'|uniq`
do

for stn in `ls *.????.???.??.??.??.?HZ | awk -F"." '{print $1}'|sort |uniq`
do
pz=`echo /home/magneto/Thesis/tarimBasin/XW_1997-2001/poleZero/${stn}*HZ*`
####Remove Instrument Response
#add before w ${stn} .. transfer from polezero subtype PZ_SHZ.pz to none freq 0.0025 0.005 20 25
sac<<EOF
r ${stn}.${file}*HZ
rmean
rtr
taper
hp co .5
transfer from polezero subtype $pz to none freqlimits .2 .5 100 101
#mul 1.0e9
w ${stn}_${file}_rm.z
quit
EOF
####Cut Lg using Gp 2.9 and 3.6 km/s
otime=`sac<<! | grep "OMARKER" | awk '{print $3}'
r ${stn}_${file}_rm.z
lh OMARKER
quit
!`
echo "Origin time = $otime"
dist=`sac<<! | grep "DIST" | awk '{printf "%8.2f ",$3}'
r ${stn}_${file}_rm.z
lh DIST
quit
!`
echo $stn $file $dist >> Stn-Eq-Dist.dat
Stime=`(echo "($dist/3.4) + $otime " | bc)`
Etime=`(echo "($dist/2.6) + $otime " | bc)`
echo "Cut time for dist=$dist and omarker=$otime is $Stime and $Etime"
sac<<EOF
r ${stn}_${file}_rm.z
cuterr fillz
cut B $Stime $Etime
r
taper type COSINE width 0.05
cut off
w ${stn}_${file}_Lg.z
quit
EOF

### Apply fft to find spectral amplitude
sac<<EOF
r ${stn}_${file}_Lg.z
fft amph
wsp ${stn}_${file}_Lg
convert from sac ${stn}_${file}_Lg.am to alpha ${stn}_${file}_Lg.asc
quit
EOF
####Frequency Amplitude data file
delta=`sac<<! | grep "DELTA" | awk '{print $3}'
r ${stn}_${file}_Lg.am
lh DELTA
quit
!`

begintime=0
awk 'NR > 30 { print $0 }' < ${stn}_${file}_Lg.asc | awk '{ i=1; while (i<NF+1) { print $i; ++i }}' | awk '{ print '$begintime' + '$delta'*(NR-1), $1 }' | awk '{ print $1,$2 }' > ${stn}_${file}_fq-amp.dat

### Smoothen the Freq Amplitude data uisng moving window filter
rm -rf N_freq_Amp.dat ${stn}_${file}_fq-amp_new.dat
cat ${stn}_${file}_fq-amp.dat > fish1
head -7 fish1 > Beg-File

while [ -s fish1 ]
do
head -7 fish1 > fish2
tail -n +8 fish1 > fish2a
cat fish2a | head -8 > fish3
Nfreq=`head -1 fish3 | awk '{print $1}'`
AvgAmp=`cat fish2 fish3 |awk 'BEGIN{SUM=0}{SUM=SUM+$2}END{print SUM/15}'`
echo "$Nfreq $AvgAmp"
echo "$Nfreq $AvgAmp" >> N_freq_Amp.dat
tail -n +2 fish2 > fish1
cat fish2a >> fish1
rm -rf fish2 fish2a fish3
done

head -n -7 N_freq_Amp.dat > N_freq_Amp2.dat
cat Beg-File N_freq_Amp2.dat > ${stn}_${file}_fq-amp_new.dat
rm -rf Beg-File N_freq_Amp2.dat fish1
#####END
#rm -rf ${stn}_${file}_rm.? ${stn}_${file}_Lg*
done
###Station over

###
dist1=`cat Stn-Eq-Dist.dat | sort -g -k2 | head -1 | awk '{print $2}'`
dist2=`cat Stn-Eq-Dist.dat | sort -g -k2 | tail -1 | awk '{print $2}'`
stn1=`cat Stn-Eq-Dist.dat | sort -g -k2 | head -1 | awk '{print $1}'`
stn2=`cat Stn-Eq-Dist.dat | sort -g -k2 | tail -1 | awk '{print $1}'`

done

cd ..
done

#cd ../..
#done
