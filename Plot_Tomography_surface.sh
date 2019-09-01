#!/bin/bash

gmt clear history
rm -rf latlon_tomo.dat lg_tomo*

N=`cat Modelsoln.txt | wc -l`

for i in $(seq 1 1 $N)
do

lat=`cat Modelsoln.txt | awk -v a=$i 'NR==a {print substr($1,3,5)}'`
lon=`cat Modelsoln.txt | awk -v a=$i 'NR==a {print substr($1,9,5)}'`
Q=`cat Modelsoln.txt | awk -v a=$i 'NR==a {print $3}'`

echo ${lon}"\t"${lat}"\t"$Q >> latlon_tomo.dat

done

rm -rf lg_tomo.cpt

minQ=`awk 'NR==1 || $3 < min {line = $0; min = $3}END{print min}' latlon_tomo.dat`
maxQ=`awk 'NR==1 || $3 > max {line = $0; max = $3}END{print max}' latlon_tomo.dat`
minlon=`awk 'NR==1 || $1 < min {line = $0; min = $1}END{print min}' latlon_tomo.dat`
maxlon=`awk 'NR==1 || $1 > max {line = $0; max = $1}END{print max}' latlon_tomo.dat`
minla=`awk 'NR==1 || $2 < min {line = $0; min = $2}END{print min}' latlon_tomo.dat`
maxla=`awk 'NR==1 || $2 > max {line = $0; max = $2}END{print max}' latlon_tomo.dat`

makecpt -Cseis -T${minQ}/${maxQ}/30 -Z100 | awk '{print $1"\t"$2"\t"$3"\t"$2}' | head -n -3 > lg_tomo.cpt

ps=`echo ~/Thesis/tibet/INDEPTH_III/lgq/surplots/lg_tomo_surface.ps`
cpt=`echo lg_tomo.cpt`
grd=`echo lg_tomo.grd`

rm -rf ${ps}
rm -rf lg_tomo.grd

set FONT_ANNOT_PRIMARY 14p,Times,black
set FONT_LABEL 14p,Times-Bold,Black

pscoast -R88/90.5/30.5/33.5 -JM16 -Ba.5f.5 -W -K -P -Xc -Yc > ${ps}
surface latlon_tomo.dat -R  -I0.025 -G${grd} -T0.25 -Ll0
grdsample ${grd} -Ggrid2dvh.grd -I0.025 -nb+t0.1

grdcut ETOPO1_Bed_g_gmt4.grd -Gtopo0.grd -R
grdsample topo0.grd -Gtopoh.grd -I0.025 -nb+t0.1
#triangulate topo0.grd -Gtopoh.grd -I0.025 -nb+t0.1
grdgradient topoh.grd -Gtopoh.int -A45 -Nt

#grdclip grid2dvh.grd -Ggrid2clip.grd -R88/90.5/30.5/33.5 -Sa700/NaN -Sb5/NaN
grdimage -R -J grid2dvh.grd -Itopoh.int -C${cpt} -B -O -K -P >> ${ps}
grdcontour -R -J grid2dvh.grd -C10 -A60+f13p -K -O >> ${ps}

