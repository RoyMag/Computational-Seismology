#!/bin/bash

N=`cat Q_eta.dat | wc -l`

Qmean=`awk 'BEGIN{SUM=0} {SUM=SUM+$1} END{print SUM/'$N'}' Q_eta.dat`
#echo "Bootstrap Q mean is :" ${Qmean}

for i in $(seq 1 1 $N)
do

Qi_Qmean_square=`cat Q_eta.dat | awk -v a=$i -v b=${Qmean} 'NR==a {print ($1-b)**2}'`
echo ${Qi_Qmean_square} >> Q.dat

done

Q_error=`awk 'BEGIN{SUM=0} {SUM=SUM+$1} END{print sqrt(SUM/('$N'-1))}' Q.dat`
echo "Error in Q0 value is: "${Q_error}

rm -rf Q.dat

###########################################################################

etamean=`awk 'BEGIN{SUM=0} {SUM=SUM+$2} END{print SUM/'$N'}' Q_eta.dat`
#echo "Bootstrap eta mean is :" ${Qmean}

for i in $(seq 1 1 $N)
do

etai_etamean_square=`cat Q_eta.dat | awk -v a=$i -v b=${etamean} 'NR==a {print ($2-b)**2}'`
echo ${etai_etamean_square} >> eta.dat

done

eta_error=`awk 'BEGIN{SUM=0} {SUM=SUM+$1} END{print sqrt(SUM/('$N'-1))}' eta.dat`
echo "Error in eta value is: "${eta_error}
echo ${Q_error}"\t"${eta_error} > Q_eta_error.dat

rm -rf eta.dat Q_eta.dat

