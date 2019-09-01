#!/bin/bash

for d in */
do
( cd $d/events && 
for file in *HE
do
gcarc=`sac<<! | grep GCARC | awk '{print $3}'
r ${file}
lh GCARC
q
!`
evdp=`sac<<! | grep EVDP | awk '{print $3}'
r ${file}
lh EVDP
q
!`
a=`echo ${gcarc} ${evdp} | awk '{if ($1<=20 && $2<=50000) print "1"; else print "0"}'`
if [ $a -eq 0 ]
	then
	mv ${file} ~/Thesis/bengalBasin/XI_2007-2010/BAD
fi
done )
done