#plot fault lines
for file in ~/Thesis/tibet/INDEPTH_III/lgq/DATA/*p.txt 
do

cat ${file} | psxy -J -R -K -O -P -W2p,black,- >> ${ps}

done

cat ~/Thesis/tibet/INDEPTH_III/lgq/DATA/coordinate.txt | awk 'NR<14 {print $1"\t"$2"\t"$3}' | gmt pstext -R -J -B -P -F+f25,Times-Bold,black+a0 -W1p,black,solid -Qu -O -K >> ${ps}

#plot stations
cat info.txt | awk '{print $2"\t"$3}' | psxy -R -J -B -St0.5c -Gwhite -O -K >> ${ps}
cat ~/Thesis/tibet/INDEPTH_III/lgq/DATA/coordinate.txt | awk 'NR>13 {print $1"\t"$2"\t"$3}' | gmt pstext -R -J -B -P -F+f18,Times-Bold,black+a0 -Qu -O -K >> ${ps}

psscale -C${cpt} -D8/-1.25/14/0.5h -Bx50+l"Q@-0@" -O >> ${ps}

gs ${ps}

<< 'END'

######## Info for tomography

polygon_cut_range=`gmtinfo latlon_tomo.dat -I.5/.5/.5`
echo ${polygon_cut_range}

gmtinfo latlon_tomo.dat -C | awk '{print $1"\t"$3"\n"$1"\t"$4"\n"$2"\t"$3"\n"$2"\t"$4}' > clip.gmt

rm -rf ${ps}
rm -rf lg_tomo.grd

set FONT_ANNOT_PRIMARY 14p,Times,black
set FONT_LABEL 14p,Times-Bold,Black

pscoast -R87/91.5/30/34 -JM15 -Ba1f1 -W -K -P -Xc -Yc > ${ps}
surface latlon_tomo.dat ${polygon_cut_range} -I0.005 -G${grd} -T0.25 -Ll0
grdsample ${grd} -Ggrid2dvh.grd -I0.005 -nb+t0.1

grdcut ETOPO1_Bed_g_gmt4.grd -Gtopo0.grd ${polygon_cut_range}
#grdmask clip.gmt -Rtopo0.grd -NNaN/1/1 -Gmask.grd
#grdmath topo0.grd mask.grd MUL = etopo1_cut_masked.grd
grdsample topo0.grd -Gtopoh.grd -I0.005 -nb+t0.1
grdgradient topoh.grd -Gtopoh.int -A45 -Nt

#gmtinfo latlon_tomo.dat -I.5/.5/.5 (Number of columns and the increment value) ## output is -R88/90.5/30.5/33.5
#gmtinfo latlon_tomo.dat -C | awk '{print $1"\t"$3"\n"$1"\t"$4"\n"$2"\t"$3"\n"$2"\t"$4}' > clip.gmt

#rm land_mask.grd
#grdmask test.dat -R -I1m -N0.5/0/0 -Gland_mask.grd -V

#grdimage -R -JM15 etopo1_cut_masked.nc -C${cpt} -B -O -K -P >> ${ps}
#grdclip grid2dvh.grd -Ggrid2clip.grd ${polygon_cut_range} -Sa700/5
grdimage -R -JM15 grid2dvh.grd -Itopoh.int -C${cpt} -B -O -K -P >> ${ps}
#grdcontour -R -J ${grd} -C10 -A20 -B -K -O >> ${ps}
psscale -C${cpt} -Dx7.5c/-1.5c+w12c/0.5c+jTC+h -Bx50+l"Q@-0@" -F -O >> ${ps}

gs ${ps}


##resampling grid2dv and etopo to same sample rate
#grdsample grid2dv.grd -Ggrid2dvh.grd -I0.005 -nb+t0.1
#grdcut etopo1.grd -Gtopo0.grd -R
#grdsample topo0.grd -Gtopoh.grd -I0.005 -nb+t0.1
#grdgradient topoh.grd -Gtopoh.int -A45 -Nt

#Using resampled etopo as -I option
#grdclip grid2dvh.grd -Ggrid2clip.grd ${polygon_cut_range} -Sa_/_
#grdimage grid2dvh.grd -Itopoh.int $bounds $proj $cpt -K -P >! $psfile

#################################################################
1. Make my clipping polygon, clip.gmt
2. Do a gmtinfo -I1m clip.gmt
3. grdcut the original etopo1.grd grid with the given -R from the gmtinfo command, grdcut etopo1.grd -Getopo1_cut.grd -R../../../..
4. Make the mask grid, grdmask clip.gmt -Retopo1_cut.grd -NNaN/1/1 -Gmask.nc
5. Apply the mask to get the final grid, grdmath etopo1_cut.grd mask.nc MUL = etopo1_cut_masked.nc
################################################################

The grdmask command sets all values outside the wanted region to NaN and everything on the edge and inside to 1. Then you multiply this mask grid with the original grid to get the final masked grid. A good idea would also be to check the extent of the wanted region and grdcut away all the non-interesting area - or even better, give a new good -R in the grdmath command.

#grdcut ETOPO1_Bed_g_gmt4.grd -Getopo1_cut.grd -R88/90.5/30.5/33.5
#grdmask clip.gmt -Retopo1_cut.grd -NNaN/1/1 -Gmask.nc
#grdmath etopo1_cut.grd mask.nc MUL = etopo1_cut_masked.nc

END
