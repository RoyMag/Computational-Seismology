#!/bin/bash

gmt clear history

rm -rf plot.ps
out=`echo plot.ps`
inf=`echo info.txt`
cpt=`echo /home/magneto/Thesis/downloads/mby.cpt`

pscoast  -R65/110/20/50 -JM6i -S102/178/255 -Bp5f5WSEN -P -K > ${out}
grdimage /home/magneto/Thesis/downloads/ETOPO1_Bed_g_gmt4.grd -C${cpt} -J -R -K -O  >> ${out}

for d in ????.???.??.??.??
do

cd /home/magneto/Thesis/tibet/INDEPTH_III/lgq/$d/events
pwd

for file in `ls *.BHZ`
do

evla=`saclhdr -EVLA ${file}`
evlo=`saclhdr -EVLO ${file}`
stla=`saclhdr -STLA ${file}`
stlo=`saclhdr -STLO ${file}`

echo ${evlo} ${evla} ${stlo} ${stla} | awk '{print $1"\t"$2"\t"$3"\t"$4}' >> /home/magneto/Thesis/tibet/INDEPTH_III/lgq/${inf}

done 

cd ../..
pwd

cat ${inf} | awk '{print $1"\t"$2"\n"$3"\t"$4}' | psxy -R -J -B -W.1p,black,solid  -O -K >> /home/magneto/Thesis/tibet/INDEPTH_III/lgq/${out}
cat ${inf} | awk '{print $1"\t"$2}' | psxy -R -J -B -Sa0.7c -G0/0/255 -O -K >> /home/magneto/Thesis/tibet/INDEPTH_III/lgq/${out}


if [ $d =  "1999.095.22.32.52" ]
then
	cat ${inf} | awk '{print $3"\t"$4}' | psxy -R -J -B -St0.1c -G255/0/0 -O >> /home/magneto/Thesis/tibet/INDEPTH_III/lgq/${out}
else
	cat ${inf} | awk '{print $3"\t"$4}' | psxy -R -J -B -St0.1c -G255/0/0 -K -O >> /home/magneto/Thesis/tibet/INDEPTH_III/lgq/${out}
fi

rm -rf ${inf}

done

rm -rf ${inf}
#evince ${out} &

