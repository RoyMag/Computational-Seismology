N=`cat data.txt | wc -l`

sumz=`cat data.txt | awk 'BEGIN{SUM=0}{SUM=SUM+$1}END {print SUM}'`
sumd=`cat data.txt | awk 'BEGIN{SUM=0}{SUM=SUM+$2}END {print SUM}'`
sumzd=`cat data.txt | awk 'BEGIN{SUM=0}{SUM=SUM+($1*$2)}END {print SUM}'`
sumzz=`cat data.txt | awk 'BEGIN{SUM=0}{SUM=SUM+($1*$1)}END {print SUM}'`

m1=`echo $sumzz $sumd $sumz $N | awk '{print ((($1*$2)-($3*$3))/(($4*$1)-($3*$3)))}'`
m2=`echo $sumzz $sumd $sumz $N | awk '{print ((($4*$3)-($3*$2))/(($4*$1)-($3*$3)))}'`

echo "The slope of the straight line to be fit is $m1"
echo "The intercept of the straight line to be fit is $m2"
