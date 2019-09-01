#!/bin/bash

rm -rf contour.cpt
minQ=`awk 'NR==1 || $3 < min {line = $0; min = $3}END{print min}' contour.txt`
maxQ=`awk 'NR==1 || $3 > max {line = $0; max = $3}END{print max}' contour.txt`

makecpt -Cjet -T${minQ}/${maxQ}/10 -Z100 > contour.cpt

ps=contour.ps
cpt=`echo contour.cpt`
rm -rf ${ps}
rm -rf surf.grd

gmt set FONT_ANNOT_PRIMARY 14p,Times,black
gmt set FONT_LABEL 16p,Times-Bold,Black

pscoast -R88/91/31/34 -JM15 -Ba1f0.5 -W -K -P -Xc -Yc > surf.ps

#pscontour contour.txt -R88/91/31/34 -P -JM17 -Ba1f0.5 -BWSne -C${cpt} -W -O >> ${ps}
surface contour.txt -R88/91/31/34 -I0.1 -Gsurf.grd
#grdfilter surf.grd -Gfilter.grd -D0 -Fc1
#grdgradient ETOPO1_Bed_g_gmt4.grd -Nt1 -A135 -GtopoFinal.grd
#grdview filter.grd -R -J -B -C${cpt} -Qs -O -K -Xc -Yc >> surf.ps
grdimage -R88/91/31/34 -JM15 surf.grd -C${cpt} -O -K -P >> surf.ps
grdcontour -R -J surf.grd -C20 -A40 -K -O >> surf.ps
#grdview topoFinal.grd -J -Gfilter.grd -C${cpt} -Qs -K -O >> surf.ps
gmt psscale -C${cpt} -Dx8c/-1c+w12c/0.5c+jTC+h -Bx40+l"Q0" -O >> surf.ps
gs surf.ps
gmt clear history

