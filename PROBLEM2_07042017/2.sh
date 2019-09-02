T0=1300
T=1150
k=1e-6

echo "Enter the value of t (in Ma): "
read t

t1=`echo $t | awk '{print (1e6*$1*365*24*60*60)}'`

a=`echo $T $T0 | awk '{print ($1/$2)}'`
a1=`echo $a | awk -F"4" '{print $1}'`
x=`grep $a1 erf.txt | awk '{print $1}'`
z=`echo $k $t1 $x | awk '{print (2*$3*(sqrt($1*$2)))}'`

echo "The value of oceanic lithosphere thickness is $z meters"
