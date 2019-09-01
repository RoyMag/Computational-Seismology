#!/bin/bash

#ls > events.txt
#sed -i 's/events.txt/ /g' events.txt


for d in $(cat events.txt | tail -n +1)
do

echo $d
cd $d/$d

max=`cat ../../events.txt | wc -l`
current=`cat ../../events.txt | grep -n ^$d | awk -F":" '{print $1}'`
echo ${current}"/"${max}

#ev=`echo ${d}`
#cd /home/magneto/Thesis/tarimBasin/XW_1997-2001/XW_all_events_1/${ev}/${ev}
rm twoPair.txt
rm ../goodPair.txt ../badPair.txt

ls > twoPair.txt
#N=`cat twoPair.txt | wc -l`
sed -i 's/twoPair.txt/ /g' twoPair.txt

for d in $(cat twoPair.txt | tail -n +1)
do 

echo $d
cd $d

#gmt clear history
total=`cat ../twoPair.txt | wc -l`
nr=`cat ../twoPair.txt | grep -n ^$d | awk -F":" '{print $1}'`
echo ${nr}"/"${total}

stn1=`cat Stn-Eq-Dist.dat | sort -g -k3 | head -1 | awk '{print $1}'`
stn2=`cat Stn-Eq-Dist.dat | sort -g -k3 | tail -1 | awk '{print $1}'`
evt=`cat Stn-Eq-Dist.dat | sort -g -k3 | head -1 | awk '{print $2}'`

#rm -rf ${stn1}"_"${stn2}_amp_freq.ps

gs ${stn1}"-"${stn2}.ps
read -p "Is this good? ( press 'y' for yes; 'n' for no and hit Enter): " q

if [ $q = "y" ]
then
	cd ..
	echo ${stn1} ${stn2} | awk '{print $1"\n"$2}' | sort -g | awk 'ORS=" " {print $1}' | awk '{print $1"-"$2}' >> ../goodPair.txt
elif [ $q = "n" ]
then
	gmtset FONT_ANNOT_PRIMARY 16,Times,black
	gmtset FONT_LABEL 18,Times,black
	gmtset MAP_ANNOT_OFFSET_PRIMARY .1
	gmtset MAP_TICK_PEN 1p
	
	out=`echo ${stn1}"_"${stn2}_amp_freq.ps`
	psbasemap -R0.5/2/0/10e-8 -JX7i/6i -Bxa.5f.5g.1 -Bya2e-8 -Bx+l"Freq (Hz)" -By+l"Amplitude" -BWSen -K -Xc -Yc > ${out}
	cat ${stn1}_${evt}_fq-amp_new.dat | psxy -R -J -W1,black  -K -O >> ${out}
	cat ${stn2}_${evt}_fq-amp_new.dat | psxy -R -J -W1,red -K -O >> ${out}
	gs ${out}
	
	read -p "Enter the new lower frequency limit (press '0' for completely bad pair and hit Enter): " r1
	read -p "Enter the new upper frequency limit (press '0' for completely bad pair and hit Enter): " r2
	gmt clear history
	#if [ $r1 && $r2 !=0 ]
	#then
	#read -p "Is the plot good: " r3
	#while [ $r3 = "q" ]
	#do
	#sed -i "76/s/0.5/$r1" ../../../New_plot.sh
	#sed -i "77/s/0.5/$r1" ../../../New_plot.sh
	#sed -i "82/s/0.5/$r1" ../../../New_plot.sh
	#sed -i "76/s/2.0/$r2" ../../../New_plot.sh
	#sed -i "77/s/2.0/$r2" ../../../New_plot.sh
	#sed -i "82/s/2.0/$r2" ../../../New_plot.sh
	#echo "sh" "../../../New_plot.sh" | sh
	#done
	#fi

	cd ..
	
	echo ${stn1} ${stn2} | awk '{print $1"\n"$2}' | sort -g | awk 'ORS=" " {print $1}' | awk -v a=$r1 -v b=$r2 '{print $1"-"$2"\t"a"\t"b}' >> ../badPair.txt
fi

done

#mv twoPair.txt ../ #goodPair.txt badPair.txt ../

#break

cd ../..
done
