#!bin/sh

rm plotgmt1.ps
pscoast -R68/92/20/40 -JM15 -W0.05,black,solid  -Ba4f4/a4f4WESN -Dh -P -K -Xa2 -Ya2  >> plotgmt1.ps

grdsample grid2dv.grd -R  -Gs_grid2dv.grd  -I0.005 -nb+t0.1

grdcut /home/subhadeep/STUDY/NEW_STATIONS/ETOPO1_Bed_g_gmt4.grd  -R -Gc_etopo.grd
grdsample c_etopo.grd -Gs_etopo.grd -I0.005 -nb+t0.1
grdgradient s_etopo.grd -Gtopoh.int -A45 -Nt

grdmask  -R -I0.005 -N0/0/1 -Gm_grid2dv.grd  -V << !
76 28
76 35
87 35
87 28
76 28
!

grdmath m_grid2dv.grd  s_grid2dv.grd  MUL = ms_grid2dv.grd 

grdimage -R -J ms_grid2dv.grd -Itopoh.int -Ccolorbar.cpt -B -O -K -P -Xa2 -Ya2 >> plotgmt1.ps
for files in /home/subhadeep/STUDY/THESIS/PRESENTATION/DATA/*p.txt
do
cat $files | psxy -J -R -K -O -P -W.5p,black,solid -Xa2 -Ya2 >> plotgmt1.ps
done
cat /home/subhadeep/STUDY/THESIS/PRESENTATION/DATA/coordinate.txt | awk '{print $1"\t"$2"\t"$3}' | gmt pstext -R -J -B -P -F+f12,black+a0 -W1p,blue,solid -Qu -K -O -Xa2 -Ya2 >> plotgmt1.ps
psscale -Ccolorbar.cpt -Ba0.03f0.03 -D8/18/12/0.3h -O -P -Xa2 -Ya2   >> plotgmt1.ps
rm *_*.grd topoh.int
evince plotgmt1.ps &

