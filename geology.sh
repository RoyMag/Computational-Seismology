#!/bin/sh
rm geology_plot.ps
gmt clear history
gmtset FONT_ANNOT_PRIMARY 14p,Times,black
gmtset FONT_LABEL 16p,Times-Bold,black
s="/home/magneto/Thesis/downloads/mby.cpt" 

gmt pscoast -JM6.5i -R72/100/20/42 -Bp5/5WESN  -Df+  -S102/178/255  -K -P > geology_plot.ps
gmt grdimage /home/magneto/Thesis/downloads/ETOPO1_Bed_g_gmt4.grd -C$s -J -R -B  -O -K -P >> geology_plot.ps #-S doesn't work for this line.

for files in *p.txt 
do
cat $files | psxy -J -R -K -O -P -W1.5p,black,solid >> geology_plot.ps
done

for file in /home/magneto/Thesis/tb/*p.txt
do
cat $file | psxy -J -R -K -O -P -W1.5p,black,solid >> geology_plot.ps
done

for file in ~/Thesis/bengalBasin/XI_2007-2010/XI_all_events_1/*p.txt
do
cat $file | psxy -J -R -K -O -P -W1.5p,black,solid >> geology_plot.ps
done

cat ../infofull.txt  | awk '{print $2,$3}' | gmt psxy -R -J -B -P -St0.3c -G255/0/0  -O -K >> geology_plot.ps
cat coordinate.txt | awk 'NR<15 {print $1"\t"$2"\t"$3}' | gmt pstext -R -J -B -P -F+f16,Times-Bold,black+a0 -Qu -O -K >> geology_plot.ps
cat coordinate.txt | awk 'NR==15 {print $1"\t"$2"\t""TARIM BASIN"}' | gmt pstext -R -J -B -P -F+f16,Times-Bold,black+a0 -W1p,blue,solid -Qu -O -K >> geology_plot.ps
cat coordinate.txt | awk 'NR==16 {print $1"\t"$2"\t""BENGAL BASIN"}' | gmt pstext -R -J -B -P -F+f16,Times-Bold,black+a0 -W1p,blue,solid -Qu -O -K >> geology_plot.ps
cat coordinate.txt | awk 'NR==17 {print $1"\t"$2"\t""TIBET"}' | gmt pstext -R -J -B -P -F+f16,Times-Bold,black+a0 -W1p,blue,solid -Qu -O  >> geology_plot.ps
psconvert -A -Tg geology_plot.ps
gs geology_plot.ps
#gmt clear history
